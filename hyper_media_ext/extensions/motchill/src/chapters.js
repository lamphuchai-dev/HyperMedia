async function chapters(url) {
  const host = "https://motchillzzz.tv";
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  var linkWatch = await Extension.getAttributeText(
    res,
    'main.container div[class="text-center"] a',
    "href"
  );

  if (!linkWatch) return Response.error("Lỗi tải nội dung");

  const html = await Extension.request(host + linkWatch);

  if (!html) return Response.error("Lỗi tải nội dung");

  const lstEl = await Extension.querySelectorAll(
    html,
    "section div a.text-center"
  );

  const chapters = [];

  for (var index = 0; index < lstEl.length; index++) {
    const el = lstEl[index].content;
    var link = await Extension.getAttributeText(el, "a", "href");
    var name = await Extension.querySelector(el, "a").text;
    chapters.push({
      name: name,
      url: link,
      host,
    });
  }
  return Response.success(chapters);
}

// runFn(() => chapters("https://motchillzzz.tv/hen-nhau-tren-sao-kim"));
