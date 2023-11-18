async function chapter(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(res, "div.read-content img");
  let result = [];
  for (const element of listEl) {
    var image = await Extension.getAttributeText(element.content, "img", "src");
    result.push(image);
  }
  return Response.success(result);
}

// runFn(() =>
//   chapter("https://manga18fx.com/manga/troublesome-sister/chapter-43")
// );
