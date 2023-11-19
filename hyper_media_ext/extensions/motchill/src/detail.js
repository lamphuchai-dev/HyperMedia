function getNumber(inputString) {
  const regex = /\d+/; // Biểu thức chính quy để tìm các chữ số

  const result = inputString.match(regex);

  if (result) {
    const number = parseInt(result[0], 10);
    return number;
  }
  return null;
}

async function detail(url) {
  const host = "https://motchillzzz.tv";
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const detailEl = await Extension.querySelector(res, "main.container")
    .outerHTML;
  const name = await Extension.querySelector(detailEl, "h1").text;

  var cover = await Extension.getAttributeText(detailEl, "img", "src");

  var author = await Extension.querySelector(detailEl, "dl div:nth-child(1) dd")
    .text;

  var bookStatus = await Extension.querySelector(
    detailEl,
    "dl div:nth-child(4) dd"
  ).text;

  const description = await Extension.querySelector(
    detailEl,
    'p[class="inline"]'
  ).text;

  const totalChapters = await Extension.querySelector(
    detailEl,
    "dl div:nth-child(3) dd"
  ).text;

  const genreEls = await Extension.querySelectorAll(
    detailEl,
    "dl div:nth-child(8) dd span a"
  );

  let genres = [];

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
    totalChapters: totalChapters ? getNumber(totalChapters) : null,
    host,
  });
}

// runFn(() =>
//   detail("https://motchillzzz.tv/thang-nam-ruc-ro-burning-years-2023")
// );
