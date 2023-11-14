import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true, supportZoom: false
      // useShouldInterceptAjaxRequest: true,
      // useShouldInterceptFetchRequest: true,
      // allowsInlineMediaPlayback: true,
      // iframeAllow: "camera; microphone",
      // useOnLoadResource: true,
      // javaScriptEnabled: true,
      // userAgent:
      //     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
      );

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Official InAppWebView website")),
        body: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: InAppWebView(
              key: webViewKey,
              initialData: InAppWebViewInitialData(data: '''
    <!DOCTYPE html>
<html lang="en">
  <head>
    <style>
      * {
        margin: 0;
        padding: 0;
      }
    </style>
    <script
      type="text/javascript"
      src="https://animehay.city/themes/js/jwplayer.js?v=1.0.8"
    ></script>
    <script type="text/javascript">
      jwplayer.key = "ITWMv7t88JGzI0xPwW8I0+LveiXX9SWbfdmt0ArUSyc=";
    </script>
    <script
      charset="utf-8"
      src="https://ssl.p.jwpcdn.com/player/v/8.8.2/jwplayer.core.controls.js"
    ></script>
    <script
      charset="utf-8"
      src="https://ssl.p.jwpcdn.com/player/v/8.8.2/related.js"
    ></script>
    <script
      charset="utf-8"
      src="https://ssl.p.jwpcdn.com/player/v/8.8.2/provider.hlsjs.js"
    ></script>
  </head>
  <body>
    <div id="jwPlayerId"></div>
    <script type="text/javascript">
      jwplayer("jwPlayerId").setup({
        playlist: [
          {
            sources: [
              {
                // default: false,
                type: "hls",
                file: "https://rapovideo.xyz/playlist/654a11ff1f8b50067bfbb7f9/master.m3u8",
                label: "0",
                preload: "metadata",
              },
            ],
          },
        ],
        primary: "html5",
        hlshtml: true,
        aspectratio: "16:9",
        width: "100%",
        playbackRateControls: [0.75, 1, 1.25, 1.5, 2, 2.5],
        autostart: false,
        volume: 100,
      });
    </script>
  </body>
</html>
  


            
            '''),
              initialSettings: settings,
            ),
          ),
        ));
  }
}
