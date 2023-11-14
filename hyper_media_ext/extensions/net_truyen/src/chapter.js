async function chapter(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const listEl = await Extension.querySelectorAll(res, "div.page-chapter img");
  let result = [];
  for (const element of listEl) {
    var image = await Extension.getAttributeText(element.content, "img", "src");
    if (image == null) {
      image = await Extension.getAttributeText(
        element.content,
        "img",
        "data-original"
      );
    }
    if (image && image.startsWith("//")) {
      image = "https:" + image;
    }
    result.push(image);
  }
  return Response.success(result);
}
