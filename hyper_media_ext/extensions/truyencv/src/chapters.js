async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Có lỗi khi lấy danh sách chương");
  const listEl = await Extension.querySelectorAll(res, "div.chapters ul li");
  const chapters = [];
  const host = "https://truyencv.info";
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    const name = await Extension.querySelector(el, "span").text;
    chapters.push({
      name: name != null ? name.trim() : "",
      url: url,
      host,
    });
  }
  return Response.success(chapters);
}

// runFn(() =>
//   chapters(
//     "https://truyencv.info/bat-dau-tu-con-so-0-them-chut-tien-hoa--61393936"
//   )
// );
