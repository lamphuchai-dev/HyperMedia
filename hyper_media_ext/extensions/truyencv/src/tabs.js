async function tabs() {
  return Response.success([
    {
      title: "/updates",
      url: "Cập nhật",
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
      title: "/latest",
      url: "Mới đăng",
    },
    {
      title: "/alphabet",
      url: "A-Z",
    },
  ]);
}
