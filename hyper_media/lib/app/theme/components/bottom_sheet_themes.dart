import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';


class BottomSheetThemes {
  static final light = BottomSheetThemeData(
      backgroundColor: AppColors.light.background,
      shape: Constants.bottomSheetShape);

  static final dark = BottomSheetThemeData(
      backgroundColor: AppColors.dark.background,
      shape: Constants.bottomSheetShape);
}
