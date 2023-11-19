import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../cubit/watch_movie_cubit.dart';

class WatchMovieByM3u8 extends StatefulWidget {
  const WatchMovieByM3u8({super.key, required this.server});
  final MovieServer server;

  @override
  State<WatchMovieByM3u8> createState() => _WatchMovieByM3u8State();
}

class _WatchMovieByM3u8State extends State<WatchMovieByM3u8> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      supportZoom: false,
      userAgent:
          "Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36");
  String url = "https://lamphuchai-dev.github.io/";
  @override
  void initState() {
    url = "$url?video=${widget.server.data}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: InAppWebView(
          key: _webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(url)),
          initialSettings: settings,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
