async function tabs() {
  return Response.success([
    {
      title: "Phim Mới Cập Nhật",
      url: "/phim-moi",
    },
    {
      title: "Phim Bộ",
      url: "/phim-bo",
    },
    {
      title: "Phim Lẻ",
      url: "/phim-le",
    },
    {
      title: "Phim Chiếu Rạp",
      url: "/phim-chieu-rap",
    },
    {
      title: "TV Show",
      url: "/tv-show",
    },
    {
      title: "Phim Thuyết Minh",
      url: "/phim-thuyet-minh",
    },
  ]);
}
