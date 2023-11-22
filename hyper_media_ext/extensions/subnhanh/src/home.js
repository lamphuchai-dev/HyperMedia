async function home(url, page) {
  if (page) {
    url = url + "/page/" + page;
  }
  const res = await Extension.request(url, {
    queryParameters: { page: page },
  });
  if (!res) return Response.error("Lỗi tải nội dung");
  const lstEl = await Extension.querySelectorAll(
    res,
    "#archive-content article"
  );
  const result = [];
  var host = "https://subnhanhs.com";

  for (const item of lstEl) {
    const el = item.content;
    var link = await Extension.getAttributeText(el, "a", "href");
    result.push({
      name: await Extension.querySelector(el, "h3 a").text,
      link: link.replace(host, ""),
      description: await await Extension.querySelector(el, "div.trangthai")
        .text,
      cover: await Extension.getAttributeText(el, "img", "src"),
      host,
    });
  }
  return Response.success(result);
}

// runFn(() => home("https://subnhanhs.com/phim-bo", 1));
