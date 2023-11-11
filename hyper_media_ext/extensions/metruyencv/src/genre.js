async function genre(url) {
  const res = await Extension.request(url + "/tim-truyen");
  const listEl = await Extension.querySelectorAll(
    res,
    'select[class="form-control changed-redirect"] option'
  );

  let result = [];
  for (const element of listEl) {
    result.push({
      title: await Extension.querySelector(element.content, "option").text,
      url: await Extension.getAttributeText(element.content, "option", "value"),
    });
  }
  return result;
}
