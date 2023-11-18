async function genre(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(
    res,
    'div[class = "sub-menu genre-menu"] ul li'
  );
  let result = [];
  for (const element of listEl) {
    result.push({
      title: await Extension.getAttributeText(element.content, "a", "title"),
      url: await Extension.getAttributeText(element.content, "a", "href"),
    });
  }
  return Response.success(result);
}
