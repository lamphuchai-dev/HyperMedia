async function genre(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  const listEl = await Extension.querySelectorAll(res, "#classify-list a");
  console.log(listEl);
  let result = [];
  for (const element of listEl) {
    var title = await Extension.querySelector(element.content, "i").text;
    result.push({
      title: title != null ? title.trim() : "",
      url: await Extension.getAttributeText(element.content, "a", "href"),
    });
  }
  return Response.success(result);
}

//  runFn(() => genre("https://truyen.tangthuvien.vn"));
