async function chapters(url) {
  const host = "https://subnhanhs.com";

  if (url.includes("/phim-le/")) {
    return Response.success({
      name: "Tập Full",
      url: url.replace(host, ""),
      host,
    });
  }
  const res = await Extension.request(url, {
    headers: {
      Origin: host,
      Referer: url,
    },
  });
  if (!res) return Response.error("Lỗi tải nội dung");

  const lstEl = await Extension.querySelectorAll(res, "ul.episodios li");

  const chapters = [];

  for (var index = 0; index < lstEl.length; index++) {
    const el = lstEl[index].content;
    var link = await Extension.getAttributeText(el, "a", "href");
    var name = await Extension.querySelector(el, "a").text;
    chapters.push({
      name: name,
      url: link.replace(host, ""),
      host,
    });
  }
  return Response.success(chapters);
}

// runFn(() => chapters("https://subnhanhs.com/phim-le/thu-kiem-an-cuu-luc"));
