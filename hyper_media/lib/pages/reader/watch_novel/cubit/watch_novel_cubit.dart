import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/auto_scroll_notifier.dart';
import 'package:hyper_media/utils/progress_watch_notifier.dart';
import 'package:js_runtime/js_runtime.dart';

import '../../reader/cubit/reader_cubit.dart';
import '../widgets/menu_novel.dart';

part 'watch_novel_state.dart';

class WatchNovelCubit extends Cubit<WatchNovelState> {
  WatchNovelCubit({required ReaderCubit readerBookCubit})
      : _readerCubit = readerBookCubit,
        super(WatchNovelState(
            status: StatusType.init,
            watchChapter: readerBookCubit.watchChapterInit!));

  final ReaderCubit _readerCubit;

  AutoScrollNotifier autoScrollValue = AutoScrollNotifier();
  ProgressWatchNotifier progressWatchValue = ProgressWatchNotifier();

  final ScrollController scrollController = ScrollController();

  final MenuNovelAnimationController menuController =
      MenuNovelAnimationController();

  Book get getBook => _readerCubit.book;

  String? _messageError;

  String? get getMessage => _messageError;

  void onInit() {
    getDetailChapter(state.watchChapter);
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

  void onEnableAutoScroll() async {
    await menuController.hide();
    menuController.changeMenu(MenuNovelType.autoScroll);
    autoScrollValue.start();
  }

  void onCloseAutoScroll() async {
    autoScrollValue.close();
    await menuController.hide();
    menuController.changeMenu(MenuNovelType.base);
  }

  void onChangeChapter(Chapter chapter) {
    getDetailChapter(chapter);
  }

  void onHideCurrentMenu() {
    menuController.hide();
  }

  void onActionAutoScroll() {
    autoScrollValue.onAction();
  }

  void onChangeTimeAutoScroll(double value) {
    autoScrollValue.onChangeTimerAuto(value);
  }

  bool onNext() {
    if (state.watchChapter.index + 1 >= _readerCubit.chapters.length) {
      return false;
    }
    final chapter = _readerCubit.chapters[state.watchChapter.index + 1];
    scrollController.jumpTo(0.0);
    getDetailChapter(chapter);
    return true;
  }

  void onPrevious() {
    final chapter = _readerCubit.chapters[state.watchChapter.index - 1];
    scrollController.jumpTo(0.0);
    getDetailChapter(chapter);
  }

  void onCheckAutoScrollNextChapter() {
    autoScrollValue.checkAutoNextChapter();
  }
}
