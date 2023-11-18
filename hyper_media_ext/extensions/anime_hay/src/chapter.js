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
    result.push({
      data: data[0],
      type: m3u8,
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
