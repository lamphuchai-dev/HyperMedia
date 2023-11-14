import 'package:flutter/material.dart';
import 'package:hyper_media/utils/app_browser.dart';

import 'web_view.dart';

class TestUiPage extends StatefulWidget {
  const TestUiPage({super.key});

  @override
  State<TestUiPage> createState() => _TestUiPageState();
}

class _TestUiPageState extends State<TestUiPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyApp();
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Test ui")),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    AppBrowser _app = AppBrowser();
                    _app.openData(data: '''

<div class="video">
  <div id="myElement"></div>
  <script
    type="text/javascript"
    src="https://animehay.city/themes/js/jwplayer.js?v=1.0.8"
  ></script>
  <script type="text/javascript">
    jwplayer.key = "ITWMv7t88JGzI0xPwW8I0+LveiXX9SWbfdmt0ArUSyc=";
  </script>
  <script type="text/javascript">
    jwplayer("myElement").setup({
      playlist: [
        {
          sources: [
            {
              default: false,
              type: "hls",
              file: "https://rapovideo.xyz/playlist/6505aaf6d181bb2f0f5e70fb/master.m3u8",
              label: "0",
              preload: "metadata",
            },
          ],
        },
      ],
      primary: "html5",
      hlshtml: true,
      aspectratio: "16:9",
      playbackRateControls: [0.75, 1, 1.25, 1.5, 2, 2.5],
      autostart: false,
      volume: 100,
    });
  </script>
</div>


''');
                  },
                  child: const Text("ONE∏"))
            ],
          ),
        ));
  }
}
