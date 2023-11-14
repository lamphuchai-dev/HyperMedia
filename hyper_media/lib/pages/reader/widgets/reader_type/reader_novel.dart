// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';

import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/reader/cubit/reader_cubit.dart';

class WatchNovel extends StatefulWidget {
  const WatchNovel({
    Key? key,
    required this.chapter,
  }) : super(key: key);
  final Chapter chapter;

  @override
  State<WatchNovel> createState() => _WatchNovelState();
}

class _WatchNovelState extends State<WatchNovel> {
  late Chapter _chapter;
  late ReaderCubit _readerCubit;

  final ValueNotifier<double> _watchProgress = ValueNotifier(0.0);
  late ScrollController _scrollController;

  @override
  void initState() {
    _chapter = widget.chapter;
    _readerCubit = context.read<ReaderCubit>();
    _scrollController = ScrollController();
    _readerCubit.setScrollController(_scrollController);
    _scrollController.addListener(() {
      _handlerProgress();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_readerCubit.state.menuType == MenuType.autoScroll) {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          _readerCubit.onUnpauseAutoScroll();
        });
      }
    });
    super.initState();
  }

  void _handlerProgress() {
    _watchProgress.value = (_scrollController.offset /
            _scrollController.position.maxScrollExtent) *
        100;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.wGap8,
                Expanded(
                    child: Text(
                  _chapter.name,
                  style: textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                )),
                Gaps.wGap8,
              ],
            ),
            Expanded(
                child: BlocSelector<ReaderCubit, ReaderState, bool>(
              selector: (state) => state.menuType == MenuType.autoScroll,
              builder: (context, state) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  // physics: AlwaysScrollableScrollPhysics(
                  //     parent: BouncingScrollPhysics()),
                  child: Text(
                    _chapter.contentNovel!,
                    style: textTheme.bodyLarge,
                    // scrollPhysics: AlwaysScrollableScrollPhysics(),

                    // scrollPhysics: const AlwaysScrollableScrollPhysics(),
                  ),
                );
              },
            )),
            Gaps.hGap4,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.wGap4,
                Expanded(
                    child: Text(
                  "${_chapter.index + 1}/${_readerCubit.getChapters.length}",
                  style: textTheme.bodySmall?.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                )),
                Expanded(
                    child: ValueListenableBuilder(
                  valueListenable: _watchProgress,
                  builder: (context, value, child) => Text(
                    "${value.toInt()}%",
                    style: textTheme.bodySmall?.copyWith(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                )),
                Gaps.wGap4,
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _watchProgress.dispose();
    super.dispose();
  }
}
