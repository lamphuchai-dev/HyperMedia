import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PlatformBuildWidget extends StatelessWidget {
  const PlatformBuildWidget({
    super.key,
    required this.mobileBuilder,
    required this.macosBuilder,
  });

  final WidgetBuilder mobileBuilder;
  final WidgetBuilder macosBuilder;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return mobileBuilder(context);
    }
    return macosBuilder(context);
  }
}

class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    super.key,
    required this.mobileWidget,
    required this.macosWidget,
  });

  final Widget mobileWidget;
  final Widget macosWidget;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return mobileWidget;
    }
    return macosWidget;
  }
}
