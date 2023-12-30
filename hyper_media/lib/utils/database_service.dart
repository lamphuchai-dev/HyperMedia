import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:dio_client/index.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';

import 'package:hyper_media/utils/logger.dart';
import 'package:isar/isar.dart';

import 'directory_utils.dart';

class DatabaseUtils {
  late final Isar database;
  static late final Box settings;
  late String _path;

  final _logger = Logger("DatabaseUtils");
  Future<void> ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    settings = await Hive.openBox(
      "settings",
      path: _path,
    );
    database = await Isar.open([
      ExtensionSchema,
      BookSchema,
      ChapterSchema,
      BookmarkSchema,
      DownloadSchema
    ], directory: _path, name: "db");
  }

  WatchComicSettings get getSettingsComic {
    if (!settings.containsKey(SettingKey.settingComic)) {
      return WatchComicSettings.init();
    }
    return WatchComicSettings.fromMap(
        Map.from(settings.get(SettingKey.settingComic)));
  }

  void setSettingsComic(WatchComicSettings value) async {
    await settings.put(SettingKey.settingComic, value.toMap());
  }

  WatchNovelSetting get getSettingsNovel {
    if (!settings.containsKey(SettingKey.settingNovel)) {
      return WatchNovelSetting.init();
    }
    return WatchNovelSetting.fromMap(
        Map.from(settings.get(SettingKey.settingNovel)));
  }

  void setSettingsNovel(WatchNovelSetting value) async {
    await settings.put(SettingKey.settingNovel, value.toMap());
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

  Future<Extension?> getExtensionById(int id) async {
    return database.extensions.get(id);
  }

  Future<bool> deleteExtensionById(int id) async {
    return database.writeTxn(() => database.extensions.delete(id));
  }

  Future<int?> updateChapter(Chapter chapter) async {
    if (chapter.id == null) return null;
    return database.writeTxn(() => database.chapters.put(chapter));
  }

  Future<int?> onInsertChapter(Chapter chapter) async {
    return database.writeTxn(() => database.chapters.put(chapter));
  }

  Future<Book?> onGetBookById(int bookId) async {
    return database.writeTxn(() => database.books.get(bookId));
  }

  Future<List<Chapter>> getChaptersByBookId(int bookId) {
    return database.chapters
        .filter()
        .bookIdEqualTo(bookId)
        .sortByIndex()
        .findAll();
  }

  Future<int> onInsertBook(Book book) async {
    return database.writeTxn(
        () => database.books.put(book.copyWith(updateAt: DateTime.now())));
  }

  Future<bool> onDeleteBook(int bookId) async {
    return database.writeTxn(() async {
      await database.chapters.filter().bookIdEqualTo(bookId).deleteAll();
      return database.books.delete(bookId);
    });
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

  Stream<void> get books => database.books.watchLazy();

  Stream<void> get bookmark => database.bookmarks.watchLazy();

  Future<List<int>> insertChapters(List<Chapter> chapters) {
    return database.writeTxn(() => database.chapters.putAll(chapters));
  }

  Future<int> deleteChaptersByBookId(int bookId) {
    return database.writeTxn(
        () => database.chapters.filter().bookIdEqualTo(bookId).deleteAll());
  }

  Future<int> addBookmark({required Bookmark bookmark}) async {
    return database.writeTxnSync(() {
      return database.bookmarks.putSync(bookmark);
    });
  }

  Future<List<Bookmark>> get getBookmarks =>
      database.bookmarks.where().findAll();

  Future<bool> deleteBookmarkById(
      {required int id,
      int? bookId,
      int? readerId,
      List<int> chapterIds = const []}) async {
    return database.writeTxn(() async {
      await database.chapters.deleteAll(chapterIds);
      if (bookId != null) {
        await database.books.delete(bookId);
      }
      return database.bookmarks.delete(id);
    });
  }

  // Stream<void> get downloadChange => database.downloads.watchLazy();

  Future<int> addDownload(Download download) =>
      database.writeTxn(() => database.downloads.put(download));
  Future<Download?> getDownload() async {
    return database.downloads
        .filter()
        .statusEqualTo(DownloadStatus.waiting)
        .sortByDateTime()
        .findFirst();
  }

  Future<Download?> getTaskDownloadFirst() async {
    final taskDownloading = await database.downloads
        .filter()
        .statusEqualTo(DownloadStatus.downloading)
        .sortByDateTime()
        .findFirst();
    if (taskDownloading != null) return taskDownloading;
    return await database.downloads
        .filter()
        .statusEqualTo(DownloadStatus.waiting)
        .sortByDateTime()
        .findFirst();
  }

  Future<int> updateDownload(Download download) async {
    return await database.writeTxn(() => database.downloads.put(download));
  }

  Future<List<Chapter>> getChaptersDownloadBookId(int bookId) {
    return database.chapters
        .filter()
        .bookIdEqualTo(bookId)
        .isDownloadEqualTo(false)
        .findAll();
  }

  Future<Download?> getDownloadByBookId(int bookId) =>
      database.downloads.filter().bookIdEqualTo(bookId).findFirst();

  Future<List<Download>> getDownloads() {
    return database.downloads.filter().anyOf([
      DownloadStatus.waiting,
      DownloadStatus.downloaded,
      DownloadStatus.downloadErr
    ], (q, element) => q.statusEqualTo(element)).findAll();
  }
}

class SettingKey {
  static const settingComic = "setting_comic";
  static const settingNovel = "setting_novel";
}
