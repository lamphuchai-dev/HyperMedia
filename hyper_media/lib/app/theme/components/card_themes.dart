import 'package:flutter/material.dart';

import 'package:hyper_media/app/constants/index.dart';

class CardThemes {
  static CardTheme light = CardTheme(
      color: AppColors.light.cardBackground,
      shape: Constants.shape,
      margin: EdgeInsets.zero,
      elevation: Constants.elevation);
  static CardTheme dark = CardTheme(
      color: AppColors.dark.cardBackground,
      shape: Constants.shape,
      margin: EdgeInsets.zero,
      elevation: Constants.elevation);
}
