async function chapter(url) {
  var api = await Browser.launchFetchBlock(url, ".*?/api/play/get*?", 10000);

  if (!api) return Response.error("Có lỗi khi tải nội dung");

  api = api.replace("server=0", "server=3");
  const data = await Extension.request(api, {
    headers: {
      Referer: url,
    },
  });
  if (!data) return Response.error("Có lỗi khi tải nội dung");
  var result = [];

  data.forEach((el) => {
    if (el.Link) {
      result.push({
        name: el.ServerName,
        data: el.Link,
        type: el.IsFrame ? "iframe" : "m3u8",
      });
    }
  });
  return Response.success(result);
}

// runFn(() =>
//   chapter("https://motchillzzz.tv/xem-phim-ninh-an-nhu-mong-tap-1_103d")
// );
