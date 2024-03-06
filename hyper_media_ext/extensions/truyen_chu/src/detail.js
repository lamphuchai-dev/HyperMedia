async function detail(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const host = "https://truyenchu.vn";

  const name = await Extension.querySelector(res, "h1.story-title").text;
  var cover = await Extension.getAttributeText(res, "div.book img", "src");
  var author = await Extension.querySelector(res, "div.info div a").text;

  var bookStatus = await Extension.querySelector(
    res,
    'div.info span[class="text-primary"]'
  ).text;

  const description = await Extension.querySelector(res, "div.desc-text").text;

  const totalChapters = await Extension.querySelector(
    res,
    'div.info span [id="totalChapter"]'
  ).text;

  let genres = [];
  const genresElm = await Extension.querySelectorAll(
    res,
    'div.info a[itemprop="genre"]'
  );
  for (var el of genresElm) {
    genres.push({
      url: host + (await Extension.getAttributeText(el.content, "a", "href")),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  return Response.success({
    name: name != null ? name.trim() : "",
    cover: host + cover,
    bookStatus,
    author,
    description: description != null ? description.trim() : "",
    totalChapters: Number(totalChapters),
    genres,
    link: url.replace(host, ""),
    host: host,
  });
}

// runFn(() =>
//   detail("https://truyenchu.vn/chong-truoc-tai-tuyen-xem-ta-bi-thu-nhan")
// );
