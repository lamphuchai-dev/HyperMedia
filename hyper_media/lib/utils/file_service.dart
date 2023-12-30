import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hyper_media/utils/directory_utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:uuid/uuid.dart';

class FileService {
  static Future<bool> saveImage(Uint8List bytes) async {
    try {
      final result = await ImageGallerySaver.saveImage(bytes);
      if (result is Map && result["isSuccess"]) return true;
      return false;
    } catch (err) {
      return false;
    }
  }

  static Future<String?> saveImageToTemp(
      Uint8List bytes, String nameDir) async {
    try {
      final id = const Uuid().v1();
      final pathDri = await DirectoryUtils.createDirectory(nameDir);

      File file = File("${pathDri.path}/$id");
      file.writeAsBytesSync(bytes);
      return file.path;
    } catch (err) {
      return null;
    }
  }
}
