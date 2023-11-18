async function tabs() {
  return Response.success([
    {
      title: "Latest Release",
      url: "/",
    },
    {
      title: "Manhwa Online",
      url: "/manga-genre/manhwa",
    },
    {
      title: "Manhua Online",
      url: "/manga-genre/manhua",
    },
    {
      title: "Manhwa Raw",
      url: "/manga-genre/raw",
    },
  ]);
}
