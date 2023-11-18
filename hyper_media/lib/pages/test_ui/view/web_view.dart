import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: false, supportZoom: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Official InAppWebView website")),
        body: Center(
          child: InAppWebView(
            key: _webViewKey,
            initialUrlRequest:
                URLRequest(url: WebUri("https://lamphuchai-dev.github.io/")),
            initialSettings: settings,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          ),
        ));
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
