// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:dio_client/index.dart';
import 'package:flutter/services.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:rxdart/rxdart.dart';
import 'package:super_clipboard/super_clipboard.dart';

import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/file_service.dart';
import 'package:hyper_media/utils/logger.dart';

import '../data/models/models.dart';

class DownloadService {
  DownloadService(
      {required DioClient dioClient,
      required DatabaseUtils database,
      required JsRuntime jsRuntime})
      : _dioClient = dioClient,
        _jsRuntime = jsRuntime,
        _database = database;

  final _logger = Logger("DownloadService");
  final DioClient _dioClient;
  final DatabaseUtils _database;
  final JsRuntime _jsRuntime;
  Download? _currentDownload;
  ComicTaskConcurrent? _comicTaskConcurrent;

  final StreamController<Download?> _controllerDownload =
      StreamController.broadcast();

  Stream<Download?> get downloadStream => _controllerDownload.stream;

  Download? get currentDownload => _currentDownload;

  CancelableOperation? _cancelableOperation;

  Future<List<Download>> downloads() async {
    return await _database.getDownloads();
  }

  Future<Uint8List?> downloadImageByUrl(String url,
      {Map<String, String>? headers}) async {
    try {
      final res = await _dioClient.get(url,
          options: Options(headers: headers, responseType: ResponseType.bytes));
      if (res is! Uint8List) return null;
      return Uint8List.fromList(res);
    } catch (err) {
      return null;
    }
  }

  Future<bool> saveImage(String url, {Map<String, String>? headers}) async {
    try {
      final bytes = await downloadImageByUrl(url, headers: headers);
      if (bytes == null) return false;
      final isSave = await FileService.saveImage(bytes);
      return isSave;
    } catch (err) {
      return false;
    }
  }

  Future<bool> clipboardImage(String url,
      {Map<String, String>? headers}) async {
    try {
      final bytes = await downloadImageByUrl(url, headers: headers);
      if (bytes == null) return false;
      final item = DataWriterItem();
      item.add(Formats.png(bytes));
      await ClipboardWriter.instance.write([item]);
      return true;
    } catch (err) {
      return false;
    }
  }

  void addDownload(
      {required Book book, required List<Chapter> chapters}) async {
    try {
      Download? downloadToBook = await _database.getDownloadByBookId(book.id!);
      if (downloadToBook == null) {
        String image = book.cover;
        if (image.startsWith("http")) {
          final bytes = await downloadImageByUrl(image);
          if (bytes != null) {
            image = base64Encode(bytes);
            book = book.copyWith(cover: image);
          }
        }

        if (book.id == null) {
          final bookId = await _database.onInsertBook(book);
          book = book.copyWith(id: bookId);
          chapters = chapters.map((e) => e.copyWith(bookId: bookId)).toList();
        }

        final download = Download(
            status: DownloadStatus.waiting,
            bookId: book.id!,
            totalChaptersDownloaded: 0,
            totalChaptersToDownload: book.totalChapters,
            bookName: book.name,
            bookImage: book.cover,
            dateTime: DateTime.now());

        await _database.addDownload(download);
      } else {
        switch (downloadToBook.status) {
          case DownloadStatus.downloadErr:
            break;
          case DownloadStatus.downloaded:
            return;
          case DownloadStatus.downloading:
            return;
          case DownloadStatus.waiting:
            return;
          default:
            break;
        }
        if (downloadToBook.status == DownloadStatus.downloaded) return;
        final chapters = await _database.getChaptersDownloadBookId(book.id!);
        if (chapters.isEmpty) return;
      }

      checkCurrentDownload();
    } catch (err) {
      _logger.error(err, name: "addDownload");
    }
  }

  void checkCurrentDownload() async {
    final task = await _database.getTaskDownloadFirst();
    if (task == null) {
      _currentDownload = null;
      return;
    }
    if (_currentDownload != null && task.id == _currentDownload!.id) return;
    _currentDownload = task;
    final book = await _database.onGetBookById(_currentDownload!.bookId);
    if (book == null) {
      _currentDownload = null;
      return;
    }

    final ext = await _database.getExtensionByHost(book.host);
    if (ext == null) {
      _currentDownload = null;
      return;
    }
    final chapters = await _database.getChaptersDownloadBookId(book.id!);
    if (chapters.isEmpty) {
      _currentDownload = null;
      return;
    }
    _logger.log("Start download : ${book.name}");
    _controllerDownload.add(task);
    startDownload(
        chapters: chapters, book: book, extension: ext, download: task);
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
        },
        onDownloaded: () async {
          _logger.log("downloaded");
          _currentDownload = null;
          download = download.copyWith(status: DownloadStatus.downloaded);
          await _database.updateDownload(download);
          _controllerDownload.add(null);
          checkCurrentDownload();
        },
      ),
      onCancel: () async {
        _currentDownload = null;
        // await _database.updateDownload(_currentDownload!
        //     .copyWith(status: DownloadStatus.downloadedCancel));
        _logger.log("_cancelableOperation");
      },
    );
    download = download.copyWith(status: DownloadStatus.downloading);
    await _database.updateDownload(download);
  }

  Future<void> onDownload(
      {required List<Chapter> chapters,
      required int index,
      required ValueChanged<Chapter> onCompleteChapter,
      required VoidCallback onDownloaded,
      required Extension extension,
      required Book book}) async {
    if (index >= chapters.length) {
      onDownloaded.call();
    } else {
      Chapter chapter = await getContentChapter(chapters[index], extension);
      if (extension.metadata.type == ExtensionType.comic) {
        chapter = await downloadComic(chapter, book.id!);
      }
      onCompleteChapter.call(chapter);
      onDownload(
          chapters: chapters,
          index: index + 1,
          onCompleteChapter: onCompleteChapter,
          onDownloaded: onDownloaded,
          extension: extension,
          book: book);
    }
  }

  Future<Chapter> downloadComic(Chapter chapter, int bookId) async {
    if (chapter.contentComic != null && chapter.contentComic!.isNotEmpty) {
      final complete = Completer<Chapter>.sync();
      _comicTaskConcurrent ??= ComicTaskConcurrent(
          dioClient: _jsRuntime.getDioClient, maxConcurrent: 5);
      List<ComicResult> result = [];
      final headers = {"Referer": chapter.host};
      for (var i = 0; i < chapter.contentComic!.length; i++) {
        final url = chapter.contentComic![i];
        _comicTaskConcurrent!
            .add(ComicEntry(
                url: url,
                index: i,
                dirPath: "$bookId/${chapter.id}",
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
      return chapter;
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
      checkCurrentDownload();
      _logger.log("closeCurrentDownload");
    }
  }
}

class ComicEntry {
  final Completer<ComicResult> completer;
  final String url;
  final int index;
  final Map<String, String>? headers;
  final String dirPath;

  ComicEntry(
      {required this.url,
      required this.index,
      this.headers,
      required this.dirPath})
      : completer = Completer.sync();
}

class ComicResult {
  final int index;
  final String? pathImage;

  ComicResult({
    required this.index,
    this.pathImage,
  });
}

class ComicTaskConcurrent {
  final requestController = StreamController<ComicEntry>();
  late final StreamSubscription<void> _subscription;
  final DioClient dioClient;

  ComicTaskConcurrent({int? maxConcurrent, required this.dioClient}) {
    Stream<void> sendRequest(ComicEntry entry) {
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

  Future<ComicResult> request(ComicEntry entry) async {
    try {
      final bytes = await dioClient.get(
        entry.url,
        options:
            Options(headers: entry.headers, responseType: ResponseType.bytes),
      );
      final pathFile =
          await FileService.saveImageToTemp(bytes, entry.dirPath.toString());
      return ComicResult(index: entry.index, pathImage: pathFile);
    } catch (e) {
      return ComicResult(index: entry.index);
    }
  }

  Future<ComicResult> add(ComicEntry entry) async {
    requestController.add(entry);
    return entry.completer.future;
  }

  Future<void> close() =>
      _subscription.cancel().then((_) => requestController.close());
}


/*
Luồng xử lý tải xuống

 - Kiểm

*/