import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';

class OutlinedButtonThemes {
  static final light = OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(20, Constants.buttonHeight),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.radius))));

  static final dark = OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(20, Constants.buttonHeight),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.radius))));
}
