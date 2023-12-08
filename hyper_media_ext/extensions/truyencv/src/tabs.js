async function tabs() {
  return Response.success([
    {
      title: "Cập nhật",
      url: "/updates",
    },
    {
      title: "Xem nhiều",
      url: "/popular",
    },
    {
      title: "Trending",
      url: "/trending",
    },

    {
      title: "Truyện convert",
      url: "/truyen-convert",
    },
    {
      title: "Truyện dịch",
      url: "/truyen-dich",
    },
    {
      title: "Sáng tác",
      url: "/sang-tac",
    },

    {
      title: "Mới đăng",
      url: "/latest",
    },
    {
      title: "A-Z",
      url: "/alphabet",
    },
  ]);
}
