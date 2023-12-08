import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_media/app/bloc/app_cubit/app_cubit_cubit.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/models.dart';
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
      required AppCubitCubit appCubitCubit})
      : _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        _appCubitCubit = appCubitCubit,
        super(DetailInitial());

  final _logger = Logger("DetailBookCubit");

  final DatabaseUtils _databaseService;
  Extension? _extension;
  final JsRuntime _jsRuntime;
  final String bookUrl;
  AppCubitCubit _appCubitCubit;

  final FToast fToast = FToast();

  AppBrowser? _appBrowser;

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  Extension get getExtension => _extension!;

  void onInit() async {
    emit(DetailLoading());
    final hostBook = bookUrl.getHostByUrl;
    if (hostBook == null) {
      emit(const DetailError(message: "Book url error"));
      return;
    }
    _extension = await _databaseService.getExtensionByHost(hostBook);
    if (_extension == null) {
      emit(const DetailError(message: "Extension not found"));
      return;
    }

    Book? bookExt = await getDetailByBookUrl();

    if (bookExt == null) {
      emit(const DetailError(message: "Error get data book"));
      return;
    }

    final bookInBookmark = await _databaseService.getBookByLink(bookExt.link);
    if (bookInBookmark != null) {
      bookExt = bookInBookmark.copyWith(
        totalChapters: bookExt.totalChapters,
      );
    }

    if (!isClosed) {
      emit(DetailLoaded(book: bookExt));
    }
  }

  Future<Book?> getDetailByBookUrl() async {
    try {
      final result = await _jsRuntime.getDetail<Map<String, dynamic>>(
        url: bookUrl,
        source: _extension!.getDetailScript,
      );
      return Book.fromMap(result);
    } catch (error) {
      _logger.error(error, name: "getDetailBook");
      return null;
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
    final state = this.state;
    if (state is! DetailLoaded) return;
    final book = await _appCubitCubit.addBookmark(
        book: state.book, extension: _extension!, currentIndex: 0);
    if (book != null) {
      emit(DetailLoaded(book: book));
    }
  }
}
