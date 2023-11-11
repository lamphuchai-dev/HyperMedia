import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';


class ColorSchemes {
  static ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.light.primary,
    onPrimary: AppColors.light.textColor,
    secondary: AppColors.light.secondary,
    onSecondary: AppColors.light.textColor,
    error: AppColors.light.error,
    onError: AppColors.light.textColor,
    background: AppColors.light.background,
    onBackground: AppColors.light.textColor,
    surface: AppColors.light.cardBackground,
    onSurface: AppColors.light.textColor,
  );
  static ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.dark.primary,
    onPrimary: AppColors.dark.textColor,
    secondary: AppColors.dark.secondary,
    onSecondary: AppColors.dark.textColor,
    error: AppColors.dark.error,
    onError: AppColors.dark.textColor,
    background: AppColors.dark.background,
    onBackground: AppColors.dark.textColor,
    surface: AppColors.dark.cardBackground,
    onSurface: AppColors.dark.textColor,
  );
}
