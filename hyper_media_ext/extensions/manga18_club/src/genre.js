async function genre(url) {
  const res = await Extension.request(url + "/list-manga");
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(res, "div.grid_cate ul li");
  let result = [];
  for (const element of listEl) {
    result.push({
      title: await Extension.querySelector(element.content, "a").text,
      url: await Extension.getAttributeText(element.content, "a", "href"),
    });
  }
  return Response.success(result);
}

//runFn(() => genre("https://manga18.club"));
