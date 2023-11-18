async function home(url, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    if (url.includes("manga-genre")) {
      url = url + `/${page}`;
    } else {
      url = url + `/page/${page}`;
    }
  }
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const lstEl = await Extension.querySelectorAll(res, "div.page-item");
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var name = await Extension.querySelector(
      html,
      "div.bsx-item div.bigor-manga h3 a"
    ).text;

    var description = await Extension.querySelector(
      html,
      "div.bsx-item div.bigor-manga div.list-chapter div span.chapter a"
    ).text;
    result.push({
      name: name != null ? name.trim() : "",
      link: await Extension.getAttributeText(
        html,
        "div.bsx-item div.bigor-manga  h3  a",
        "href"
      ),
      description: description != null ? description.trim() : "",
      cover: await Extension.getAttributeText(html, "img", "src"),
      host: "https://manga18fx.com",
    });
  }
  return Response.success(result);
}

// runFn(() => home("https://manga18fx.com"));
