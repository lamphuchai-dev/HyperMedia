async function detail(url) {
  const host = "https://subnhanhs.com";
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const detailEl = await Extension.querySelector(res, "div.sheader").outerHTML;
  const name = await Extension.querySelector(detailEl, "h1").text;

  var cover = await Extension.getAttributeText(detailEl, "img", "src");

  var author = "Đang cập nhật";

  var bookStatus = await Extension.querySelector(detailEl, "span.item-label")
    .text;

  const description = await Extension.querySelector(res, "#info div").text;

  const totalChapters = await Extension.querySelectorAll(
    res,
    "ul.episodios li"
  );
  const genreEls = await Extension.querySelectorAll(detailEl, "div.sgeneros a");

  let genres = [];

  for (var el of genreEls) {
    var title = await Extension.querySelector(el.content, "a").text;
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: title.trim(),
    });
  }

  return Response.success({
    name,
    cover,
    link: url.replace(host, ""),
    bookStatus: bookStatus ? bookStatus.trim() : "",
    author,
    description: description ? description : "",
    genres,
    totalChapters: totalChapters.length,
    host,
  });
}

// runFn(() => detail("https://subnhanhs.com/phim-bo/di-ai-vi-doanh-451257"));
