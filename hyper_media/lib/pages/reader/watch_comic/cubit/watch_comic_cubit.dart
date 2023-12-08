import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/download_service.dart';
import 'package:hyper_media/utils/logger.dart';
import 'package:hyper_media/utils/progress_watch_notifier.dart';
import 'package:hyper_media/utils/system_utils.dart';

import '../../reader/cubit/reader_cubit.dart';
import '../view/auto_scroll_widget.dart';
import '../view/watch_comic_view.dart';

part 'watch_comic_state.dart';

class WatchComicCubit extends Cubit<WatchComicState> {
  WatchComicCubit(
      {required DatabaseUtils database,
      required DownloadService downloadService,
      required ReaderCubit readerCubit})
      : _database = database,
        _downloadService = downloadService,
        _readerCubit = readerCubit,
        super(
          WatchComicState(
              settings: database.getSettingsComic,
              status: StatusType.init,
              watchChapter: readerCubit.watchChapterInit!),
        );
  final _logger = Logger("WatchComicCubit");

  final DatabaseUtils _database;
  final DownloadService _downloadService;

  final ReaderCubit _readerCubit;
  ProgressWatchNotifier progressWatchValue = ProgressWatchNotifier();
  final MenuController menuController = MenuController();

  Map<String, String> headersChapter = {};

  final AutoScrollController autoScrollController =
      AutoScrollController(scrollType: ScrollType.list);

  final ValueNotifier autoScrollStatus =
      ValueNotifier(AutoScrollStatus.noActive);

  ValueNotifier<double> timerAutoScrollStatus = ValueNotifier(5.0);

  Timer? _timerChangeAutoScroll;

  String get bookName => _readerCubit.book.name;

  @override
  void onChange(Change<WatchComicState> change) {
    super.onChange(change);
    final current = change.currentState;
    final next = change.nextState;
    if (current.settings != next.settings) {
      final nextSettings = next.settings;
      _applyWatchSetting(
          nextSettings, current.settings.watchType != next.settings.watchType);
      _database.setSettingsComic(next.settings);
    }
    if (change.currentState.watchChapter.index !=
        change.nextState.watchChapter.index) {
      _readerCubit.onChangeReader(change.nextState.watchChapter);
      progressWatchValue.value = ProgressWatch.init();
    }
  }

  void setHeight(double height) {
    autoScrollController.setHeight(height);
    autoScrollController.onScrollLister = (maxScrollExtent, offset, height) {
      progressWatchValue.addListenerProgress(
          maxScrollExtent: maxScrollExtent,
          offsetCurrent: offset,
          height: height);
    };
    autoScrollController.onCompleteCallback = () {
      final chapter = _readerCubit.onNextChapter(state.watchChapter.index);
      if (chapter == null) {
        onCloseAutoScroll();
      } else {
        getDetailChapter(chapter);
      }
    };
    timerAutoScrollStatus.value = autoScrollController.timeAutoScroll;
  }

  void onInit() {
    try {
      _applyWatchSetting(state.settings, true);
      headersChapter = {"Referer": _readerCubit.book.host};
      emit(state.copyWith(status: StatusType.loading));
      autoScrollController.clean();
      getDetailChapter(state.watchChapter);
    } catch (err) {
      _logger.error(err);
      emit(state.copyWith(status: StatusType.error));
    }
  }

  void _applyWatchSetting(WatchComicSettings settings, bool intController) {
    switch (settings.orientation) {
      case WatchOrientation.auto:
        SystemUtils.setOrientationAuto();
        break;
      case WatchOrientation.landscape:
        SystemUtils.setOrientationLandscape();
        break;
      case WatchOrientation.portrait:
        SystemUtils.setOrientationPortrait();
        break;
      default:
        break;
    }
    if (!intController) return;
    switch (settings.watchType) {
      case WatchComicType.webtoon:
        autoScrollController.initScrollController();
        break;
      case WatchComicType.horizontal:
      case WatchComicType.vertical:
        autoScrollController.initPageScroll();
        break;
      default:
        break;
    }
  }

  void onChangeSettings(WatchComicSettings settings) =>
      emit(state.copyWith(settings: settings));

  void onSaveImage(String url) async {
    final tmp = await _downloadService.saveImage(url, headers: headersChapter);
    print(tmp);
  }

  void onCopyImage(String url) async {
    final tmp =
        await _downloadService.clipboardImage(url, headers: headersChapter);
    print(tmp);
  }

  void getDetailChapter(Chapter chapter) async {
    try {
      emit(state.copyWith(status: StatusType.loading));

      if (chapter.contentComic != null && chapter.contentComic!.isNotEmpty) {
        emit(state.copyWith(watchChapter: chapter, status: StatusType.loaded));
      } else {
        chapter = await _readerCubit.getContentsChapter(chapter);
        if (chapter.contentComic != null) {
          emit(
              state.copyWith(watchChapter: chapter, status: StatusType.loaded));
        } else {
          emit(state.copyWith(status: StatusType.error));
        }
      }
    } catch (error) {
      emit(state.copyWith(watchChapter: chapter, status: StatusType.error));
    }
  }

  void onChangeSliderScroll(double value) {
    autoScrollController.jumpTo(value);
  }

  void onNext() {
    final chapter = _readerCubit.onNextChapter(state.watchChapter.index);
    if (chapter == null) return;
    autoScrollController.jumpTo(0.0);
    getDetailChapter(chapter);
  }

  void onPrevious() {
    final chapter = _readerCubit.onPreviousChapter(state.watchChapter.index);
    if (chapter == null) return;
    autoScrollController.jumpTo(0.0);
    getDetailChapter(chapter);
  }

  void onRefresh() async {
    try {
      emit(state.copyWith(status: StatusType.loading));
      final chapter = await _readerCubit.getContentsChapter(state.watchChapter,
          refresh: true);
      emit(state.copyWith(watchChapter: chapter, status: StatusType.loaded));
    } catch (error) {
      emit(state.copyWith(status: StatusType.error));
    }
  }

  String get progressReader =>
      "${state.watchChapter.index + 1}/${_readerCubit.chapters.length}";

  void onChangeChapter(Chapter chapter) {
    getDetailChapter(chapter);
  }

  void onEnableAutoScroll() {
    autoScrollController.enableAutoScroll();
    // menuController.hide();
    menuController.changeMenuType(MenuType.autoScroll);
  }

  void onCloseAutoScroll() {
    autoScrollController.closeAutoScroll();
    menuController.changeMenuType(MenuType.base);
  }

  void onChangeAutoScrollStatus(AutoScrollStatus status) {
    autoScrollStatus.value = status;
  }

  void onActionAutoScroll() {
    switch (autoScrollStatus.value) {
      case AutoScrollStatus.active:
        autoScrollController.closeAutoScroll();
        break;
      default:
        autoScrollController.enableAutoScroll();
        break;
    }
  }

  void onChangeTimeAutoScroll(double value) {
    timerAutoScrollStatus.value = value;
    if (_timerChangeAutoScroll != null) _timerChangeAutoScroll!.cancel();
    _timerChangeAutoScroll = Timer(const Duration(milliseconds: 300), () {
      autoScrollController.changeTimeAutoScroll(timerAutoScrollStatus.value);
    });
  }

  void onCheckAutoScrollNextChapter() {
    if (autoScrollStatus.value != AutoScrollStatus.complete) return;
    debugPrint("checkAutoNextChapter");
    Timer(const Duration(seconds: 2), () {
      autoScrollController.enableAutoScroll();
    });
  }

  void add() {
    _readerCubit.addBookmark();
  }

  @override
  Future<void> close() {
    SystemUtils.setOrientationAuto();
    autoScrollController.dispose();
    _timerChangeAutoScroll?.cancel();
    return super.close();
  }
}


// class ChapterCom