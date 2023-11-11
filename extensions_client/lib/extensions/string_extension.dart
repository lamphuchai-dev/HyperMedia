import 'package:flutter/material.dart';

extension AppString on String {
  String get toCapitalized {
    try {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    } catch (error) {
      return this;
    }
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');

  bool get isStringNull => this == "" ? true : false;
  String? get stringOrNull => this == "" ? null : this;
  Color get hexColor =>
      Color(int.parse(toUpperCase().replaceAll("#", "FF"), radix: 16));
}
