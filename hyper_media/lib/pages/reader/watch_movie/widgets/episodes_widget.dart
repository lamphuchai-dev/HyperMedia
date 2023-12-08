part of '../view/watch_movie_view.dart';

class EpisodesWidget extends StatefulWidget {
  const EpisodesWidget({super.key, required this.onTapChapter});
  final ValueChanged<Chapter> onTapChapter;

  @override
  State<EpisodesWidget> createState() => _EpisodesWidgetState();
}

class _EpisodesWidgetState extends State<EpisodesWidget> {
  late ReaderCubit _readerCubit;

  List<Chapter> _chapters = [];

  @override
  void initState() {
    _readerCubit = context.read<ReaderCubit>();
    _chapters = _readerCubit.chapters;
    super.initState();
  }

  void _reversedChapter() {
    setState(() {
      _chapters = _chapters.reversed.toList();
    });
  }

  void _refreshChapters() async {
    final isNewChapter = await _readerCubit.onRefreshChapters();
    if (isNewChapter) {
      _chapters = _readerCubit.chapters;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = _readerCubit.book;
    final textTheme = context.appTextTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Gaps.hGap12,
        SizedBox(
          height: 60,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: BookCoverImage(
                  cover: book.cover,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Gaps.wGap12,
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, RoutesName.detail,
                  //     arguments: book.bookUrl);
                },
                child: Text(
                  book.name,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )),
              IconButtonComic(
                  onTap: () {
                    _refreshChapters();
                  },
                  size: const Size(35, 35),
                  icon: const Icon(
                    Icons.refresh_rounded,
                  )),
              Gaps.wGap12,
              IconButtonComic(
                  onTap: () {
                    _reversedChapter();
                  },
                  size: const Size(35, 35),
                  icon: const Icon(
                    Icons.swap_vert_rounded,
                  )),
            ],
          ),
        ),
        Gaps.hGap12,
        BlocSelector<WatchMovieCubit, WatchMovieState, Chapter>(
          selector: (state) {
            return state.watchChapter;
          },
          builder: (context, watchChapter) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _chapters
                  .map((chapter) => ChapterCard(
                        chapter: chapter,
                        currentWatch: chapter.index == watchChapter.index,
                        onTap: () {
                          widget.onTapChapter.call(chapter);
                        },
                      ))
                  .toList(),
            );
          },
        ),
        Gaps.hGap12,
      ]),
    );
  }
}

class ChapterCard extends StatelessWidget {
  const ChapterCard(
      {super.key,
      required this.chapter,
      required this.currentWatch,
      required this.onTap});
  final Chapter chapter;
  final bool currentWatch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: currentWatch ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(color: colorScheme.surface),
            color: currentWatch ? colorScheme.primary : null,
            borderRadius: BorderRadius.circular(6)),
        child: Text(chapter.name),
      ),
    );
  }
}
