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
      {required String bookUrl,
      required DatabaseUtils databaseService,
      required JsRuntime jsRuntime,
      required AppCubitCubit appCubitCubit})
      : _bookUrl = bookUrl,
        _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        _appCubitCubit = appCubitCubit,
        super(DetailInitial());

  final _logger = Logger("DetailBookCubit");

  final DatabaseUtils _databaseService;
  Extension? _extension;
  final JsRuntime _jsRuntime;
  final String _bookUrl;
  AppCubitCubit _appCubitCubit;

  final FToast fToast = FToast();

  AppBrowser? _appBrowser;

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  Extension get getExtension => _extension!;

  void onInit() async {
    emit(DetailLoading());
    final hostBook = _bookUrl.getHostByUrl;
    if (hostBook == null) {
      emit(const DetailError(message: "Book url error"));
      return;
    }
    _extension = await _databaseService.getExtensionByHost(hostBook);
    if (_extension == null) {
      emit(const DetailError(message: "Extension not found"));
      return;
    }

    int? booId;
    // final bookInBookmark = await _databaseService.getBookByUrl(_bookUrl);
    // if (bookInBookmark != null) {
    //   booId = bookInBookmark.id;
    // }

    Book? bookExt = await getDetailByBookUrl();

    if (bookExt == null) {
      emit(const DetailError(message: "Error get data book"));
      return;
    }

    bookExt = bookExt.copyWith(id: booId);
    if (!isClosed) {
      emit(DetailLoaded(book: bookExt));
    }
  }

  Future<Book?> getDetailByBookUrl() async {
    try {
      final result = await _jsRuntime.getDetail<Map<String, dynamic>>(
        url: _bookUrl,
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
        urlRequest: URLRequest(url: WebUri(_bookUrl)),
        settings: _appBrowser!.setting);
    // _appBrowser.openData(data: data)
  }

  void addBookmark() {
    final state = this.state;
    if (state is! DetailLoaded) return;
    _appCubitCubit.addBookmark(book: state.book, extension: _extension!);
  }
}
