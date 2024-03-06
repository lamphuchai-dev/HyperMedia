async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Có lỗi khi lấy danh sách chương");
  const bookId = await Extension.getAttributeText(res, "#truyen-id", "value");
  const bookName = await Extension.querySelector(res, "h1.story-title").text;

  if (!bookId || !bookName)
    return Response.error("Có lỗi khi lấy danh sách chương");
  const host = "https://truyenchu.vn";
  const response = await Extension.request(
    host + "/api/services/chapter-option?type=chapter_option&data=" + bookId
  );
  if (!response) return Response.error("Có lỗi khi lấy danh sách chương");

  const listEl = await Extension.querySelectorAll(response, "option");
  const chapters = [];

  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "option", "value");
    const name = await Extension.querySelector(el, "option").text;
    chapters.push({
      name: name != null ? name.trim() : "",
      url: bookUrl + "/" + url,
      host,
    });
  }
  return Response.success(chapters);
}

// runFn(() =>
//   chapters("https://truyenchu.vn/chong-truoc-tai-tuyen-xem-ta-bi-thu-nhan")
// );
