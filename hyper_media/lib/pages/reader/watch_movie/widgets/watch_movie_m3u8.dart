part of '../view/watch_movie_view.dart';


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
      mediaPlaybackRequiresUserGesture: true,
      iframeAllowFullscreen: true,
      userAgent:
          "Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36");
  String url = "https://lamphuchai-dev.github.io/";
  bool _loading = false;

  bool _isFullScreen = false;

  @override
  void initState() {
    _createUrl();
    super.initState();
  }

  void _createUrl() {
    url = "$url?video=${widget.server.data}";
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
        mobileWidget: Stack(
          fit: StackFit.expand,
          children: [
            InAppWebView(
              key: _webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(url)),
              initialSettings: settings,
              onWebViewCreated: (controller) {
                _webViewController = controller;
                setState(() {
                  _loading = true;
                });
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _loading = true;
                });
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
              onEnterFullscreen: (controller) {
                _isFullScreen = true;
                var isPortrait =
                    MediaQuery.of(context).orientation == Orientation.portrait;
                if (isPortrait) {
                  SystemUtils.setRotationDevice();
                }
              },
              onExitFullscreen: (controller) {
                if (_isFullScreen) {
                  SystemUtils.setPreferredOrientations();
                }
              },
            ),
            if (_loading) const Positioned.fill(child: LoadingWidget())
          ],
        ),
        macosWidget: ElevatedButton(
            onPressed: () async {
              final webview = await WebviewWindow.create();
              webview.launch(
                  "https://animehay.city/xem-phim/thon-phe-tinh-khong-tap-92-59837.html");
            },
            child: Text("Xem Phim")));
  }

  @override
  void didUpdateWidget(covariant WatchMovieByM3u8 oldWidget) {
    if (oldWidget.server.data != widget.server.data) {
      _createUrl();
      _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
