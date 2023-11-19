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
      url: "/phim-chieu-ra",
    },
    {
      title: "TV Show",
      url: "/tv-show",
    },
    {
      title: "Phim Thuết Minh",
      url: "/phim-thuyet-minh",
    },
  ]);
}
