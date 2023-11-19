function extractNumberFromUrl(url) {
  const regex = /(\d+)$/;
  const match = url.match(regex);

  if (match) {
    return parseInt(match[1], 10);
  }

  return null;
}

async function chapters(url) {
  const host = "https://motchillzzz.tv";
  const res = await Extension.request(url);
  if (!res) return Response.error("Lỗi tải nội dung");

  const listEl = await Extension.querySelectorAll(
    res,
    "main.container div a.transition.rounded"
  );
  const chapters = [];
  if (listEl.length != 0) {
    const linkEp = await Extension.getAttributeText(
      listEl[0].content,
      "a",
      "href"
    );
    const totalEsp = extractNumberFromUrl(linkEp);
    if (totalEsp) {
      const urlTmp = linkEp.replace(totalEsp, "");
      for (var index = 1; index <= totalEsp; index++) {
        chapters.push({
          name: "Tập " + index,
          url: urlTmp + index,
          host,
        });
      }
      return Response.success(chapters);
    }
  }
  return Response.success([]);
}

// runFn(() => chapters("https://motchillzzz.tv/gia-dinh-diep-vien-phan-2ef9"));
