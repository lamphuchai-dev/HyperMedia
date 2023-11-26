import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/auto_scroll_notifier.dart';
import 'package:hyper_media/utils/progress_watch_notifier.dart';

import '../../reader/cubit/reader_cubit.dart';
import '../widgets/menu_comic_animation.dart';

part 'watch_comic_state.dart';

class WatchComicCubit extends Cubit<WatchComicState> {
  WatchComicCubit({required ReaderCubit readerBookCubit})
      : _readerCubit = readerBookCubit,
        super(WatchComicState(
            watchChapter: readerBookCubit.watchChapterInit!,
            watchStatus: StatusType.init));
  final MenuComicAnimationController menuWatchController =
      MenuComicAnimationController();
  final ReaderCubit _readerCubit;
  final ScrollController scrollController = ScrollController();
  ProgressWatchNotifier progressWatchValue = ProgressWatchNotifier();
  AutoScrollNotifier autoScrollValue = AutoScrollNotifier();
  void onInit() async {
    getDetailChapter(state.watchChapter);
  }

  @override
  void onChange(Change<WatchComicState> change) {
    super.onChange(change);
    if (change.currentState.watchChapter.index !=
        change.nextState.watchChapter.index) {
      _readerCubit.onChangeReader(change.nextState.watchChapter);
      progressWatchValue.value = ProgressWatch.init();
    }
  }

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

  String get bookName => _readerCubit.book.name;

  void getDetailChapter(Chapter chapter) async {
    try {
      if (chapter.contentComic != null && chapter.contentComic!.isNotEmpty) {
        emit(state.copyWith(
            watchChapter: chapter, watchStatus: StatusType.loaded));
      } else {
        emit(state.copyWith(watchStatus: StatusType.loading));
        chapter = await _readerCubit.getContentsChapter(chapter);
        emit(state.copyWith(
            watchChapter: chapter, watchStatus: StatusType.loaded));
      }
    } catch (error) {
      emit(
          state.copyWith(watchChapter: chapter, watchStatus: StatusType.error));
    }
  }

  void onRefresh() async {
    try {
      emit(state.copyWith(watchStatus: StatusType.loading));
      final chapter = await _readerCubit.getContentsChapter(state.watchChapter,
          refresh: true);
      emit(state.copyWith(
          watchChapter: chapter, watchStatus: StatusType.loaded));
    } catch (error) {
      emit(state.copyWith(watchStatus: StatusType.error));
    }
  }

  String get progressReader =>
      "${state.watchChapter.index + 1}/${_readerCubit.chapters.length}";

  void onEnableAutoScroll() {
    autoScrollValue.start();
    menuWatchController.hide();
    menuWatchController.changeMenu();
  }

  void onCloseAutoScroll() {
    autoScrollValue.close();
    menuWatchController.hide();
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

  void onChangeSliderScroll(double value) {
    if (scrollController.hasClients) {
      final of = (value / 100) * scrollController.position.maxScrollExtent;
      scrollController.jumpTo(of);
    }
  }

  void onActionAutoScroll() {
    autoScrollValue.onAction();
  }

  void onCheckAutoScrollNextChapter() {
    autoScrollValue.checkAutoNextChapter();
  }

  void onChangeChapter(Chapter chapter) {
    getDetailChapter(chapter);
  }

  void add() {
    _readerCubit.addBookmark();
  }
}
