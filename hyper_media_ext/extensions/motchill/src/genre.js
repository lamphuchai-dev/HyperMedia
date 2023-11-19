async function genre(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");
  const host = "https://motchillzzz.tv";

  const listEl = await Extension.querySelectorAll(res, "#nav div.transform a");
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

// runFn(() => genre("https://motchillzzz.tv"));
