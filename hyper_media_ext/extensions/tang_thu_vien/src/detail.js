async function detail(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const host = "https://truyen.tangthuvien.vn";

  const detailEl = await Extension.querySelector(res, "div.book-information")
    .outerHTML;
  const name = await Extension.querySelector(detailEl, "div.book-info h1").text;
  var cover = await Extension.getAttributeText(
    detailEl,
    "div.book-img img",
    "src"
  );

  var author = await Extension.querySelector(detailEl, "div.book-info p.tag a")
    .text;

  var bookStatus = await Extension.querySelector(detailEl, "p.tag span").text;

  const description = await Extension.querySelector(res, "div.book-intro p")
    .text;

  const totalText = await Extension.querySelector(res, "#j-bookCatalogPage")
    .text;

  var totalChapters = 0;

  var ketQua = totalText.match(/\d+/);

  if (ketQua) {
    totalChapters = parseInt(ketQua[0]);
  }

  let genres = [];
  const genresElm = await Extension.querySelectorAll(res, "li.tags a.tags");
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

runFn(() =>
  detail(
    "https://truyen.tangthuvien.vn/doc-truyen/cuoi-cung-than-chuc--toi-chung-than-chuc-"
  )
);
