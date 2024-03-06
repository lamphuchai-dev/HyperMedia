async function home(url, page) {
  if (!page) page = 1;

  const res = await Extension.request(url, {
    queryParameters: { page: page },
  });
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const host = "https://truyenchu.vn";
  const list = await Extension.querySelectorAll(
    res,
    ".list-truyen div[itemscope]"
  );
  const result = [];
  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(
      html,
      "div[data-image]",
      "data-image"
    );
    const link = await Extension.getAttributeText(
      html,
      "h3.truyen-title a",
      "href"
    );

    result.push({
      name: await Extension.querySelector(html, "h3.truyen-title a").text,
      link: link.replace(host, ""),
      description: await Extension.getAttributeText(
        html,
        "div.latest-chapter a",
        "title"
      ),
      cover: host + cover,
      host: host,
    });
  }
  return Response.success(result);
}

// runFn(() => home("https://truyenchu.vn/danh-sach/truyen-convert", 1));
