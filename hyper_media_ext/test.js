async function execute(url, page) {
  var htmlPage = await Browser.launch("https://metruyencv.com", 20000);

  if (!htmlPage) return Response.error("Có lỗi khi lấy danh sách chương");

  await Browser.loadUrl(
    "https://metruyencv.com/truyen/ta-khong-he-co-y-thanh-tien/chuong-590"
  );
  await new Promise((resolve) => setTimeout(resolve, 5000));

  var res = await Browser.getHtml();
  Browser.close();

  var contentEl = await Extension.querySelector(res, "#article").removeSelector(
    "script"
  );
  await contentEl.removeSelector("div.nh-read__alert");
  await contentEl.removeSelector("small.text-muted");
  await contentEl.removeSelector(".text-center");

  var html = contentEl.content.replace(/&nbsp;/g, " ");
  //   var trash = html.match(
  //     new RegExp(/====================.*?<a href=.*?\/truyen\/.*?$/g)
  //   );
  //   if (trash) {
  //     trash = trash[trash.length - 1];
  //     if (trash.length < 2000) {
  //       html = html.replace(trash, "");
  //     }
  //   }
  //   //html = html.replace(/<br>/g, "\n");
  //   var text = await Extension.querySelector(html, "#article").text;
  return Response.success(res);
}

runFn(() => execute("url"));
