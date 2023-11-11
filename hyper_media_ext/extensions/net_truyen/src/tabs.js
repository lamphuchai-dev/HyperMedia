async function tabs() {
  return [
    {
      title: "Mới cập nhật",
      url: "/tim-truyen",
    },
    {
      title: "Truyện mới",
      url: "/tim-truyen?status=-1&sort=15",
    },
    {
      title: "Top all",
      url: "/tim-truyen?status=-1&sort=10",
    },
    { title: "Top tháng", url: "/tim-truyen?status=-1&sort=11" },
    { title: "Top tuần", url: "/tim-truyen?status=-1&sort=12" },
    { title: "Top ngày", url: "/tim-truyen?status=-1&sort=13" },
    { title: "Theo dõi", url: "/tim-truyen?status=-1&sort=20" },
    { title: "Bình luận", url: "/tim-truyen?status=-1&sort=25" },
    {
      title: "Truyện Full",
      url: "/truyen-full",
    },
    {
      title: "Tất cả - Số chapter",
      url: "/tim-truyen?status=-1&sort=30",
    },
    {
      title: "Truyện con trai",
      url: "/truyen-con-trai",
    },
    {
      title: "Truyện con gái",
      url: "/truyen-con-gai",
    },
  ];
}
