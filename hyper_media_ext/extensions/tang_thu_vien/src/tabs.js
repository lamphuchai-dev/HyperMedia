async function tabs() {
  return Response.success([
    {
      title: "Mới cập nhật",
      url: "/tong-hop?tp=cv",
    },

    {
      title: "Đề cử",
      url: "/tong-hop?rank=nm&time=m",
    },
    {
      title: "Xem nhiều",
      url: "/tong-hop?rank=vw&time=m",
    },
    {
      title: "Yêu thích",
      url: "/tong-hop?rank=vw&time=m",
    },

    {
      title: "Theo dẽo",
      url: "/tong-hop?rank=yt&time=m",
    },
    {
      title: "Bình luận",
      url: "/tong-hop?rank=bl&time=m",
    },
    {
      title: "Hoàn thành",
      url: "/tong-hop?fns=ht",
    },
    {
      title: "Truyện mới",
      url: "/tong-hop?fns=ht",
    },
  ]);
}
