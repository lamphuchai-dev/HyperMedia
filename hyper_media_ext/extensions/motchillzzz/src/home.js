async function home(url, page) {
  const res = await Extension.request(url, {
    queryParameters: { page: page },
  });
  if (!res) return Response.error("Lỗi tải nội dung");
  const lstEl = await Extension.querySelectorAll(res, "div article");
  const result = [];
  var host = "https://motchillzzz.tv";

  for (const item of lstEl) {
    const html = item.content;
    var link = await Extension.getAttributeText(html, "a", "href");
    result.push({
      name: await Extension.getAttributeText(html, "a", "title"),
      link: link.replace(host, ""),
      description: await await Extension.querySelector(html, "article span")
        .text,
      cover: await Extension.getAttributeText(html, "img", "src"),
      host,
    });
  }
  return Response.success(result);
}

// runFn(() => home("https://motchillzzz.tv/phim-moi",2));
