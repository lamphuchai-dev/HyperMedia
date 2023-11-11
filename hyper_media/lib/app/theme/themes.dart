import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'components/app_bar_themes.dart';
import 'components/bottom_sheet_themes.dart';
import 'components/card_themes.dart';
import 'components/color_schemes.dart';
import 'components/elevated_button_themes.dart';
import 'components/input_decoration_themes.dart';
import 'components/outlined_button_themes.dart';
import 'components/text_themes.dart';

class Themes {
  static final light = ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primary,
      primaryColorDark: AppColors.primary,
      splashColor: Colors.transparent,
      shadowColor: Colors.grey.shade200,
      scaffoldBackgroundColor: AppColors.light.background,
      textTheme: TextThemes.light,
      colorScheme: ColorSchemes.light,
      appBarTheme: AppBarThemes.light,
      cardTheme: CardThemes.light,
      disabledColor: AppColors.light.disabledColor,
      elevatedButtonTheme: ElevatedButtonThemes.light,
      outlinedButtonTheme: OutlinedButtonThemes.light,
      inputDecorationTheme: InputDecorationThemes.light,
      bottomSheetTheme: BottomSheetThemes.light,
      popupMenuTheme: PopupMenuThemeData(
          color: AppColors.light.cardBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
  static final dark = ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primary,
      primaryColorDark: AppColors.primary,
      splashColor: Colors.transparent,
      shadowColor: Colors.black12,
      scaffoldBackgroundColor: AppColors.dark.background,
      textTheme: TextThemes.dark,
      colorScheme: ColorSchemes.dark,
      appBarTheme: AppBarThemes.dark,
      cardTheme: CardThemes.dark,
      disabledColor: AppColors.dark.disabledColor,
      elevatedButtonTheme: ElevatedButtonThemes.dark,
      outlinedButtonTheme: OutlinedButtonThemes.dark,
      inputDecorationTheme: InputDecorationThemes.dart,
      bottomSheetTheme: BottomSheetThemes.dark,
      popupMenuTheme: PopupMenuThemeData(
          color: AppColors.dark.cardBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
}
