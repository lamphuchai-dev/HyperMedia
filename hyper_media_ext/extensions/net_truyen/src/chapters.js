async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  const listEl = await Extension.querySelectorAll(res, "div.list-chapter ul a");
  const chapters = [];
  const host = "https://www.nettruyenus.com";
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    const name = await Extension.querySelector(el, "a").text;
    chapters.push({
      name,
      url: url.replace(host, ""),
      host,
    });
  }
  return chapters.reverse();
}

// runFn(() =>
//   chapters(
//     "https://www.nettruyenus.com/truyen-tranh/xuyen-nhanh-phan-dien-qua-sung-qua-me-nguoi-88810"
//   )
// );
