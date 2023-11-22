async function search(url, kw, page) {
  if (page) {
    url = url + "/page/" + page;
  }
  const res = await Extension.request(url, {
    queryParameters: {
      s: kw,
    },
  });
  if (!res) return Response.error("Lỗi tải nội dung");
  const lstEl = await Extension.querySelectorAll(
    res,
    "div.result-item article"
  );
  const result = [];
  var host = "https://subnhanhs.com";

  for (const item of lstEl) {
    const el = item.content;
    var link = await Extension.getAttributeText(el, "div.title a", "href");
    result.push({
      name: await Extension.querySelector(el, "div.title a").text,
      link: link.replace(host, ""),
      description: await await Extension.querySelector(el, "div.contenido")
        .text,
      cover: await Extension.getAttributeText(el, "img", "src"),
      host,
    });
  }
  return Response.success(result);
}

// runFn(() => search("https://subnhanhs.com", "go", 2));
