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

import '../controller/auto_scroll_controller.dart';

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
            menuType: MenuType.base,
            controlStatus: ControlStatus.init,
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

  EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  final AutoScrollController _autoScrollController = AutoScrollController();

  List<Chapter> _chapters = [];

  List<Chapter> get getChapters => _chapters;

  double _heightScreen = 0;

  void setHeight(double height) {
    _heightScreen = height;
    _autoScrollController.setHeight = _heightScreen;
  }

  AutoScrollController get getAutoScrollController => _autoScrollController;

  void onInitFToat(BuildContext context) {
    fToast.init(context);
  }

  void setScrollController(ScrollController controller) {
    _autoScrollController.init(controller);
    _autoScrollController.addListener(() async {
      final controlStatus = _autoScrollController.status;
      _logger.log(controlStatus, name: "controlStatus");
      switch (controlStatus) {
        case ControlStatus.complete:
          if (state.menuType != MenuType.autoScroll) {
            emit(state.copyWith(menuType: MenuType.autoScroll));
          }
          if (state.watchChapter!.chapter.index == _chapters.length - 1) {
            await onHideCurrentMenu();
            emit(state.copyWith(
                menuType: MenuType.base, controlStatus: ControlStatus.init));
            break;
          }
          onNextChapter();
          break;
        case ControlStatus.init:
          emit(state.copyWith(
              menuType: MenuType.base, controlStatus: controlStatus));
          break;
        case ControlStatus.start:
          if (state.menuType != MenuType.autoScroll) {
            emit(state.copyWith(
                menuType: MenuType.autoScroll, controlStatus: controlStatus));
            break;
          }
          emit(state.copyWith(controlStatus: controlStatus));
          break;
        case ControlStatus.pause:
          emit(state.copyWith(controlStatus: controlStatus));
          break;
        default:
          break;
      }
    });
  }

  void onCheckAutoScroll() {
    _autoScrollController.checkAutoNextChapter();
  }

  ValueNotifier<double> timeAutoScroll = ValueNotifier(10);

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

      emit(state.copyWith(
          extensionStatus: ExtensionStatus.ready,
          watchChapter: WatchChapter(
              chapter: chapters[initReadChapter], status: StatusType.init),
          chapters: chapters));

      _chapters = chapters;

      onInitWatchChapter();

      if (book.id != null) {
        _database.updateBook(book.copyWith(
            updateAt: DateTime.now(),
            readBook: ReadBook(
                index: chapters[initReadChapter].index,
                offsetLast: 0.0,
                titleChapter: chapters[initReadChapter].name,
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

  Future<WatchChapter> getContentsChapter(WatchChapter watchChapter) async {
    _logger.log("getContentsChapter");
    if (watchChapter.chapter.contentComic != null ||
        watchChapter.chapter.contentVideo != null ||
        watchChapter.chapter.contentNovel != null) {
      return watchChapter;
    }
    try {
      watchChapter = watchChapter.copyWith(status: StatusType.loading);
      final result = await _jsRuntime.getChapter(
          // url: "${watchChapter.chapter.host}${watchChapter.chapter.url}",
          url: "${watchChapter.chapter.url}",
          source: _extension!.getChapterScript);
      if (result is SuccessJsRuntime) {
        final chapter = watchChapter.chapter.addContentByExtensionType(
            type: getExtensionType, value: result.data);
        _chapters.removeAt(watchChapter.chapter.index);
        _chapters.insert(watchChapter.chapter.index, watchChapter.chapter);

        return watchChapter.copyWith(
            chapter: chapter, status: StatusType.loaded);
      }
      return watchChapter.copyWith(status: StatusType.error);
    } catch (error) {
      _logger.log(error, name: "getChapterContent");
      return watchChapter.copyWith(status: StatusType.error);
    }
  }

  Future<bool> onPreviousChapter({bool menu = true}) async {
    if (state.watchChapter != null && state.watchChapter!.chapter.index != 0) {
      final chapter = _chapters[state.watchChapter!.chapter.index - 1];

      if (menu) {
        emit(state.copyWith(
            watchChapter:
                WatchChapter(chapter: chapter, status: StatusType.init)));
        return true;
      }
      final watch = await getContentsChapter(
          WatchChapter(chapter: chapter, status: StatusType.init));
      Future.delayed(const Duration(milliseconds: 300)).then(
        (value) {
          emit(state.copyWith(watchChapter: watch));
        },
      );
    }

    easyRefreshController.finishRefresh();
    return true;
  }

  Future<bool> onNextChapter({bool menu = true}) async {
    if (state.watchChapter != null &&
        state.watchChapter!.chapter.index + 1 < _chapters.length) {
      final chapter = _chapters[state.watchChapter!.chapter.index + 1];
      // if (menu) {
      //   emit(state.copyWith(
      //       watchChapter:
      //           WatchChapter(chapter: chapter, status: StatusType.init)));
      //   return true;
      // }
      // final watch = await getContentsChapter(
      //     WatchChapter(chapter: chapter, status: StatusType.init));
      Future.delayed(const Duration(milliseconds: 300)).then(
        (value) {
          // emit(state.copyWith(watchChapter: watch));
          emit(state.copyWith(
              watchChapter:
                  WatchChapter(chapter: chapter, status: StatusType.init)));
        },
      );
    }
    easyRefreshController.finishLoad();
    return true;
  }

  void onChangeReadChapter(int index) {
    emit(state.copyWith(
        watchChapter:
            WatchChapter(chapter: _chapters[index], status: StatusType.init)));
    onInitWatchChapter();
  }

  void onInitWatchChapter() async {
    WatchChapter watch = state.watchChapter!;
    emit(state.copyWith(
        watchChapter: watch.copyWith(status: StatusType.loading)));
    watch = await getContentsChapter(state.watchChapter!);
    emit(state.copyWith(
        watchChapter: watch.copyWith(status: StatusType.loaded)));
  }

  void onEnableAutoScroll() async {
    await onHideCurrentMenu();
    _autoScrollController.enable();
  }

  void onCloseAutoScroll() async {
    await onHideCurrentMenu();
    _autoScrollController.closeAutoScroll();
  }

  void onUnpauseAutoScroll() async {
    _autoScrollController.start();
  }

  void onPauseAutoScroll() async {
    _autoScrollController.pause();
  }

  ScrollPhysics? get getPhysicsScroll {
    if (state.menuType != MenuType.autoScroll) {
      return null;
    }
    return const NeverScrollableScrollPhysics();
  }

  @override
  Future<void> close() {
    SystemUtils.setEnabledSystemUIModeDefault();
    SystemUtils.setPreferredOrientations();
    _autoScrollController.dispose();
    _menuAnimationController.dispose();
    DeviceUtils.disableWakelock();
    return super.close();
  }
}
