import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/sharedpref/shared_preference_helper.dart';

part 'app_cubit_state.dart';

class AppCubitCubit extends Cubit<AppCubitState> {
  AppCubitCubit({required SharedPreferenceHelper sharedPreferenceHelper})
      : _preferenceHelper = sharedPreferenceHelper,
        super(const AppCubitState(themeMode: ThemeMode.system));

  final SharedPreferenceHelper _preferenceHelper;

  // load data local theme, locale
  void onInit() {
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
  }

  // user change theme app
  void onChangeThemeMode(ThemeMode themeMode) {
    _preferenceHelper.changeThemMode(themeMode.name);
    emit(state.copyWith(themeMode: themeMode));
  }
}
