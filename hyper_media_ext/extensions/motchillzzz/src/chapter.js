async function chapter(url) {
  const api = await Browser.launchFetchBlock(url, ".*?/api/play/get*?", 10000);

  if (!api) return Response.error("Có lỗi khi tải nội dung");

  console.log(api);

  const data = await Extension.request(api, {
    headers: {
      Referer: url,
    },
    queryParameters: { server: 3 },
  });
  if (!data) return Response.error("Có lỗi khi tải nội dung");
  var result = [];

  data.forEach((el) => {
    if (el.Link) {
      result.push({
        data: el.Link,
        type: el.IsFrame ? "iframe" : "m3u8",
      });
    }
  });
  return Response.success(result);
}

// runFn(() => chapter("https://motchillzzz.tv/xem-phim-ninh-an-nhu-mong-tap-26"));
