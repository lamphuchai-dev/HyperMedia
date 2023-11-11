import 'package:flutter/foundation.dart';
import 'dart:developer' as dev show log;

class Logger {
  final String _tag;
  Logger(this._tag);

  void log(dynamic value, {String? name}) {
    if (kDebugMode) {
      final tag = name != null ? "$_tag-$name" : _tag;
      dev.log(value.toString(), name: tag);
    }
  }

  void info(dynamic value, {String? name}) {
    if (kDebugMode) {
      final tag = name != null ? "$_tag-$name" : _tag;
      debugPrint('[$tag]} :: ${value.toString()}');
    }
  }

  void error(dynamic value, {String? name}) {
    if (kDebugMode) {
      final tag = name != null ? "$_tag-$name" : _tag;
      dev.log(value.toString(), name: "$tag} :: ERROR");
    }
  }
}
