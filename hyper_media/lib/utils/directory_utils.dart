// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DirectoryUtils {
  static Future<String> get getDirectory async {
    final directory = await getApplicationSupportDirectory();
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

  static Future<String> getDirectoryDownloadBook(int bookId) async {
    final directory = await createDirectory("download");

    return _appDir(directory, filename: bookId.toString());
  }

  static Future<Directory> createDirectory(String name) async {
    final directory = await getApplicationSupportDirectory();

    Directory dir = Directory(path.join(directory.path, name));
    dir.createSync(recursive: true);
    return dir;
  }

  static Directory getDirectoryByPath(String path) {
    return Directory(path);
  }
}
