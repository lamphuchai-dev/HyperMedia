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

  static Future<String> getDirectoryDownloadBook(int bookId) async {
    final directory = await createDirectory("download");
    return _appDir(directory, filename: bookId.toString());
  }

  static Future<Directory> createDirectory(String name) async {
    final directory = await getApplicationDocumentsDirectory();

    Directory dir = Directory(path.join(directory.path, name));
    dir.createSync(recursive: true);
    return dir;
  }

  static Future<List<FileSystemEntity>> getListFileExt() async {
    return Directory(await DirectoryUtils.getDirectoryExtensions).listSync();
  }

  static Directory getDirectoryByPath(String path) {
    return Directory(path);
  }

  // static String getJsScriptByPath(String path) {
  //   try {
  //     final file = File(path);
  //     return file.readAsStringSync();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  static String fileToString(String filePath) {
    try {
      final file = File(filePath);
      return file.readAsStringSync();
    } catch (error) {
      rethrow;
    }
  }

  static Future<bool> deleteDirBook(int bookId) async {
    final directory = await getApplicationDocumentsDirectory();
    final dirBook = Directory("${directory.path}/download/$bookId");
    if (dirBook.existsSync()) {
      dirBook.deleteSync();
      return true;
    }
    return false;
  }
}
