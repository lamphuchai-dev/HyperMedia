const glob = require("glob");
const fs = require("fs");
const AdmZip = require("adm-zip");

function zipExtensions() {
  const extensionsPath = "./extensions";

  try {
    const directories = fs
      .readdirSync(extensionsPath, { withFileTypes: true })
      .filter((item) => item.isDirectory());

    directories.forEach((extFolder) => {
      const pathFolderExt = `${extFolder.path}/${extFolder.name}`;
      const files = fs.readdirSync(pathFolderExt);
      const zip = new AdmZip();
      files.forEach((file) => {
        const filePath = `${pathFolderExt}/${file}`;
        if (fs.lstatSync(filePath).isDirectory()) {
          zip.addLocalFolder(filePath, file);
        } else {
          zip.addLocalFile(filePath);
        }
      });
      zip.writeZip(`${pathFolderExt}/extension.zip`);
    });
  } catch (err) {
    console.error("Lỗi khi đọc thư mục:", err);
  }
}

function updateINFO() {
  const data = [];
  var files = glob.sync("./extensions/*/*.json");
  const urlGit =
    "https://raw.githubusercontent.com/lamphuchai-dev/HyperMedia/main/hyper_media_ext";
  files.forEach((file) => {
    let raw_data = fs.readFileSync(file, { encoding: "utf8" });
    let plugin_detail = JSON.parse(raw_data);
    let pathGit = urlGit + "/" + file.replace("/extension.json", "");
    const metadata = plugin_detail.metadata;
    if (metadata) {
      const pathExt = pathGit + "/extension.zip";
      const icon = pathGit + "/icon.png";
      data.push({ ...metadata, path: pathExt, icon: icon });
    }
  });

  fs.writeFileSync("extensions.json", JSON.stringify(data, null, 4));
}
zipExtensions();
updateINFO();
