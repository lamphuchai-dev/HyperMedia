async function search(url, kw, page) {
  const res = await Extension.request(url, {
    queryParameters: { q: kw, page: page },
  });
  if (!res) return Response.error("Lỗi tải nội dung");

  const lstEl = await Extension.querySelectorAll(res, "div.page-item");
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var description = await await Extension.querySelector(
      html,
      "div.bsx-item div.bigor-manga div.list-chapter div"
    ).text;

    var name = await Extension.querySelector(
      html,
      "div.bsx-item div.bigor-manga h3 a"
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

runFn(() => search("https://manga18fx.com", "raw", 0));
