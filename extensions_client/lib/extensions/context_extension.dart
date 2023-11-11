import 'package:flutter/material.dart';

extension AppContext on BuildContext {
  TextTheme get appTextTheme => Theme.of(this).textTheme;
  ThemeData get appTheme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}
