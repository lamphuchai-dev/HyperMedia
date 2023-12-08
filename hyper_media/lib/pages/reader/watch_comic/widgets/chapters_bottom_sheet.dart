part of '../view/watch_comic_view.dart';

class ChaptersBottomSheet extends StatefulWidget {
  const ChaptersBottomSheet(
      {super.key,
      required this.readerCubit,
      required this.currentIndex,
      required this.onTapChapter});
  final ReaderCubit readerCubit;
  final int currentIndex;
  final ValueChanged<Chapter> onTapChapter;

  @override
  State<ChaptersBottomSheet> createState() => _ChaptersBottomSheetState();
}

class _ChaptersBottomSheetState extends State<ChaptersBottomSheet> {
  late ReaderCubit _readerCubit;

  List<Chapter> _chapters = [];
  DraggableScrollableController? _controller;

  ScrollController? _scrollController;

  @override
  void initState() {
    _readerCubit = widget.readerCubit;
    _chapters = _readerCubit.chapters;
    _controller = DraggableScrollableController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double jumpTo = widget.currentIndex * 56.0;
      if (jumpTo < (context.height * 0.4 - 80 - 56)) return;
      if (jumpTo > _scrollController!.position.maxScrollExtent) {
        jumpTo =
            _scrollController!.position.maxScrollExtent - context.height * 0.4;
      }
      _controller?.jumpTo(0.8);
      _scrollController?.jumpTo(jumpTo);
    });
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
    final colorScheme = context.colorScheme;
    final book = _readerCubit.book;
    final textTheme = context.appTextTheme;

    return DraggableScrollableSheetWidget(
      maxChildSize: 0.8,
      initialChildSize: 0.4,
      controller: _controller,
      builder: (context, scrollController) {
        _scrollController = scrollController;
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 81,
              automaticallyImplyLeading: false,
              surfaceTintColor: colorScheme.background,
              backgroundColor: colorScheme.background,
              title: Container(
                color: colorScheme.background,
                height: 81,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 4,
                            child: BookCoverImage(
                              cover: book.cover,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Gaps.wGap12,
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RoutesName.detail,
                                  arguments: book.bookUrl);
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
                              ))
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.surface,
                    )
                  ],
                ),
              ),
            ),
          ],
          body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: DraggableScrollbar.arrows(
              controller: _scrollController!,
              child: ListView.builder(
                itemCount: _chapters.length,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                  title: Text(_chapters[index].name),
                  titleTextStyle: textTheme.bodySmall,
                  selectedColor: colorScheme.primary,
                  selected: widget.currentIndex == _chapters[index].index,
                  onTap: () {
                    widget.onTapChapter.call(_chapters[index]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
