async function detail(url) {
  const host = "https://animehay.city";
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const detailEl = await Extension.querySelector(res, "div.book_detail");
  const name = await Extension.querySelector(
    detailEl.content,
    "h1.heading_movie"
  ).text;

  var cover = await Extension.getAttributeText(
    detailEl.content,
    "div.info-movie img",
    "src"
  );

  const authorRow = await Extension.querySelectorAll(
    detailEl.content,
    "li.author p"
  );
  var author = "";
  if (authorRow.length == 2) {
    author = await Extension.querySelector(authorRow[1].content, "p").text;
  }

  var bookStatus = await Extension.querySelector(
    detailEl.content,
    "div.status div:nth-child(3)"
  ).text;

  let genres = [];

  const description = await Extension.querySelector(
    detailEl.content,
    'div[class="desc ah-frame-bg"] div:nth-child(3)'
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(
      res,
      'div[class ="list-item-episode scroll-bar"] a'
    )
  ).length;

  const genreEls = await Extension.querySelectorAll(
    detailEl.content,
    "div.list_cate a"
  );

  for (var el of genreEls) {
    var title = await Extension.querySelector(el.content, "a").text;
    genres.push({
      url: host + (await Extension.getAttributeText(el.content, "a", "href")),
      title: title.trim(),
    });
  }

  return Response.success({
    name,
    cover,
    link: url.replace(host, ""),
    bookStatus: bookStatus ? bookStatus.trim() : "",
    author,
    description: description ? description.trim() : "",
    genres,
    totalChapters,
    host,
  });
}

// runFn(() =>
//   detail(
//     "https://animehay.city/thong-tin-phim/tokyo-revengers-tenjiku-hen-3902.html"
//   )
// );
