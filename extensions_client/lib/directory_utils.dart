// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DirectoryUtils {
  static Future<String> get getDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return _appDir(directory);
  }

  static Future<String> get getCacheDirectory async {
    final directory = await getTemporaryDirectory();
    return _appDir(directory);
  }

  static String _appDir(Directory directory, {String? filename}) {
    final dir = path.join(directory.path, filename ?? 'u_book');
    Directory(dir).createSync(recursive: true);
    return dir;
  }

  static Future<String> get getDirectoryExtensions async {
    final directory = await getApplicationDocumentsDirectory();
    return _appDir(directory, filename: "extensions");
  }

  static Future<List<FileSystemEntity>> getListFileExt() async {
    return Directory(await DirectoryUtils.getDirectoryExtensions).listSync();
  }

  static Directory getDirectoryByPath(String path) {
    return Directory(path);
  }

  static String getJsScriptByPath(String path) {
    try {
      final file = File(path);
      print(file.existsSync());
      return file.readAsStringSync();
    } catch (error) {
      rethrow;
    }
  }
}
