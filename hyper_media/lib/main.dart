import 'dart:async';
import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'app.dart';
import 'app/bloc/debug/bloc_observer.dart';
import 'app/constants/constants.dart';
import 'di/components/service_locator.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
  await DesktopWindow.setMinWindowSize(const Size(600, 500));
}

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WebView.debugLoggingSettings.enabled = false;
  await EasyLocalization.ensureInitialized();

  await setupLocator();
  Bloc.observer = const AppBlocObserver();
  MediaKit.ensureInitialized();
  if (Platform.isMacOS) {
    await _configureMacosWindowUtils();
  }

  runApp(
    EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Constants.defaultLocal,
        child: const App()),
  );
}
