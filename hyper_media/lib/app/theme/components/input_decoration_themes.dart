import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';

class InputDecorationThemes {
  static final light = InputDecorationTheme(
      fillColor: AppColors.light.cardBackground,
      border: Constants.borderInputDecoration,
      enabledBorder: Constants.borderInputDecoration,
      focusedBorder: Constants.focusedBorderInputDecoration,
      errorBorder: Constants.errorBorderInputDecoration,
      focusedErrorBorder: Constants.errorBorderInputDecoration,
      filled: true);

  static final dart = InputDecorationTheme(
      fillColor: AppColors.dark.cardBackground,
      border: Constants.borderInputDecoration,
      enabledBorder: Constants.borderInputDecoration,
      focusedBorder: Constants.focusedBorderInputDecoration,
      errorBorder: Constants.errorBorderInputDecoration,
      focusedErrorBorder: Constants.errorBorderInputDecoration,
      filled: true);
}
