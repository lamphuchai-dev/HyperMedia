import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/gaps.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/reader/watch_novel/cubit/watch_novel_cubit.dart';
import 'package:hyper_media/widgets/widget.dart';

import '../../reader/cubit/reader_cubit.dart';

class ChaptersDrawer extends StatefulWidget {
  const ChaptersDrawer({super.key});

  @override
  State<ChaptersDrawer> createState() => _ChaptersDrawerState();
}

class _ChaptersDrawerState extends State<ChaptersDrawer> {
  final backgroundColor = Colors.grey;
  late ReaderCubit _readerCubit;
  late WatchNovelCubit _watchNovelCubit;
  late Book _book;

  @override
  void initState() {
    _readerCubit = context.read<ReaderCubit>();
    _watchNovelCubit = context.read<WatchNovelCubit>();
    _book = _readerCubit.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Drawer(
      width: context.width * 0.85,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(),
      child: Column(children: [
        _headerDrawer(),
        Expanded(
          child: BlocSelector<ReaderCubit, ReaderState, List<Chapter>>(
            selector: (state) {
              return state.chapters;
            },
            builder: (context, chapters) {
              return ListChaptersWidget(
                indexSelect: _watchNovelCubit.state.watchChapter.index,
                chapters: chapters,
                usePage: UsePage.readChapter,
                onTapChapter: (chapter) {
                  _watchNovelCubit.onChangeChapter(chapter);
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ),
        // if (_book.type != BookType.video)
        ColoredBox(
          color: colorScheme.background,
          child: SafeArea(
            top: false,
            bottom: true,
            child: Container(
              height: 56,
              decoration: BoxDecoration(color: colorScheme.background),
              alignment: Alignment.center,
              child: Row(
                children: [
                  const Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.download_rounded),
                  )),
                  Gaps.wGap8,
                  Text(
                    "book.downloadBookChapters"
                        .tr(args: [_readerCubit.chapters.length.toString()]),
                    style: textTheme.titleMedium,
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget _headerDrawer() {
    return SizedBox(
      height: context.height * 0.22,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesName.detail,
              arguments: _book.bookUrl);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
                child: BlurredBackdropImage(
              url: _book.cover,
            )),
            Positioned(
                top: kToolbarHeight,
                left: 16,
                bottom: 10,
                right: 0,
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: BookCoverImage(
                        cover: _book.cover,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(_book.name),
                          ),
                          Expanded(child: Text(_book.author))
                        ],
                      ),
                    ))
                  ],
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _readerCubit.onRefreshChapters();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
