async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Có lỗi khi lấy danh sách chương");

  const id = await Extension.getAttributeText(
    res,
    "input[name=story_id]",
    "value"
  );

  if (!id) return Response.error("Có lỗi khi lấy danh sách chương");
  const host = "https://truyen.tangthuvien.vn";

  const chapterRes = await Extension.request(
    host + "/story/chapters?story_id=" + id
  );
  const listEl = await Extension.querySelectorAll(chapterRes, "li a");
  const chapters = [];
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    const name = await Extension.querySelector(el, "span").text;
    chapters.push({
      name: name != null ? name.trim() : "",
      url: url.replace(host, "").trim(),
      host,
    });
  }
  return Response.success(chapters);
}

// runFn(() =>
//   chapters(
//     "https://truyen.tangthuvien.vn/doc-truyen/cuoi-cung-than-chuc--toi-chung-than-chuc-"
//   )
// );
