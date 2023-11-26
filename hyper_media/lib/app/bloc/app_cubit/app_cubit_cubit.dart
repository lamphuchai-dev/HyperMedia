import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_media/app.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/book.dart';
import 'package:hyper_media/data/models/chapter.dart';
import 'package:hyper_media/data/models/extension.dart';
import 'package:hyper_media/data/sharedpref/shared_preference_helper.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/widgets/%20toast_widget.dart';
import 'package:js_runtime/js_runtime.dart';

part 'app_cubit_state.dart';

class AppCubitCubit extends Cubit<AppCubitState> {
  AppCubitCubit(
      {required SharedPreferenceHelper sharedPreferenceHelper,
      required JsRuntime jsRuntime,
      required DatabaseUtils database})
      : _preferenceHelper = sharedPreferenceHelper,
        _jsRuntime = jsRuntime,
        _database = database,
        super(const AppCubitState(themeMode: ThemeMode.system));

  final SharedPreferenceHelper _preferenceHelper;

  final FToast _fToast = FToast();
  final JsRuntime _jsRuntime;
  final DatabaseUtils _database;

  // load data local theme, locale
  void onInit(BuildContext context) {
    final nameThemeLocal = _preferenceHelper.themMode;
    if (nameThemeLocal != null) {
      final themeMode = ThemeMode.values
          .firstWhereOrNull((item) => item.name == nameThemeLocal);
      if (themeMode != null && state.themeMode != themeMode) {
        emit(state.copyWith(themeMode: themeMode));

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: AppColors.dark.background,
          ),
        );
      }
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.dark.background,
      ),
    );

    _fToast.init(context);
  }

  // user change theme app
  void onChangeThemeMode(ThemeMode themeMode) {
    _preferenceHelper.changeThemMode(themeMode.name);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<bool> addBookmark(
      {required Book book, required Extension extension}) async {
    try {
      _fToast.showToast(child: const ToastWidget(msg: "Đang thêm bookmark"));

      final result = await _jsRuntime.getChapters<List<dynamic>>(
          url: book.bookUrl, source: extension.getChaptersScript);
      if (result.isNotEmpty) {
        List<Chapter> chapters = [];
        for (var i = 0; i < result.length; i++) {
          final map = result[i];
          if (map is Map<String, dynamic>) {
            if (book.id != null) {
              chapters.add(
                  Chapter.fromMap({...map, "index": i, "bookId": book.id}));
            } else {
              chapters.add(Chapter.fromMap({...map, "index": i}));
            }
          }
        }
        await _database.addBookmark(book: book, chapters: chapters);

        FToast().init(navigatorKey.currentContext!).showToast(
            child: const ToastWidget(msg: "Đang thêm thành công bookmark"));
        return true;
      } else {
        FToast()
            .init(navigatorKey.currentContext!)
            .showToast(child: const ToastWidget(msg: "Lỗi thêm bookmark"));
      }
    } catch (error) {
      FToast()
          .init(navigatorKey.currentContext!)
          .showToast(child: const ToastWidget(msg: "Lỗi thêm bookmark"));
    }
    return false;
  }
}
