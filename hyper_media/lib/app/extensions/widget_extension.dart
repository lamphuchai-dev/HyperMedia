import 'package:flutter/material.dart';

extension ExtensionWidget on Iterable<Widget> {
  Iterable<Widget> expandedEqually() => map((w) => Expanded(flex: 1, child: w));
}
