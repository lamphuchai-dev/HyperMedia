async function search(url, kw, page) {
  const res = await Extension.request(url + "/tim-truyen", {
    queryParameters: { page: page, keyword: kw },
  });

  const list = await Extension.querySelectorAll(res, "div.items div.item");
  const result = [];
  for (const item of list) {
    var html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "src");
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    var link = await Extension.getAttributeText(html, "h3 a", "href");
    result.push({
      name: await Extension.querySelector(html, "h3 a").text,
      link: link.replace("https://www.nettruyenus.com", ""),
      description: await Extension.querySelector(html, ".comic-item li a").text,
      cover,
      host: "https://www.nettruyenus.com",
    });
  }
  return result;
}
