part of "../view/watch_novel_view.dart";

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
              return _ListChaptersWidget(
                index: _watchNovelCubit.state.watchChapter.index,
                chapters: chapters,
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

class _ListChaptersWidget extends StatefulWidget {
  const _ListChaptersWidget({
    required this.index,
    required this.chapters,
    required this.onTapChapter,
  });
  final List<Chapter> chapters;
  final int index;
  final ValueChanged<Chapter> onTapChapter;

  @override
  State<_ListChaptersWidget> createState() => __ListChaptersWidgetState();
}

class __ListChaptersWidgetState extends State<_ListChaptersWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final valueJumTo = widget.index * 56.0;
      if (valueJumTo > _scrollController.position.maxScrollExtent) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.jumpTo(valueJumTo);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: DraggableScrollbar.arrows(
        controller: _scrollController,
        backgroundColor: colorScheme.primary,
        heightScrollThumb: 40,
        child: ListView.builder(
          itemCount: widget.chapters.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            final chapter = widget.chapters[index];
            final colorItemSelected = widget.index == index
                ? colorScheme.primary
                : textTheme.labelMedium?.color;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              tileColor: colorScheme.surface,
              leading: SizedBox(
                width: 40,
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: colorItemSelected,
                ),
              ),
              horizontalTitleGap: 0,
              title: Text(
                chapter.name,
                style:
                    textTheme.labelMedium?.copyWith(color: colorItemSelected),
              ),
              onTap: () => widget.onTapChapter.call(chapter),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class SliderCustom {
  final double offset;
  final bool show;
  SliderCustom({
    required this.offset,
    this.show = false,
  });

  SliderCustom copyWith({
    double? offset,
    bool? show,
  }) {
    return SliderCustom(
      offset: offset ?? this.offset,
      show: show ?? this.show,
    );
  }
}

class ChildModel {
  final Size size;
  final Offset offset;
  final double value;
  ChildModel({required this.size, required this.offset, required this.value});

  @override
  String toString() => 'ChildModel(size: $size, offset: $offset)';

  ChildModel copyWith({
    Size? size,
    Offset? offset,
    double? value,
  }) {
    return ChildModel(
      size: size ?? this.size,
      offset: offset ?? this.offset,
      value: value ?? this.value,
    );
  }
}
