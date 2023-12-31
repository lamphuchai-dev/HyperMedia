import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/theme/components/text_themes.dart';
import 'package:macos_ui/macos_ui.dart';

import '../app/theme/components/color_schemes.dart';

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

typedef ThemeBuild = Widget Function(BuildContext context, ThemeData themeData,
    TextTheme textTheme, ColorScheme colorScheme);

class ThemeBuildWidget extends StatelessWidget {
  const ThemeBuildWidget({super.key, required this.builder});
  final ThemeBuild builder;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return builder(context, theme, theme.textTheme, theme.colorScheme);
  }
}
