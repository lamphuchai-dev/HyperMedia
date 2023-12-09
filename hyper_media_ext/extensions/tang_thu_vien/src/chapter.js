async function chapter(url) {
  const res = await Extension.request(url);
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  var contentEl = await Extension.querySelector(res, "div.box-chap").text;
  return Response.success(contentEl);
}

// runFn(() =>
//   chapter(
//     "https://truyen.tangthuvien.vn/doc-truyen/cuoi-cung-than-chuc--toi-chung-than-chuc-/chuong-21"
//   )
// );
