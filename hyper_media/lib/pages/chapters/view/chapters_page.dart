import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/dimens.dart';
import 'package:hyper_media/app/extensions/context_extension.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../../reader/reader/reader.dart';
import '../cubit/chapters_cubit.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  late ChaptersCubit _chaptersCubit;
  late Book _book;
  @override
  void initState() {
    _chaptersCubit = context.read<ChaptersCubit>();
    _book = _chaptersCubit.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_book.name),
        actions: const [
          // IconButton(
          //     onPressed: () {
          //       // _chaptersCubit.sortChapterType();
          //     },
          //     icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
        child: BlocBuilder<ChaptersCubit, ChaptersState>(
          builder: (context, state) {
            if (state.statusType == StatusType.loading) {
              return const LoadingWidget();
            }
            final chapters = state.chapters;
            return Column(
              children: [
                Divider(
                  height: 1,
                  color: colorScheme.surface,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    "${chapters.length} ${"book.chapter".tr()}",
                    style: textTheme.bodyMedium,
                  ),
                  trailing: PopupMenuButton<SortChapterType>(
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: SortChapterType.newChapter,
                          child: Text(
                            "book.new_chapter".tr(),
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    state.sortType == SortChapterType.newChapter
                                        ? colorScheme.primary
                                        : null),
                          ),
                          onTap: () {
                            _chaptersCubit
                                .sortChapterType(SortChapterType.newChapter);
                          },
                        ),
                        PopupMenuItem(
                          value: SortChapterType.lastChapter,
                          child: Text(
                            "book.last_chapter".tr(),
                            style: TextStyle(
                                fontSize: 14,
                                color: state.sortType ==
                                        SortChapterType.lastChapter
                                    ? colorScheme.primary
                                    : null),
                          ),
                          onTap: () {
                            _chaptersCubit
                                .sortChapterType(SortChapterType.lastChapter);
                          },
                        )
                      ];
                    },
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.sortType == SortChapterType.newChapter
                              ? "book.new_chapter".tr()
                              : "book.last_chapter".tr()),
                          const Icon(Icons.expand_more)
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.surface,
                ),
                Expanded(
                    child: ListChaptersWidget(
                  chapters: chapters,
                  usePage: UsePage.chapters,
                  onTapChapter: (chapter) {
                    final chaptersSor = _chaptersCubit.sort(
                        List<Chapter>.from(chapters),
                        SortChapterType.lastChapter);
                    Navigator.pushNamed(context, RoutesName.reader,
                        arguments: ReaderArgs(
                            book: _book.copyWith(currentIndex: chapter.index),
                            chapters: chaptersSor));
                  },
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}
