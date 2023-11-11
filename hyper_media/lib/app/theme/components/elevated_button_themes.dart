import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'text_themes.dart';

class ElevatedButtonThemes {
  static final light = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    disabledBackgroundColor: AppColors.primary.withOpacity(0.8),
    disabledForegroundColor: Colors.white.withOpacity(0.8),
    minimumSize: const Size(20, Constants.buttonHeight),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.radius)),
    textStyle: TextThemes.light.titleMedium,
    foregroundColor: Colors.white,
  ));

  static final dark = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.8),
          disabledForegroundColor: Colors.white.withOpacity(0.8),
          minimumSize: const Size(20, Constants.buttonHeight),
          textStyle: TextThemes.dark.titleMedium,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.radius))));
}
