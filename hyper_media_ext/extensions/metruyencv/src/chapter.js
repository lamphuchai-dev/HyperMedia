async function chapter(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  var text = await Extension.querySelector(res, "#article").text;
  if (text.length < 2000) {
    return Response.error(
      "Chương bị mã hoá chống leak, chưa thể lấy được nội dung."
    );
  }
  var contentEl = await Extension.querySelector(res, "#article").removeSelector(
    "script"
  );
  await contentEl.removeSelector("div.nh-read__alert");
  await contentEl.removeSelector("small.text-muted");
  await contentEl.removeSelector(".text-center");

  var html = contentEl.content.replace(/&nbsp;/g, " ");
  var trash = html.match(
    new RegExp(/====================.*?<a href=.*?\/truyen\/.*?$/g)
  );
  if (trash) {
    trash = trash[trash.length - 1];
    if (trash.length < 2000) {
      html = html.replace(trash, "");
    }
  }
  html = html.replace(/<br>/g, "\n");
  var text = await Extension.querySelector(html, "#article").text;
  return Response.success(text);
}

// runFn(() =>
//   chapter(
//     "https://metruyencv.com/truyen/cam-kiem-cho-ruou-kinh-hong-khach/chuong-50"
//   )
// );
