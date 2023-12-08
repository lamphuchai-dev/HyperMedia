async function detail(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const host = "https://truyencv.info";

  const detailEl = await Extension.querySelector(res, "div.story-detail")
    .outerHTML;
  const name = await Extension.querySelector(detailEl, "h1").text;
  var cover = await Extension.getAttributeText(detailEl, "img", "src");

  var author = await Extension.querySelector(detail, "div.media-body p a").text;

  var bookStatus = await Extension.querySelector(detailEl, "div.story-stage p")
    .text;

  const description = await Extension.querySelector(detailEl, "div.para p")
    .text;

  const totalChapters = (
    await Extension.querySelectorAll(detailEl, "div.chapters ul li")
  ).length;

  let genres = [];
  const genresElm = await Extension.querySelectorAll(
    detailEl,
    "div.story-tags a"
  );
  for (var el of genresElm) {
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: await Extension.querySelector(el.content, "a").text,
    });
  }

  return Response.success({
    name: name != null ? name.trim() : "",
    cover,
    bookStatus,
    author,
    description,
    totalChapters,
    genres,
    link: url.replace(host, ""),
    host: host,
  });
}

// runFn(() =>
//   detail(
//     "https://truyencv.info/bat-dau-tu-con-so-0-them-chut-tien-hoa--61393936"
//   )
// );
