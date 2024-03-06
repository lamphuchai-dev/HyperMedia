async function chapter(url) {
  var res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");
  res = res.replace(/<br>/g, "\n");
  var contentEl = await Extension.querySelector(res, "div.chapter-c");
  await contentEl.removeSelector("script");
  await contentEl.removeSelector("#ADS_TOP_MIDDLE");
  await contentEl.removeSelector("#ads_top_center_chapter");
  await contentEl.removeSelector(".text-center");
  await contentEl.removeSelector(".split");
  await contentEl.removeSelector("#ADS_BOTTOM_MIDDLE");
  await contentEl.removeSelector("#chapter-append");
  await contentEl.removeSelector(".msg");
  await contentEl.removeSelector("a");

  return Response.success(await contentEl.text);
}

// runFn(() =>
//   chapter(
//     "https://truyenchu.vn/chong-truoc-tai-tuyen-xem-ta-bi-thu-nhan/chuong-1-ly-hon-xin-0"
//   )
// );
