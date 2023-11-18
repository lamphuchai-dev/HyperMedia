async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(res, "#chapterlist ul li a");
  const host = "https://manga18fx.com";
  const chapters = [];
  for (var index = 0; index < listEl.length; index++) {
    const el = listEl[index].content;
    const url = await Extension.getAttributeText(el, "a", "href");
    chapters.push({
      name: await Extension.querySelector(el, "a").text,
      url: await Extension.getAttributeText(el, "a", "href"),
      host,
    });
  }
  return Response.success(chapters);
}

// runFn(() => chapters("https://manga18fx.com/manga/troublesome-sister"));
