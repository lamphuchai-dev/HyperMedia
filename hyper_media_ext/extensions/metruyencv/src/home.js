async function home(url, page) {
  if (!page) page = 1;
  url = url.replace("{}", page);
  const api = await Browser.launchXhrBlock(
    url,
    ".*?api.truyen.onl/v2/books*?",
    10000
  );
  if (!api) return Response.error("Có lỗi khi tải nội dung");

  const data = await Extension.request(api, {
    headers: {
      Referer: "https://metruyencv.com/",
      "user-agent":
        "Mozilla/5.0 (Linux; Android 13; Pixel 7 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36",
    },
  });
  if (!data) return Response.error("Có lỗi khi tải nội dung");

  const books = [];

  data._data.forEach((book) => {
    books.push({
      name: book.name,
      link: "/truyen/" + book.slug,
      cover: book["poster"]["300"],
      description: book.author_name,
      host: "https://metruyencv.com",
    });
  });
  return Response.success(books);
}

// runFn(() => home("https://metruyencv.com/bang-xep-hang/tuan/thao-luan/{}"));
