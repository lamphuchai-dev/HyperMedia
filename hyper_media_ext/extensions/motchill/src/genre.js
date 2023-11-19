// tab-cate

async function genre(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const host = "https://animehay.city";
  const el = await Extension.getElementById(res, "tab-cate");
  const listEl = await Extension.querySelectorAll(el, "a");

  let result = [];
  for (const element of listEl) {
    result.push({
      title: await Extension.getAttributeText(element.content, "a", "title"),
      url:
        host + (await Extension.getAttributeText(element.content, "a", "href")),
    });
  }
  return Response.success(result);
}

runFn(() => genre("https://animehay.city"));
