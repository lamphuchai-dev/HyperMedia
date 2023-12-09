async function home(url, page) {
  if (!page) page = 1;

  const res = await Extension.request(url, {
    queryParameters: { page: page },
  });
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  const host = "https://truyen.tangthuvien.vn";
  const list = await Extension.querySelectorAll(res, "div.rank-body li");
  const result = [];

  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(
      html,
      "div.book-img-box img",
      "src"
    );

    const link = await Extension.getAttributeText(
      html,
      "div.book-img-box a",
      "href"
    );
    const description = await Extension.querySelector(html, "p.intro").text;
    result.push({
      name: await Extension.querySelector(html, "div.book-mid-info h4 a").text,
      link: link.replace(host, ""),
      description: description != null ? description.trim() : "",
      cover,
      host: host,
    });
  }
  return Response.success(result);
}

// runFn(() => home("https://truyen.tangthuvien.vn/tong-hop?ord=new"));
