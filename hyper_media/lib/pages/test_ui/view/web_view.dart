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
<<<<<<< HEAD
    useShouldOverrideUrlLoading: false,
    supportZoom: false,
    useHybridComposition: true,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    useOnLoadResource: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );
=======
      useShouldOverrideUrlLoading: false, supportZoom: false);
>>>>>>> ca28996 (up)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Official InAppWebView website")),
        body: Center(
<<<<<<< HEAD
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: InAppWebView(
              key: _webViewKey,
              initialData: InAppWebViewInitialData(data: '''
<head>
  <link href="https://vjs.zencdn.net/8.6.1/video-js.css" rel="stylesheet" />
  <script src="https://vjs.zencdn.net/8.6.1/video.min.js"></script>
  <script>
    // Lấy origin của trang web
    var currentOrigin = window.location.origin;

    // Hiển thị origin trong console
    console.log("Current Origin:", currentOrigin);
  </script>
  <script>
    (function () {
      var open = XMLHttpRequest.prototype.open;
      var send = XMLHttpRequest.prototype.send;

      function openReplacement(method, url, async, user, password) {
        // Đoạn mã sau đây được thực hiện mỗi khi một cuộc gọi XMLHttpRequest được mở
        console.log("XHR opened:", {
          method: method,
          url: url,
          async: async,
          user: user,
          password: password,
        });

        // window.history.replaceState(null, "", "https://motchillzzz.tv");
        // console.log(window.history);
        // Gọi lại hàm mở gốc
        return open.apply(this, arguments);
      }

      function sendReplacement(data) {
        // Đoạn mã sau đây được thực hiện mỗi khi một cuộc gọi XMLHttpRequest được gửi
        console.log("XHR sent:", {
          data: data,
        });
        this.setRequestHeader("Referer", "https://motchillzzz.tv");
        this.setRequestHeader("Access-Control-Allow-Origin", "*");
        // window.history.replaceState(null, "", "https://motchillzzz.tv");
        // Gọi lại hàm gửi gốc

        return send.apply(this, arguments);
      }

      // Ghi đè hàm mở và hàm gửi của XMLHttpRequest
      XMLHttpRequest.prototype.open = openReplacement;
      XMLHttpRequest.prototype.send = sendReplacement;
      var savedPath = window.location.pathname;
      var savedSearch = window.location.search;

    })();
  </script>
  <script>
    videojs.Hls.xhr.beforeRequest = function (options) {
      options.headers = { test: "header" };
      console.log("fef");
      return options;
    };
  </script>
</head>

<body>
  <video
    id="my-video"
    class="video-js"
    controls
    preload="auto"
    width="640"
    height="264"
    data-setup="{}"
  >
    <source
      src="https://rapovideo.xyz/playlist/654b2d6b1f8b50067bfbb800/master.m3u8"
      type="application/x-mpegURL"
    />
  </video>
</body>
            
            '''),
              initialSettings: settings,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                print("object");
                return NavigationActionPolicy.ALLOW;
              },
              onLoadResource: (controller, resource) {
                print(resource);
              },
              onReceivedError: (controller, request, error) {
                print(error);
              },
            ),
=======
          child: InAppWebView(
            key: _webViewKey,
            initialUrlRequest:
                URLRequest(url: WebUri("https://lamphuchai-dev.github.io/")),
            initialSettings: settings,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
>>>>>>> ca28996 (up)
          ),
        ));
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
