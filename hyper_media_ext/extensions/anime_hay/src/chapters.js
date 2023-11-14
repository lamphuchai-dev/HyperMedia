async function chapters(bookUrl) {
  const host = "https://animehay.city";
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(
    res,
    'div[class ="list-item-episode scroll-bar"] a'
  );
  const chapters = [];
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    const title = await Extension.querySelector(el, "a").text;
    chapters.push({
      name: "Tập " + title.trim(),
      url: url.replace(host, ""),
      host,
    });
  }

  return Response.success(chapters.reverse());
}

// runFn(() =>
//   chapters("https://animehay.city/thong-tin-phim/tien-nghich-3879.html")
// );
