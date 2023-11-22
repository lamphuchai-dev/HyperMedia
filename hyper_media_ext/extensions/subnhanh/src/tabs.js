async function tabs() {
  return Response.success([
    {
      title: "Phim bộ mới cập nhật",
      url: "/phim-bo",
    },
    {
      title: "Phim Lẻ",
      url: "/phim-le",
    },
  ]);
}
