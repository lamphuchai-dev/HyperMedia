async function chapter(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  var title = await Extension.querySelector(res, "h1.header-page").text;

  if (title != null) {
    title = title.trim();
    title = title.replace(": ", "");
  }

  var contentEl = await Extension.querySelector(
    res,
    "div.story-content article"
  ).outerHTML;

  var html = contentEl.replace(/&nbsp;/g, " ");

  html = html.replace(/<br>/g, "\n");

  html = html.replace(title + "\n", "");
  var text = await Extension.querySelector(html, "article").text;
  return Response.success(text);
}

// runFn(() =>
//   chapter(
//     "https://truyencv.info/bat-dau-tu-con-so-0-them-chut-tien-hoa/chuong-1/99600000"
//   )
// );
