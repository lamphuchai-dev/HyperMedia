import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {}

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    // print("Can't load ${request.url}.. Error: ${error.description}");
  }

  @override
  void onProgressChanged(progress) {
    // print("Progress: $progress");
  }

  @override
  void onExit() {
    // print("Browser closed!");
  }

  InAppBrowserClassSettings get setting {
    return InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(
            hideUrlBar: false,
            toolbarTopBackgroundColor: Colors.white,
            toolbarTopTranslucent: true),
        webViewSettings: InAppWebViewSettings(javaScriptEnabled: true));
  }
}
