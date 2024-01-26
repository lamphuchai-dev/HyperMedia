async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Lỗi tải nội dung");
  const host = "https://manga18.club";

  const listEl = await Extension.querySelectorAll(res, "div.chapter_box ul li");
  const chapters = [];
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;

    chapters.push({
      name: await Extension.querySelector(el, "a").text,
      url: await Extension.getAttributeText(el, "a", "href"),
      host,
    });
  }
  return Response.success(chapters.reverse());
}

//runFn(() => chapters("https://manga18.club/manhwa/young-housemaid"));
