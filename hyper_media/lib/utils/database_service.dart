import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:dio_client/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/logger.dart';
import 'package:isar/isar.dart';

import 'directory_utils.dart';

class DatabaseUtils {
  late final Isar database;
  late String _path;

  final _logger = Logger("DatabaseUtils");
  Future<void> ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    database = await Isar.open(
      [ExtensionSchema, BookSchema, ChapterSchema],
      directory: _path,
    );
  }

  Stream<void> get extensionsChange => database.extensions.watchLazy();

  Future<Extension?> installExtensionByUrl(String url) async {
    try {
      final res = await DioClient()
          .get(url, options: Options(responseType: ResponseType.bytes));
      if (res is List<int>) {
        final archive = ZipDecoder().decodeBytes(res);
        final fileExt = archive.files
            .firstWhereOrNull((item) => item.name == "extension.json");
        if (fileExt != null) {
          final contentString = utf8.decode(fileExt.content as List<int>);
          Extension ext = Extension.fromJson(contentString);
          Script script = ext.script;
          Metadata metadata = ext.metadata;
          for (final file in archive) {
            final filename = file.name;
            if (file.isFile) {
              final data = file.content as List<int>;
              switch (filename) {
                case "src/tabs.js":
                  final string = utf8.decode(data);
                  script = script.copyWith(tabs: string);
                  break;
                case "src/home.js":
                  final string = utf8.decode(data);
                  script = script.copyWith(home: string);
                  break;
                case "src/detail.js":
                  final string = utf8.decode(data);
                  script = script.copyWith(detail: string);
                  break;
                case "src/chapters.js":
                  final string = utf8.decode(data);
                  script = script.copyWith(chapters: string);
                  break;
                case "src/chapter.js":
                  final string = utf8.decode(data);
                  script = script.copyWith(chapter: string);
                  break;
                case "src/search.js":
                  final string = utf8.decode(data);
                  script = script.copyWith(search: string);
                  break;
                case "src/genre.js":
                  final string = utf8.decode(data);
                  script = script.copyWith(genre: string);
                  break;
                case "icon.png":
                  final base64Icon = base64Encode(data);
                  metadata = metadata.copyWith(icon: base64Icon);
                  break;
              }
            }
          }
          ext = ext.copyWith(
              metadata: metadata.copyWith(path: url),
              script: script,
              updateAt: DateTime.now());
          if (ext.script.tabs != null &&
              ext.script.home != null &&
              ext.script.detail != null &&
              ext.script.chapters != null &&
              ext.script.chapter != null) {
            final idExt =
                await database.writeTxn(() => database.extensions.put(ext));
            return ext.copyWith(id: idExt);
          } else {
            return Future.error('Extension Error');
          }
        }
      }
      return null;
    } catch (error) {
      _logger.error(error, name: "installExtensionByUrl");
      return Future.error(error);
    }
  }

  Future<List<Extension>> get getExtensions =>
      database.extensions.where().sortByUpdateAtDesc().findAll();

  Future<void> updateExtension(Extension extension) async {
    return database.writeTxn(() => database.extensions.put(extension));
  }

  Future<Extension?> get getExtensionFirst async {
    return database.extensions.where().sortByUpdateAtDesc().findFirst();
  }

  Future<Extension?> getExtensionByHost(String source) async {
    final exts = await getExtensions;

    return exts.firstWhereOrNull((elm) {
      RegExp regExp = RegExp(elm.metadata.regexp!);
      if (regExp.hasMatch(source)) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> deleteExtensionById(int id) async {
    return database.writeTxn(() => database.extensions.delete(id));
  }

  Future<int?> onInsertChapter(Chapter chapter) async {
    return database.writeTxn(() => database.chapters.put(chapter));
  }

  Future<Book?> onGetBookById(int bookId) async {
    return database.writeTxn(() => database.books.get(bookId));
  }

  Future<List<Chapter>> getChaptersByBookId(int bookId) {
    return database.chapters.filter().bookIdEqualTo(bookId).findAll();
  }

  Future<int> onInsertBook(Book book) async {
    return database.writeTxn(
        () => database.books.put(book.copyWith(updateAt: DateTime.now())));
  }

  Future<bool> onDeleteBook(int id) async {
    return database.writeTxn(() => database.books.delete(id));
  }

  Future<List<Book>> getBooks() {
    return database.books.where().sortByUpdateAtDesc().findAll();
  }

  Future<dynamic> updateBook(Book book) {
    return database.writeTxn(
        () => database.books.put(book.copyWith(updateAt: DateTime.now())));
  }

  Future<Book?> getBookByLink(String link) =>
      database.books.filter().linkEqualTo(link).findFirst();

  Stream<void> get bookStream => database.books.watchLazy();

  Future<List<int>> insertChapters(List<Chapter> chapters) {
    return database.writeTxn(() => database.chapters.putAll(chapters));
  }

  Future<int> deleteChaptersByBookId(int bookId) {
    return database.writeTxn(
        () => database.chapters.filter().bookIdEqualTo(bookId).deleteAll());
  }
}
