async function tabs() {
  return Response.success([
    {
      title: "Mới cập nhật",
      url: "/truyen/?sort_by=new_chap_at&status=-1&props=-1&page={}",
    },
    {
      title: "Chọn lọc",
      url: "/truyen?sort_by=new_chap_at&props=1&page={}",
    },
    {
      title: "Thịnh hành",
      url: "/bang-xep-hang/tuan/thinh-hanh/{}",
    },
    {
      title: "Đọc nhiều",
      url: "/bang-xep-hang/tuan/doc-nhieu/{}",
    },
    {
      title: "Tặng thưởng",
      url: "/bang-xep-hang/tuan/tang-thuong/{}",
    },
    {
      title: "Đề cử",
      url: "/bang-xep-hang/tuan/de-cu/{}",
    },
    {
      title: "Yêu thích",
      url: "/bang-xep-hang/tuan/yeu-thich/{}",
    },
    {
      title: "Thảo luận",
      url: "/bang-xep-hang/tuan/thao-luan/{}",
    },
  ]);
}
