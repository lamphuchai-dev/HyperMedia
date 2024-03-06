async function tabs() {
  return Response.success([
    {
      title: "Mới cập nhật",
      url: "/danh-sach/truyen-moi",
    },
    {
      title: "Truyện Hót",
      url: "/danh-sach/truyen-hot",
    },
    {
      title: "Truyện Convert",
      url: "/danh-sach/truyen-convert",
    },
    {
      title: "Truyện Dịch",
      url: "/danh-sach/truyen-dich",
    },
    {
      title: "Truyện Hoàn Thành",
      url: "/danh-sach/truyen-full",
    },
  ]);
}

<ul
  class="dropdown-menu"
  role="menu"
  itemscope=""
  itemtype="http://www.schema.org/SiteNavigationElement"
>
  <li>
    <a itemprop="url" href="/danh-sach/dam-my-h-van" title="Đam Mỹ H Văn">
      <span itemprop="name">Đam Mỹ H Văn</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/dam-my-hai" title="Đam mỹ hài">
      <span itemprop="name">Đam mỹ hài</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/dam-my-sac" title="Đam Mỹ Sắc">
      <span itemprop="name">Đam Mỹ Sắc</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/ngon-tinh-hai" title="Ngôn Tình Hài">
      <span itemprop="name">Ngôn Tình Hài</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/ngon-tinh-nguoc" title="Ngôn Tình Ngược">
      <span itemprop="name">Ngôn Tình Ngược</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/ngon-tinh-sac" title="Ngôn Tình Sắc">
      <span itemprop="name">Ngôn Tình Sắc</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/ngon-tinh-sung" title="Ngôn tình Sủng">
      <span itemprop="name">Ngôn tình Sủng</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/tien-hiep-hay" title="Tiên hiệp hay">
      <span itemprop="name">Tiên hiệp hay</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/truyen-convert" title="Truyện Convert">
      <span itemprop="name">Truyện Convert</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/truyen-dich" title="Truyện Dịch">
      <span itemprop="name">Truyện Dịch</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/truyen-full" title="Truyện Full">
      <span itemprop="name">Truyện Full</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/truyen-hot" title="Truyện Hot">
      <span itemprop="name">Truyện Hot</span>
    </a>
  </li>
  <li>
    <a itemprop="url" href="/danh-sach/truyen-moi" title="Truyện Mới">
      <span itemprop="name">Truyện Mới</span>
    </a>
  </li>
</ul>;
