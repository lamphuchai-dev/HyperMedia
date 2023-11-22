import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:extensions_client/pages/tabs/view/tabs_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS) {
    await DesktopWindow.setWindowSize(const Size(1000, 1000));
    await DesktopWindow.setMinWindowSize(const Size(1000, 800));

    if (runWebViewTitleBarWidget(args)) {
      return;
    }
  }
  WebView.debugLoggingSettings.enabled = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TabsView(),
    );
  }
}
