import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hyper_media/data/models/models.dart';

class WatchMovie extends StatefulWidget {
  const WatchMovie({
    Key? key,
    required this.chapter,
  }) : super(key: key);
  final Chapter chapter;

  @override
  State<WatchMovie> createState() => _WatchMovieState();
}

class _WatchMovieState extends State<WatchMovie> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("WatchMovie"),
    );
  }
}

class WatchMovieByHtml extends StatefulWidget {
  const WatchMovieByHtml({super.key, required this.html});
  final String html;

  @override
  State<WatchMovieByHtml> createState() => _WatchMovieByHtmlState();
}

class _WatchMovieByHtmlState extends State<WatchMovieByHtml> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true, supportZoom: false);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InAppWebView(
        key: _webViewKey,
        initialData: InAppWebViewInitialData(data: widget.html),
        initialSettings: settings,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
