import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_media/app/bloc/app_cubit/app_cubit_cubit.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/services/download_manager.dart';
import 'package:hyper_media/utils/app_browser.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/logger.dart';
import 'package:js_runtime/js_runtime.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(
      {required this.bookUrl,
      required DatabaseUtils databaseService,
      required JsRuntime jsRuntime,
      required AppCubitCubit appCubitCubit,
      required DownloadManager downloadService})
      : _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        _appCubitCubit = appCubitCubit,
        _downloadService = downloadService,
        super(const DetailState(
            bookState: StateRes(status: StatusType.init),
            chaptersState: StateRes(status: StatusType.init)));

  final _logger = Logger("DetailBookCubit");

  final DatabaseUtils _databaseService;
  Extension? _extension;
  final JsRuntime _jsRuntime;
  final String bookUrl;
  AppCubitCubit _appCubitCubit;

  final DownloadManager _downloadService;

  final FToast fToast = FToast();

  AppBrowser? _appBrowser;

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  Extension get getExtension => _extension!;

  StateRes<Book> get bookState => state.bookState;
  StateRes<List<Chapter>> get chaptersState => state.chaptersState;

  void onInit() async {
    final hostBook = bookUrl.getHostByUrl;
    if (hostBook == null) {
      emit(state.copyWith(
          bookState: bookState.copyWith(
              status: StatusType.error, message: "Book url error")));

      return;
    }
    _extension = await _databaseService.getExtensionByHost(hostBook);
    if (_extension == null) {
      emit(state.copyWith(
          bookState: bookState.copyWith(
              status: StatusType.error, message: "Extension not found")));
      return;
    }

    await Future.wait([_getDetailBook(), _getChapters()]);
  }

  Future<void> _getDetailBook() async {
    try {
      emit(state.copyWith(
          bookState: bookState.copyWith(status: StatusType.loading)));
      final result = await _jsRuntime.getDetail<Map<String, dynamic>>(
        url: bookUrl,
        source: _extension!.getDetailScript,
      );
      Book book = Book.fromMap(result);
      final bookInBookmark = await _databaseService.getBookByLink(book.link);
      if (bookInBookmark != null) {
        book = bookInBookmark.copyWith(
          totalChapters: book.totalChapters,
        );
      }
      emit(state.copyWith(
          bookState:
              bookState.copyWith(status: StatusType.loaded, data: book)));
    } catch (error) {
      _logger.error(error, name: "getDetailBook");
      emit(state.copyWith(
          bookState: bookState.copyWith(
              status: StatusType.error, message: "Error get data book")));
    }
  }

  Future<void> _getChapters() async {
    emit(state.copyWith(
        chaptersState: chaptersState.copyWith(status: StatusType.loading)));
    try {
      final result = await _jsRuntime.getChapters<List<dynamic>>(
          url: bookUrl, source: _extension!.getChaptersScript);
      List<Chapter> chapters = [];
      for (var i = 0; i < result.length; i++) {
        final map = result[i];
        if (map is Map<String, dynamic>) {
          // if (book.id != null) {
          //   chapters
          //       .add(Chapter.fromMap({...map, "index": i, "bookId": book.id}));
          // } else {
          //   chapters.add(Chapter.fromMap({...map, "index": i}));
          // }
          chapters.add(Chapter.fromMap({...map, "index": i}));
        }
      }
      emit(state.copyWith(
          chaptersState: chaptersState.copyWith(
              status: StatusType.loaded, data: chapters)));
    } on JsRuntimeException catch (error) {
      _logger.log(error.message);
    } catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
          chaptersState: chaptersState.copyWith(
              status: StatusType.error, message: "Error get data book")));
    }
  }

  void openBrowser() {
    _appBrowser ??= AppBrowser();
    _appBrowser!.openUrlRequest(
        urlRequest: URLRequest(url: WebUri(bookUrl)),
        settings: _appBrowser!.setting);
    // _appBrowser.openData(data: data)
  }

  Future<void> addBookmark() async {
    final book = await _appCubitCubit.addBookmark(
        book: bookState.data!,
        extension: _extension!,
        currentIndex: 0,
        chapters: chaptersState.data);
    if (book != null) {
      emit(state.copyWith(bookState: bookState.copyWith(data: book)));
    }
  }

  void reverseChapters() {
    emit(state.copyWith(
        chaptersState: chaptersState.copyWith(
            data: chaptersState.data!.reversed.toList())));
  }

  void download() {
    _downloadService.addDownload(state.bookState.data!);
  }
}
