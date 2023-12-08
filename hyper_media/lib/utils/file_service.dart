import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
  
}
