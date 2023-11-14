async function chapters(url) {
  const htmlPage = await Browser.launch(url, 10000);
  if (!htmlPage) return Response.error("Có lỗi khi lấy danh sách chương");

  Browser.callJs(
    "for(const a of document.querySelectorAll('a')){if(a.textContent.includes('Danh sách chương')){a.click()}}",
    200
  );

  const data = await Browser.waitUrlAjaxResponse(
    ".*?api.truyen.onl/v2/chapters*?",
    5000
  );
  Browser.close();
  if (!data) return Response.error("Có lỗi khi lấy danh sách chương");
  const chapters = [];
  data.response._data.chapters.forEach((chapter) => {
    chapters.push({
      name: chapter.name,
      url:
        url.replace("https://metruyencv.com", "") + "/chuong-" + chapter.index,
      host: "https://metruyencv.com",
    });
  });
  return Response.success(chapters);
}

// runFn(() =>
//   chapters(
//     "https://metruyencv.com/truyen/dau-la-phan-phai-may-mo-phong-bat-dau-ham-hai-thien-nhan-tuyet"
//   )
// );
