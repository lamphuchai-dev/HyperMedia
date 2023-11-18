async function detail(url) {
  const res = await Extension.request(url);

  if (!res) return Response.error("Lỗi tải nội dung");

  const host = "https://manga18fx.com";

  var name = await Extension.querySelector(
    res,
    "div.profile-manga div div.post-title h1"
  ).text;

  var cover = await Extension.getAttributeText(
    res,
    "div.summary_image a img",
    "src"
  );

  var author = await Extension.querySelector(
    res,
    "div.post-content div.author-content a"
  ).text;

  var bookStatus = await Extension.querySelector(
    res,
    "div.post-status div.post-content_item:nth-child(3) div.summary-content"
  ).text;

  const genreEls = await Extension.querySelectorAll(
    res,
    "div.post-content div.genres-content a"
  );
  let genres = [];
  for (var el of genreEls) {
    var title = await Extension.querySelector(el.content, "a").text;
    genres.push({
      url: await Extension.getAttributeText(el.content, "a", "href"),
      title: title ? title.trim() : "",
    });
  }

  const description = await Extension.querySelector(
    res,
    "div.panel-story-description p"
  ).text;

  const totalChapters = (
    await Extension.querySelectorAll(res, "#chapterlist ul li a")
  ).length;

  return Response.success({
    name: name ? name.trim() : "",
    cover,
    bookStatus: bookStatus ? bookStatus.trim() : "",
    author,
    description,
    totalChapters,
    genres,
    link: url.replace(host, ""),
    host,
  });
}

// runFn(() => detail("https://manga18fx.com/manga/troublesome-sister"));
