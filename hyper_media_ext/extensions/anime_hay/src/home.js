async function home(url, page) {
  if (!page) page = 1;
  url = url.replace(".html", "");
  url = url + `/trang-${page}.html`;

  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");
  const lstEl = await Extension.querySelectorAll(res, "div.movie-item");
  const result = [];
  var host = "https://animehay.city";

  for (const item of lstEl) {
    const html = item.content;
    var link = await Extension.getAttributeText(html, "a", "href");
    result.push({
      name: await Extension.getAttributeText(html, "a", "title"),
      link: link.replace(host, ""),
      description: await await Extension.querySelector(
        html,
        "div.episode-latest span"
      ).text,
      cover: await Extension.getAttributeText(html, "img", "src"),
      host,
    });
  }
  return Response.success(result);
}

// runFn(() => home("https://animehay.city/phim-moi-cap-nhap"));
