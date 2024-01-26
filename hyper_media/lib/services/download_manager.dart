// ignore_for_file: unused_element

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:dio_client/index.dart';
import 'package:flutter/services.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/services/local_notification.service.dart';
import 'package:hyper_media/utils/directory_utils.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/database_service.dart';
import '../utils/file_service.dart';
import '../utils/logger.dart';

class DownloadManager {
  DownloadManager(
      {required DioClient dioClient,
      required DatabaseUtils database,
      required JsRuntime jsRuntime,
      required LocalNotificationService localNotificationService})
      : _dioClient = dioClient,
        _jsRuntime = jsRuntime,
        _database = database,
        _localNotificationService = localNotificationService;

  final _logger = Logger("DownloadManager");
  final DioClient _dioClient;
  final DatabaseUtils _database;
  final JsRuntime _jsRuntime;
  Download? _currentDownload;
  final Queue<Download> _queueDownload = Queue<Download>();
  final LocalNotificationService _localNotificationService;

  CancelableOperation? _cancelableOperation;

  _ComicTaskConcurrent? _comicTaskConcurrent;

  final _controllerDownload = BehaviorSubject<Download?>();

  Stream<Download?> get downloadStream => _controllerDownload.stream;

  // Dùng Stream BehaviorSubject để lấy giá trị cuối cùng khi thêm một StreamSubscription
  final _waitingDownloadStreamController = BehaviorSubject<List<Download>>();
  Stream<List<Download>> get waitingDownload =>
      _waitingDownloadStreamController.stream;

  Future<void> _getDownloading() async {
    final down =
        await _database.getDownloadByStatus(DownloadStatus.downloading);
    if (down.isNotEmpty) {
      _currentDownload = down.first;
    }
  }

  Future<void> _getWaitingDownload() async {
    final down = await _database.getDownloadByStatus(DownloadStatus.waiting);
    if (down.isNotEmpty) {
      _queueDownload.addAll(down);
      _waitingDownloadStreamController.add(down);
    }
  }

  void onInit() async {
    await Future.wait([_getDownloading(), _getWaitingDownload()]);
    _nextDownload(init: true);
  }

  void _nextDownload({bool init = false}) async {
    if (!init && _currentDownload != null) {
      return;
    }

    if (_currentDownload == null && _queueDownload.isNotEmpty) {
      _currentDownload = _queueDownload.first;
      _queueDownload.removeFirst();
      _waitingDownloadStreamController.add(_queueDownload.toList());
    }

    if (_currentDownload == null) {
      return;
    }
    // start download
    final book = await _database.onGetBookById(_currentDownload!.bookId);
    if (book == null) {
      _currentDownload = null;
      // Có lỗi tải xuống, Thử lại sau
      return;
    }

    final ext = await _database.getExtensionByHost(book.host);
    if (ext == null) {
      _currentDownload = null;
      // Không tìm thấy extension cho book này
      return;
    }
    final chapters = await _database.getChaptersDownloadBookId(book.id!);

    startDownload(
        chapters: chapters,
        book: book,
        extension: ext,
        download: _currentDownload!);
  }

  void addDownload(Book book) async {
    if (_currentDownload != null && _currentDownload!.bookId == book.id!) {
      // Đang tải xuống
      return;
    }
    final downloadWithBook =
        _queueDownload.firstWhereOrNull((item) => item.bookId == book.id!);
    if (downloadWithBook != null) {
      // Đã thêm vào hàng chờ
      return;
    }

    // Tạo download
    final download = Download(
        status: DownloadStatus.waiting,
        bookId: book.id!,
        totalChaptersDownloaded: 0,
        totalChaptersToDownload: book.totalChapters,
        bookName: book.name,
        bookImage: book.cover,
        dateTime: DateTime.now());

    // Thêm vào database
    final downloadId = await _database.addDownload(download);

    // Thêm vào queue
    _queueDownload.add(download.copyWith(id: downloadId));
    _waitingDownloadStreamController.add(_queueDownload.toList());

    // Kiểm tra và tải xuống
    if (_currentDownload != null) return;
    _nextDownload();
  }

  void startDownload(
      {required List<Chapter> chapters,
      required Extension extension,
      required Book book,
      required Download download}) async {
    _cancelableOperation = CancelableOperation.fromFuture(
      onDownload(
        chapters: chapters,
        index: 0,
        extension: extension,
        book: book,
        onCompleteChapter: (chapter) async {
          if (_currentDownload == null) return;
          _logger.log("downloaded chapter id : ${chapter.id}");
          _database.updateChapter(chapter.copyWith(isDownload: true));
          download = download.copyWith(
              totalChaptersDownloaded: download.totalChaptersDownloaded + 1);
          await _database.updateDownload(download);
          _controllerDownload.add(download);
          _currentDownload = download;
          pushNotification(false);
        },
        onDone: () async {
          _logger.log("downloaded");
          download = download.copyWith(status: DownloadStatus.downloaded);
          await _database.updateDownload(download);
          _currentDownload = null;
          _controllerDownload.add(null);
          await _localNotificationService.closeDownloadNotification();
          _localNotificationService.showDownloadDone(
              download.bookId, "Tải xong", download.bookName);
          _nextDownload();
        },
        onError: (value) {},
      ),
      onCancel: () async {
        _currentDownload = null;
        // await _database.updateDownload(_currentDownload!
        //     .copyWith(status: DownloadStatus.downloadedCancel));
        _logger.log("_cancelableOperation");
      },
    );
    download = download.copyWith(status: DownloadStatus.downloading);
    _controllerDownload.add(download);
    pushNotification(true);
    await _database.updateDownload(download);
  }

  Future<void> onDownload(
      {required List<Chapter> chapters,
      required int index,
      required ValueChanged<Chapter> onCompleteChapter,
      required ValueChanged<Chapter> onError,
      required VoidCallback onDone,
      required Extension extension,
      required Book book}) async {
    if (chapters.isEmpty) {
      onDone();
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }
    if (index >= chapters.length) {
      onDone.call();
    } else {
      try {
        Chapter chapter = await getContentChapter(chapters[index], extension);
        if (extension.metadata.type == ExtensionType.comic) {
          chapter = await downloadComic(chapter, book.id!);
        }
        onCompleteChapter.call(chapter);
      } catch (err) {
        onError.call(chapters[index]);
      }
      onDownload(
          chapters: chapters,
          index: index + 1,
          onCompleteChapter: onCompleteChapter,
          onDone: onDone,
          extension: extension,
          book: book,
          onError: onError);
    }
  }

  Future<Chapter> downloadComic(Chapter chapter, int bookId) async {
    if (chapter.contentComic != null && chapter.contentComic!.isNotEmpty) {
      final complete = Completer<Chapter>.sync();
      _comicTaskConcurrent ??= _ComicTaskConcurrent(
          dioClient: _jsRuntime.getDioClient, maxConcurrent: 5);
      List<_ComicResult> result = [];
      final headers = {"Referer": chapter.host};
      final dirDownloads = await DirectoryUtils.getDirDownloads;
      for (var i = 0; i < chapter.contentComic!.length; i++) {
        final url = chapter.contentComic![i];
        _comicTaskConcurrent!
            .add(_ComicEntry(
                url: url,
                index: i,
                dirPath: "$dirDownloads/$bookId/${chapter.index}/$i.jpg",
                headers: headers))
            .then((value) {
          result.add(value);
          if (result.length == chapter.contentComic!.length) {
            result = result.sorted((a, b) => a.index.compareTo(b.index));
            final tmp = result.where((e) => e.pathImage != null).toList();
            final list = tmp.map((e) => e.pathImage!).toList();
            chapter = chapter.copyWith(contentComic: list);
            complete.complete(Future.value(chapter));
          }
        });
      }

      return complete.future;
    } else {
      return chapter;
    }
  }

  Future<Chapter> getContentChapter(
      Chapter chapter, Extension extension) async {
    try {
      final result = await _jsRuntime.getChapter<dynamic>(
          url: "${chapter.host}${chapter.url}",
          source: extension.getChapterScript);
      chapter = chapter.addContentByExtensionType(
          type: extension.metadata.type!, value: result);
      return chapter;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> closeCurrentDownload() async {
    if (_currentDownload != null) {
      await _comicTaskConcurrent?.close();
      await _cancelableOperation?.cancel();
      _cancelableOperation = null;
      _comicTaskConcurrent = null;
      await _database.updateDownload(
          _currentDownload!.copyWith(status: DownloadStatus.downloadedCancel));
      _controllerDownload.add(null);
      _nextDownload();
      _logger.log("closeCurrentDownload");
    }
  }

  void pushNotification(bool initStart) {
    if (_currentDownload == null) return;
    if (initStart) {
      _localNotificationService.showOrUpdateDownloadStatus(
          "Đang tải", _currentDownload!.bookName);
    } else if (Platform.isAndroid || Platform.isIOS) {
      _localNotificationService.showOrUpdateDownloadStatus("Đang tải",
          "${_currentDownload!.bookName} ${_currentDownload!.totalChaptersDownloaded}/${_currentDownload!.totalChaptersToDownload}",
          maxProgress: _currentDownload!.totalChaptersToDownload,
          progress: _currentDownload!.totalChaptersDownloaded);
    }
  }

  Future<List<Download>> get getListDownloadComplete =>
      _database.getDownloads();

  Future<bool> deleteDownloadById(int id) => _database.deleteDownloadById(id);

  Future<int> cancelDownload(Download download) async {
    final result = await _database.updateDownload(
        download.copyWith(status: DownloadStatus.downloadedCancel));
    _queueDownload.removeWhere((element) => element.id == download.id);
    _waitingDownloadStreamController.add(_queueDownload.toList());
    return result;
  }
}

class _ComicEntry {
  final Completer<_ComicResult> completer;
  final String url;
  final int index;
  final Map<String, String>? headers;
  final String dirPath;

  _ComicEntry(
      {required this.url,
      required this.index,
      this.headers,
      required this.dirPath})
      : completer = Completer.sync();
}

class _ComicResult {
  final int index;
  final String? pathImage;

  _ComicResult({
    required this.index,
    this.pathImage,
  });
}

class _ComicTaskConcurrent {
  final requestController = StreamController<_ComicEntry>();
  late final StreamSubscription<void> _subscription;
  final DioClient dioClient;

  _ComicTaskConcurrent({int? maxConcurrent, required this.dioClient}) {
    Stream<void> sendRequest(_ComicEntry entry) {
      return request
          .call(entry)
          .asStream()
          .doOnError(entry.completer.completeError)
          .doOnData(entry.completer.complete)
          .onErrorResumeNext(const Stream.empty());
    }

    _subscription = requestController.stream
        .flatMap(sendRequest, maxConcurrent: maxConcurrent)
        .listen(null);
  }

  Future<_ComicResult> request(_ComicEntry entry) async {
    try {
      final bytes = await dioClient.get(
        entry.url,
        options:
            Options(headers: entry.headers, responseType: ResponseType.bytes),
      );
      final pathFile = await FileService.saveImageToTemp(bytes, entry.dirPath);
      return _ComicResult(index: entry.index, pathImage: pathFile);
    } catch (e) {
      return _ComicResult(index: entry.index);
    }
  }

  Future<_ComicResult> add(_ComicEntry entry) async {
    requestController.add(entry);
    return entry.completer.future;
  }

  Future<void> close() =>
      _subscription.cancel().then((_) => requestController.close());
}
