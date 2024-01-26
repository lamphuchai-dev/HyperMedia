async function detail(url) {
  const res = await Extension.request(url);

  if (!res) return Response.error("Lỗi tải nội dung");

  const host = "https://manga18.club";

  var detailEl = await Extension.querySelector(res, "div.detail_story")
    .outerHTML;

  const name = await Extension.querySelector(detailEl, "div.detail_name h1")
    .text;

  var cover = await Extension.getAttributeText(
    detailEl,
    "div.detail_avatar img",
    "src"
  );
  const lstElm = await Extension.querySelectorAll(
    detailEl,
    "div.detail_listInfo div.item"
  );
  let genres = [];
  var author = "";
  var statusBook = "";
  if (lstElm.length == 6) {
    author = await Extension.querySelector(
      lstElm[1].content,
      "div.info_value a"
    ).text;
    statusBook = await Extension.querySelector(
      lstElm[3].content,
      "div.info_value span"
    ).text;

    const genreEls = await Extension.querySelectorAll(
      lstElm[4].content,
      "div.info_value a"
    );

    for (var el of genreEls) {
      genres.push({
        url: await Extension.getAttributeText(el.content, "a", "href"),
        title: await Extension.querySelector(el.content, "a").text,
      });
    }
  }

  const description = await Extension.querySelector(
    res,
    "div.detail_reviewContent"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "div.chapter_box ul li")
  ).length;

  return Response.success({
    name: name ? name.trim() : "",
    cover,
    bookStatus: statusBook ? statusBook.trim() : "",
    author,
    description,
    totalChapters,
    genres,
    link: url.replace(host, ""),
    host,
  });
}

runFn(() => detail("https://manga18.club/manhwa/young-housemaid"));
