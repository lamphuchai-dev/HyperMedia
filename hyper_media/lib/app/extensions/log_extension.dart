import 'dart:developer' as dev show log;
import 'package:flutter/material.dart';

extension Log on Object {
  void log({String? tag}) => dev.log(toString(), name: tag ?? "");
  void print({String? tag}) => debugPrint('${tag != null ? [tag] : ""}$this');
}
