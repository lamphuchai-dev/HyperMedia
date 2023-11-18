import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/logger.dart';
import 'package:hyper_media/utils/system_utils.dart';
import 'package:hyper_media/widgets/widget.dart';
import 'package:js_runtime/js_runtime.dart';

part 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  ReaderCubit(
      {required JsRuntime jsRuntime,
      required DatabaseUtils databaseUtils,
      required Book book,
      required List<Chapter> chapters})
      : _database = databaseUtils,
        _jsRuntime = jsRuntime,
        super(ReaderState(
            book: book,
            chapters: chapters,
            extensionStatus: ExtensionStatus.init));

  Extension? _extension;

  ExtensionType get getExtensionType => _extension!.metadata.type!;

  final _logger = Logger("ReaderCubit");

  final DatabaseUtils _database;
  final JsRuntime _jsRuntime;

  Book get book => state.book;
  List<Chapter> get chapters => state.chapters;

  int watchInitial = 0;

  final FToast fToast = FToast();

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  void onInit(int watchInitial) async {
    try {
      _extension = await _database.getExtensionByHost(book.host);
      if (_extension == null) {
        emit(state.copyWith(extensionStatus: ExtensionStatus.unknown));
        return;
      }

      ReaderState readerBookState = state;
      final bookInDatabase = await _database.getBookByLink(book.link);
      if (bookInDatabase != null) {
        readerBookState = readerBookState.copyWith(book: bookInDatabase);
      }

      // Check up lại bookUrl khi extension thay đổi source
      if (_extension!.metadata.source != book.host) {
        _database.updateBook(book.copyWith(host: _extension!.metadata.source));
        readerBookState = readerBookState.copyWith(
            book: readerBookState.book
                .copyWith(host: _extension!.metadata.source));
      }

      // Lấy chapters của book đã lưu trong local,update chapter khi có sự thay đổi
      // Khi từ page chapters -> readBook page
      if (book.id != null) {
        final localChapters = await _database.getChaptersByBookId(book.id!);
        if (chapters.isNotEmpty && chapters.length > localChapters.length) {
          // Lấy ra các chapters mới
          List<Chapter> newChapters =
              chapters.getRange(localChapters.length, chapters.length).toList();
          newChapters =
              newChapters.map((e) => e.copyWith(bookId: book.id)).toList();
          // Update vào database theo bookId
          await _database.insertChapters(newChapters);

          readerBookState = readerBookState.copyWith(
              chapters: await _database.getChaptersByBookId(book.id!));
        } else {
          readerBookState = readerBookState.copyWith(chapters: localChapters);
        }
      }

      if (chapters.isEmpty && watchInitial > chapters.length) {
        emit(state.copyWith(extensionStatus: ExtensionStatus.ready));
        return;
      }

      this.watchInitial = watchInitial;

      emit(readerBookState.copyWith(
        extensionStatus: ExtensionStatus.ready,
      ));

      if (book.id != null) {
        _database.updateBook(book.copyWith(
            updateAt: DateTime.now(),
            readBook: ReadBook(
                index: chapters[watchInitial].index,
                offsetLast: 0.0,
                titleChapter: chapters[watchInitial].name,
                nameExtension: _extension!.metadata.name)));
      }
    } catch (error) {
      emit(state.copyWith(extensionStatus: ExtensionStatus.error));
    }
  }

  Future<Chapter> getContentsChapter(Chapter chapter,
      {bool refresh = false}) async {
    _logger.log("getContentsChapter");
    if (!refresh &&
        (chapter.contentComic != null ||
            chapter.contentVideo != null ||
            chapter.contentNovel != null)) {
      return chapter;
    }
    try {
      final result = await _jsRuntime.getChapter(
          url: "${chapter.host}${chapter.url}",
          source: _extension!.getChapterScript);
      if (result is SuccessJsRuntime) {
        chapter = chapter.addContentByExtensionType(
            type: getExtensionType, value: result.data);
        List<Chapter> chapters = state.chapters;
        chapters.removeAt(chapter.index);
        chapters.insert(chapter.index, chapter);
        emit(state.copyWith(chapters: chapters));
      }
      return chapter;
    } catch (error) {
      _logger.log(error, name: "getChapterContent");
      rethrow;
    }
  }

  Future<bool> onRefreshChapters() async {
    fToast.showToast(
      child: ToastWidget(msg: "book.start_update_chapters".tr()),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
    final result = await _jsRuntime.getChapters(
        url: book.bookUrl, source: _extension!.getChaptersScript);
    if (result is SuccessJsRuntime &&
        result.data is List &&
        (result.data as List).length > chapters.length) {
      final lstChapter =
          result.data.map<Chapter>((el) => Chapter.fromMap(el)).toList();
      if (book.id != null) {
        List<Chapter> newChapters = lstChapter
            .getRange(state.chapters.length, lstChapter.length)
            .toList();
        newChapters =
            newChapters.map((e) => e.copyWith(bookId: book.id)).toList();
        // await _databaseService.insertChapters(newChapters);

        // final chapters = await _databaseService.getChaptersByBookId(book.id!);

        // await _databaseService.updateBook(book);
        emit(state.copyWith(
            chapters: chapters,
            book: book.copyWith(totalChapters: chapters.length)));
      } else {
        final chapters = lstChapter;
        emit(state.copyWith(chapters: chapters));
      }

      final totalNewChapter = lstChapter.length - state.chapters.length;
      fToast.showToast(
        child: ToastWidget(
            msg: "book.update_new_chapters"
                .tr(args: [totalNewChapter.toString()])),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
      return true;
    } else {
      fToast.showToast(
        child: ToastWidget(msg: "book.update_no_new_chapters".tr()),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
      return false;
    }
  }

  @override
  Future<void> close() {
    SystemUtils.setEnabledSystemUIModeDefault();
    return super.close();
  }
}
