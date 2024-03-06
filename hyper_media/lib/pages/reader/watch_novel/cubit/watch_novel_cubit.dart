import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/auto_scroll_notifier.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/mixin_watch_chapter.dart';
import 'package:hyper_media/utils/progress_watch_notifier.dart';
import 'package:js_runtime/js_runtime.dart';

import '../../reader/cubit/reader_cubit.dart';
import '../watch_novel.dart';

part 'watch_novel_state.dart';

class WatchNovelCubit extends Cubit<WatchNovelState> with MixinWatchChapter {
  WatchNovelCubit({
    required ReaderCubit readerBookCubit,
    required DatabaseUtils database,
  })  : _readerCubit = readerBookCubit,
        _database = database,
        super(WatchNovelState(
            status: StatusType.init,
            watchChapter: readerBookCubit.watchChapterInit!,
            settings: database.getSettingsNovel));

  final ReaderCubit _readerCubit;
  final DatabaseUtils _database;

  AutoScrollNotifier autoScrollValue = AutoScrollNotifier();
  ProgressWatchNotifier progressWatchValue = ProgressWatchNotifier();

  final ScrollController scrollController = ScrollController();

  final menuController = MenuWatchNovelController();

  Book get getBook => _readerCubit.book;

  String? _messageError;

  String? get getMessage => _messageError;

  void onInit() {
    getDetailChapter(state.watchChapter);
  }

  @override
  void onChange(Change<WatchNovelState> change) {
    super.onChange(change);
    final current = change.currentState;
    final next = change.nextState;
    if (current.settings != next.settings) {
      final nextSettings = next.settings;
      _database.setSettingsNovel(nextSettings);
    }
    if (change.currentState.watchChapter.index !=
        change.nextState.watchChapter.index) {
      _readerCubit.onChangeReader(change.nextState.watchChapter);
    }
  }

  String get progressReader =>
      "${state.watchChapter.index + 1}/${_readerCubit.chapters.length}";

  void setup(double height) {
    autoScrollValue.init(scrollController: scrollController, height: height);
    autoScrollValue.onCompleteCallback = () {
      final isNextChapter = onNext();
      if (isNextChapter) return;
      onCloseAutoScroll();
    };
    scrollController.addListener(() {
      progressWatchValue.addListenerProgress(
          maxScrollExtent: scrollController.position.maxScrollExtent,
          offsetCurrent: scrollController.offset,
          height: height);
      autoScrollValue.update();
    });
  }

  void getDetailChapter(Chapter chapter) async {
    try {
      if (chapter.contentComic != null && chapter.contentComic!.isNotEmpty) {
        emit(state.copyWith(watchChapter: chapter, status: StatusType.loaded));
      } else {
        emit(state.copyWith(watchChapter: chapter, status: StatusType.loading));
        chapter = await _readerCubit.getContentsChapter(chapter);
        emit(state.copyWith(watchChapter: chapter, status: StatusType.loaded));
      }
    } on JsRuntimeException catch (error) {
      _messageError = error.message;
      emit(state.copyWith(watchChapter: chapter, status: StatusType.error));
    } catch (error) {
      emit(state.copyWith(watchChapter: chapter, status: StatusType.error));
    }
  }

  @override
  void onEnableAutoScroll() async {
    await menuController.hide();
    menuController.changeMenu(MenuNovelType.autoScroll);
    autoScrollValue.start();
  }

  @override
  void onCloseAutoScroll() async {
    autoScrollValue.close();
    await menuController.hide();
    menuController.changeMenu(MenuNovelType.base);
  }

  void onChangeChapter(Chapter chapter) {
    getDetailChapter(chapter);
  }

  @override
  void onActionAutoScroll() {
    autoScrollValue.onAction();
  }

  @override
  void onChangeTimeAutoScroll(double value) {
    autoScrollValue.onChangeTimerAuto(value);
  }

  @override
  bool onNext() {
    if (state.watchChapter.index + 1 >= _readerCubit.chapters.length) {
      return false;
    }
    final chapter = _readerCubit.chapters[state.watchChapter.index + 1];
    if (scrollController.hasClients) scrollController.jumpTo(0.0);
    getDetailChapter(chapter);
    return true;
  }

  @override
  void onPrevious() {
    final chapter = _readerCubit.chapters[state.watchChapter.index - 1];
    if (scrollController.hasClients) scrollController.jumpTo(0.0);
    getDetailChapter(chapter);
  }

  @override
  void onCheckAutoScrollNextChapter() {
    autoScrollValue.checkAutoNextChapter();
  }

  void onCloseMenu() {
    menuController.hide();
  }

  void onChangeSetting(WatchNovelSetting setting) {
    emit(state.copyWith(settings: setting));
  }

  ThemeData themeData(ThemeData current) {
    final themeWatchNovel = state.settings.themeWatchNovel;
    final colorScheme = current.colorScheme.copyWith(
        background: themeWatchNovel.background,
        surface: themeWatchNovel.background);
    final iconTheme = current.iconTheme.copyWith(color: themeWatchNovel.text);
    final textTheme = current.textTheme.merge(TextTheme(
      labelMedium: TextStyle(color: themeWatchNovel.text),
      bodyMedium: TextStyle(color: themeWatchNovel.text),
    ));
    return current.copyWith(
        colorScheme: colorScheme, iconTheme: iconTheme, textTheme: textTheme);
  }

  @override
  void onRefresh() {}
}
