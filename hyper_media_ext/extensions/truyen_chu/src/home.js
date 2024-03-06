async function home(url, page) {
  if (!page) page = 1;

  const res = await Extension.request(url, {
    headers: {
      "user-agent":
        "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
    },
    queryParameters: { page: page },
  });
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const host = "https://truyencv.info";
  const list = await Extension.querySelectorAll(res, "div.media");
  const result = [];

  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(
      html,
      "div.story-thumb img",
      "src"
    );

    const link = await Extension.getAttributeText(
      html,
      "div.story-thumb a",
      "href"
    );
    result.push({
      name: await Extension.querySelector(html, "h4.media-heading a").text,
      link: link.replace(host, ""),
      description: await Extension.querySelector(html, "p.text-summary").text,
      cover,
      host: host,
    });
  }
  return Response.success(result);
}

//  runFn(() => home("https://truyencv.info/popular"));
