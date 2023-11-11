// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const primary = Color(0xFF7F76E4);
  static const error = Colors.red;

  static AppColor light = const AppColor(
      primary: primary,
      secondary: primary,
      error: error,
      background: Color(0xFFf5f4f8),
      cardBackground: Color(0xFFFFFFFF),
      textColor: Colors.black,
      disabledColor: Colors.grey);

  static AppColor dark = const AppColor(
      primary: primary,
      secondary: primary,
      error: error,
      background: Color(0xFF151a1e),
      cardBackground: Color(0xFF21262a),
      textColor: Color(0xFFF5F5F5),
      disabledColor: Colors.grey);
}

class AppColor {
  final Color primary;
  final Color secondary;
  final Color error;
  final Color background;
  final Color textColor;
  final Color cardBackground;
  final Color disabledColor;

  const AppColor({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.background,
    required this.textColor,
    required this.cardBackground,
    required this.disabledColor,
  });
}


// Background : Background cho app
// On background : Màu cho nội dung ở trong background, không phân block , text ...
// Surface : Màu Background cho khối block trong view (card, .. )
// On Surface : Màu chữ trong các khối block trên view
// Primary : Màu chủ đạo cho App
// On Primary : Màu của text button ...
// Secondary : Màu cho button face
// On Secondary : Màu cho icon của app
