import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/widgets/widget.dart';

import '../cubit/watch_movie_cubit.dart';

class WatchMovieByIframe extends StatefulWidget {
  const WatchMovieByIframe({super.key, required this.server});
  final MovieServer server;

  @override
  State<WatchMovieByIframe> createState() => _WatchMovieByIframeState();
}

class _WatchMovieByIframeState extends State<WatchMovieByIframe> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      supportZoom: false,
      userAgent:
          "Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36");

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final data = '''

    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Mobile Iframe Example</title>
    </head>
    <body>
        <iframe
          style="position: absolute;top: 0;left: 0;width: 100%;height: 100%;"
          src="${widget.server.data}"
          frameborder="0"
          allowfullscreen
        ></iframe>
    </body>
    </html>

''';
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
              child: InAppWebView(
            key: _webViewKey,
            initialData: InAppWebViewInitialData(data: data),
            initialSettings: settings,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              setState(() {
                _loading = true;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;
              if (["about"].contains(uri.scheme)) {
                return NavigationActionPolicy.ALLOW;
              }
              if (widget.server.regex != "" &&
                  uri.toString().checkByRegExp(widget.server.regex)) {
                return NavigationActionPolicy.ALLOW;
              }
              return NavigationActionPolicy.CANCEL;
            },
            onLoadStop: (controller, url) {
              setState(() {
                _loading = false;
              });
            },
            onReceivedError: (controller, request, error) {
              setState(() {
                _loading = false;
              });
            },
          )),
          if (_loading)
            Positioned.fill(
                child: Container(
              color: context.colorScheme.background,
              child: const LoadingWidget(),
            ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
