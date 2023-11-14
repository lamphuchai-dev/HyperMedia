async function chapter(url) {
  var res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  var result = [];
  var data = res.match(/https:\/\/\playhydrax.com\/\?v=[^&"\s]+/g);
  if (data) {
    result.push({
      data: data[0],
      type: "iframe",
      regex: "playhydrax|player",
    });
  }

  data = res.match(/\https:\/\/scontent\.cdninstagram\.com\/[^\s]+/g);

  if (data) {
    result.push({
      data: data[0],
      type: "video",
    });
  }

  // data = res.match(/https:\/\/suckplayer\.xyz\/video\/[a-zA-Z0-9_-]+/g);

  // if (data) {
  //   result.push({
  //     data: data[0],
  //     type: "iframe",
  //   });
  // }

  data = res.match(
    /https:\/\/rapovideo\.xyz\/playlist\/([^\/]+)\/master\.m3u8/
  );

  if (data) {
    var html = `
    
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
                default: false,
                type: "hls",
                file: "${data[0]}",
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
    `;
    result.push({
      data: html,
      type: "html",
    });
  }
  if (result.length == 0) {
    return Response.error("Lỗi tải nội dung");
  }
  return Response.success(result);
}

// runFn(() =>
//   chapter(
//     "https://animehay.city/xem-phim/tran-hon-nhai-phan-3-tap-9-58893.html"
//   )
// );
