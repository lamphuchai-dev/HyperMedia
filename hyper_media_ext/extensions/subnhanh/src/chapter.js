async function chapter(url) {
  const host = "https://subnhanhs.com";
  const res = await Extension.request(url, {
    headers: {
      Origin: host,
      Referer: url,
    },
  });

  if (!res) return Response.error("Có lỗi khi tải nội dung");

  var postId = await Extension.getAttributeText(
    res,
    "#player-option-1",
    "data-post"
  );

  if (!postId) return Response.error("Có lỗi khi tải nội dung");

  var lstSvEl = await Extension.querySelectorAll(res, "#playeroptionsul li");

  var result = [];

  for (var i = 0; i < lstSvEl.length; i++) {
    var el = lstSvEl[i].content;
    const data = await Extension.request(
      "https://subnhanhs.com/wp-admin/admin-ajax.php",
      {
        headers: {
          Origin: host,
          Referer: url,
          "X-Requested-With": "XMLHttpRequest",
        },
        method: "post",
        formData: {
          action: "doo_player_ajax",
          post: postId,
          nume: i + 1,
          type: "tv",
        },
      }
    );
    if (data) {
      result.push({
        name: await Extension.querySelector(el, "span").text,
        data: data.embed_url,
        type: "iframe",
      });
    }
  }

  return Response.success(result);
}

runFn(() =>
  chapter("https://subnhanhs.com/xem-phim/di-ai-vi-doanh-tap-1-451257")
);
