import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'app.dart';
import 'app/bloc/debug/bloc_observer.dart';
import 'app/constants/constants.dart';
import 'app/di/components/service_locator.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WebView.debugLoggingSettings.enabled = false;
  await EasyLocalization.ensureInitialized();

  await setupLocator();
  Bloc.observer = const AppBlocObserver();

  runApp(
    EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Constants.defaultLocal,
        child: const App()),
  );
}
