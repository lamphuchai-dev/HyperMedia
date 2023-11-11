import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/colors.dart';



class AppBarThemes {
  static AppBarTheme light = AppBarTheme(
      elevation: 0,
      centerTitle: true,
      // titleTextStyle: TextStyle(fontSize: 18, color: AppColors.light.textColor),
      backgroundColor: AppColors.light.background);
  static AppBarTheme dark = AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.dark.background);
}
