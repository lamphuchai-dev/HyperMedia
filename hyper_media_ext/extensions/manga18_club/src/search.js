async function search(url, kw, page) {
  if (page != null) {
    if (page == 0) {
      page = 1;
    }
    url = url + "/list-manga/" + page;
  }
  const res = await Extension.request(url, {
    queryParameters: { search: kw },
  });
  if (!res) return Response.error("Lỗi tải nội dung");

  const lstEl = await Extension.querySelectorAll(
    res,
    "div.recoment_box div.story_item"
  );
  const result = [];
  for (const item of lstEl) {
    const html = item.content;
    var bookUrl = await Extension.getAttributeText(
      html,
      "div.mg_name a",
      "href"
    );
    var description = await await Extension.querySelector(
      html,
      "div.mg_chapter div.chapter_count a"
    ).text;

    result.push({
      name: await Extension.querySelector(html, "div.mg_name a").text,
      link: bookUrl,
      description: description != null ? description.trim() : "",
      cover: await Extension.getAttributeText(html, "img", "src"),
      host: "https://manga18.club",
    });
  }

  return Response.success(result);
}

//runFn(() => search("https://manga18.club", "raw", 0));
