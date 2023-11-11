import 'package:easy_refresh/easy_refresh.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/device_utils.dart';
import 'package:hyper_media/utils/system_utils.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:js_runtime/utils/logger.dart';

import 'reader_type.dart';

part 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  ReaderCubit(
      {required JsRuntime jsRuntime,
      required DatabaseUtils databaseUtils,
      required Book book})
      : _database = databaseUtils,
        _jsRuntime = jsRuntime,
        super(ReaderState(
            extensionStatus: ExtensionStatus.init,
            readerType: ReaderBase(),
            chapters: const [],
            book: book));

  final _logger = Logger("ReaderCubit");

  final DatabaseUtils _database;
  final JsRuntime _jsRuntime;

  Book get book => state.book;
  set setBook(Book book) => emit(state.copyWith(book: book));

  Extension? _extension;

  ExtensionType get getExtensionType => _extension!.metadata.type!;

  bool _currentOnTouchScreen = false;
  late final AnimationController _menuAnimationController;

  final FToast fToast = FToast();
  final ScrollController scrollController = ScrollController();

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  @override
  void onChange(Change<ReaderState> change) {
    super.onChange(change);

    // if (change.currentState.menuType != MenuType.autoScroll &&
    //     change.nextState.menuType == MenuType.autoScroll) {
    //   DeviceUtils.enableWakelock();
    // } else if (change.currentState.menuType == MenuType.autoScroll &&
    //     change.nextState.menuType != MenuType.autoScroll) {
    //   DeviceUtils.disableWakelock();
    // }

    // if (change.currentState.readChapter != null &&
    //     change.nextState.readChapter != null &&
    //     change.currentState.readChapter?.chapter !=
    //         change.nextState.readChapter?.chapter) {
    //   // update read book
    //   if (book.bookmark) {
    //     final chapter = change.nextState.readChapter!.chapter;
    //     final readBook = ReadBook(
    //         index: chapter.index,
    //         titleChapter: chapter.title,
    //         nameExtension: _extension!.metadata.name);
    //     _databaseService.updateBook(book.copyWith(readBook: readBook));
    //   }
    // }
  }

  void onInit(
      {required List<Chapter> chapters, required int initReadChapter}) async {
    try {
      _extension = await _database.getExtensionByHost(book.host);
      if (_extension == null) {
        emit(state.copyWith(extensionStatus: ExtensionStatus.unknown));
        return;
      }

      final bookInDatabase = await _database.getBookByLink(book.link);
      if (bookInDatabase != null) {
        setBook = bookInDatabase;
      }

      // Check up lại bookUrl khi extension thay đổi source
      if (_extension!.metadata.source != book.host) {
        _database.updateBook(book.copyWith(host: _extension!.metadata.source));
        setBook = book.copyWith(host: _extension!.metadata.source);
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
          chapters = await _database.getChaptersByBookId(book.id!);
        } else {
          chapters = localChapters;
        }
      }

      if (chapters.isEmpty && initReadChapter > chapters.length) {
        emit(state.copyWith(extensionStatus: ExtensionStatus.ready));
        return;
      }

      ReadChapter readChapter =
          ReadChapter.init(initIndex: initReadChapter, chapters: chapters);
      emit(state.copyWith(
          extensionStatus: ExtensionStatus.ready,
          readChapter: readChapter,
          chapters: chapters));
      getContentsChapter();

      if (book.id != null) {
        _database.updateBook(book.copyWith(
            updateAt: DateTime.now(),
            readBook: ReadBook(
                index: readChapter.chapter.index,
                offsetLast: 0.0,
                titleChapter: readChapter.chapter.name,
                nameExtension: _extension!.metadata.name)));
      }
    } catch (error) {
      emit(state.copyWith(extensionStatus: ExtensionStatus.error));
    }
  }

  // onTap vào màn hình để mở panel theo [ReadBookType]
  void onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  void setMenuAnimationController(AnimationController animationController) {
    _menuAnimationController = animationController;
  }

  bool get _isShowMenu =>
      _menuAnimationController.status == AnimationStatus.completed;

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  void onChangeIsShowMenu(bool value) async {
    if (value) {
      _menuAnimationController.forward();
    } else {
      _menuAnimationController.reverse();
    }
  }

  Future<void> onHideCurrentMenu() async {
    if (_menuAnimationController.status == AnimationStatus.completed) {
      await _menuAnimationController.reverse();
    }
  }

  Future<void> getContentsChapter() async {
    _logger.log("getContentsChapter");
    ReadChapter readChapter =
        state.readChapter!.copyWith(status: StatusType.loading);
    try {
      final result = await _jsRuntime.getChapter(
          url: "${readChapter.chapter.host}${readChapter.chapter.url}",
          source: _extension!.getChapterScript);
      final chapter = readChapter.chapter
          .addContentByExtensionType(type: getExtensionType, value: result);
      List<Chapter> chapters = state.chapters;
      chapters.removeAt(readChapter.chapter.index);
      chapters.insert(readChapter.chapter.index, readChapter.chapter);

      readChapter =
          readChapter.copyWith(chapter: chapter, status: StatusType.loaded);
      emit(state.copyWith(readChapter: readChapter));
    } catch (error) {
      _logger.log(error, name: "getChapterContent");
      emit(state.copyWith(
          readChapter: readChapter.copyWith(status: StatusType.error)));
    }
  }

  Future<ReadChapter> getChapter(ReadChapter readChapter) async {
    _logger.log("getChapter");
    if (readChapter.chapter.contentComic != null ||
        readChapter.chapter.contentVideo != null ||
        readChapter.chapter.contentNovel != null) {
      return readChapter;
    } else {
      try {
        final result = await _jsRuntime.getChapter(
            url: "${readChapter.chapter.host}${readChapter.chapter.url}",
            source: _extension!.getChapterScript);
        final chapter = readChapter.chapter
            .addContentByExtensionType(type: getExtensionType, value: result);
        List<Chapter> chapters = state.chapters;
        chapters.removeAt(readChapter.chapter.index);
        chapters.insert(readChapter.chapter.index, readChapter.chapter);
        emit(state.copyWith(chapters: chapters));
        readChapter =
            readChapter.copyWith(chapter: chapter, status: StatusType.loaded);
      } catch (error) {
        _logger.log(error, name: "getChapterContent");
        readChapter = readChapter.copyWith(status: StatusType.error);
      }
    }
    return readChapter;
  }

  Future<bool> onPreviousChapter() async {
    ReadChapter readChapter =
        state.readChapter!.previous(chapters: state.chapters);
    if (state.readChapter!.chapter.index != readChapter.chapter.index) {
      readChapter = await getChapter(readChapter);
    }
    emit(state.copyWith(readChapter: readChapter));
    return true;
  }

  Future<bool> onNextChapter() async {
    ReadChapter readChapter = state.readChapter!.next(chapters: state.chapters);
    if (state.readChapter!.chapter.index != readChapter.chapter.index) {
      readChapter = await getChapter(readChapter);
    }
    emit(state.copyWith(readChapter: readChapter));
    return true;
  }

  void onChangeReadChapter(int index) {
    emit(state.copyWith(
        readChapter:
            ReadChapter.init(initIndex: index, chapters: state.chapters)));
  }

  @override
  Future<void> close() {
    SystemUtils.setEnabledSystemUIModeDefault();
    SystemUtils.setPreferredOrientations();
    // timeAutoScroll.dispose();
    // sliderTimeAutoScroll?.cancel();
    // chaptersSliderTime?.cancel();
    _menuAnimationController.dispose();
    DeviceUtils.disableWakelock();
    return super.close();
  }
}
