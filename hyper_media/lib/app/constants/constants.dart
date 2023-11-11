import 'package:flutter/material.dart';

import 'colors.dart';

class Constants {
  const Constants._();
  static const defaultLocal = Locale('vi', 'VN');
  static const supportedLocales = <Locale>[
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];

  static const elevation = 0.2;

  static const buttonHeight = 53.0;

  static const bottomSheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)));

  static const double radius = 8;
  static BorderRadiusGeometry borderRadius = BorderRadius.circular(radius);
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 16.0;

  static RoundedRectangleBorder shape =
      RoundedRectangleBorder(borderRadius: borderRadius);

  static RoundedRectangleBorder shapeBottomSheet =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius * 2));

  static OutlineInputBorder borderInputDecoration = OutlineInputBorder(
      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(radius));

  static OutlineInputBorder errorBorderInputDecoration = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.error, width: 1),
      borderRadius: BorderRadius.circular(radius));

  static OutlineInputBorder focusedBorderInputDecoration = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary),
      borderRadius: BorderRadius.circular(radius));
}
