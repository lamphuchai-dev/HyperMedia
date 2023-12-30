part of '../view/detail_view.dart';

class BookDetail extends StatefulWidget {
  const BookDetail({super.key});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  late DetailCubit _detailCubit;

  final collapsedBarHeight = kToolbarHeight;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isCollapsed = ValueNotifier(false);
  final ValueNotifier<double> _offset = ValueNotifier(0.0);

  late Book _book;
  @override
  void initState() {
    _detailCubit = context.read<DetailCubit>();
    _detailCubit.onInitFToat(context);
    _book = _detailCubit.bookState.data!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = _book.cover;
    final book = _book;

    final expandedBarHeight =
        (context.height * 0.3) < 250 ? 250.0 : (context.height * 0.3);
    const paddingAppBar = 16.0;

    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: NotificationListener(
          onNotification: (notification) {
            if (_scrollController.hasClients &&
                _scrollController.offset <=
                    (expandedBarHeight - collapsedBarHeight)) {
              _offset.value = _scrollController.offset / (expandedBarHeight);
            }

            if (_scrollController.hasClients &&
                _scrollController.offset >
                    (expandedBarHeight - collapsedBarHeight) &&
                !isCollapsed.value) {
              isCollapsed.value = true;
            } else if (!(_scrollController.hasClients &&
                    _scrollController.offset >
                        (expandedBarHeight - collapsedBarHeight)) &&
                isCollapsed.value) {
              isCollapsed.value = false;
            }
            return false;
          },
          child: RawScrollbar(
            controller: _scrollController,
            radius: const Radius.circular(8),
            thumbColor: colorScheme.surface,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: expandedBarHeight,
                  collapsedHeight: collapsedBarHeight,
                  centerTitle: false,
                  pinned: true,
                  title: ValueListenableBuilder(
                    valueListenable: _offset,
                    builder: (context, value, child) => Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Text(book.name),
                    ),
                  ),
                  elevation: 0,
                  leading: const BackButton(
                    color: Colors.white,
                  ),
                  actions: [
                    BlocSelector<DetailCubit, DetailState, Book>(
                      selector: (state) {
                        return state.bookState.data!;
                      },
                      builder: (context, book) {
                        if (book.id == null) {
                          return IconButton(
                              onPressed: () {
                                _detailCubit.addBookmark();
                              },
                              icon: const Icon(Icons.bookmark_add_rounded));
                        }
                        return IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.bookmark,
                              color: colorScheme.primary,
                            ));
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          _detailCubit.openBrowser();
                        },
                        icon: const Icon(Icons.public))
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                            child: BlurredBackdropImage(
                          url: coverUrl,
                        )),
                        Positioned.fill(
                          top: kToolbarHeight,
                          bottom: paddingAppBar,
                          right: 0,
                          left: 0,
                          child: SafeArea(
                            child: Row(
                              children: [
                                Gaps.wGap16,
                                AspectRatio(
                                  aspectRatio: 2 / 3,
                                  child: BookCoverImage(
                                    cover: coverUrl,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                Gaps.wGap12,
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Text(
                                          book.name,
                                          style: textTheme.titleLarge,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(
                                        book.author,
                                        maxLines: 2,
                                      ),
                                      Text(book.bookStatus),
                                      Text(book.totalChapters == 0
                                          ? ""
                                          : book.totalChapters.toString()),
                                    ])),
                                Gaps.wGap16,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontalPadding, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Thể loại"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _book.genres
                              .map((e) => GenreCard(
                                  genre: e,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutesName.genre,
                                        arguments: GenreBookArg(
                                            genre: e,
                                            extension:
                                                _detailCubit.getExtension));
                                  }))
                              .toList(),
                        ),
                      ),
                      const Text("Giới thiệu"),
                      ReadMoreText(
                        _book.description,
                        trimLines: 4,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Xem thêm',
                        trimExpandedText: ' Ẩn',
                        moreStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                        lessStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      )
                    ],
                  ),
                )),
                MultiSliver(
                  children: [
                    BlocSelector<DetailCubit, DetailState,
                        StateRes<List<Chapter>>>(
                      selector: (state) {
                        return state.chaptersState;
                      },
                      builder: (context, chaptersRes) {
                        return switch (chaptersRes.status) {
                          StatusType.loading => MultiSliver(children: [
                              SliverPinnedHeader(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Row(
                                    children: [
                                      LoadingWidget(
                                        radius: 8,
                                      ),
                                      Gaps.wGap8,
                                      Expanded(
                                          child: Text(
                                              "Đang lấy danh sách chương")),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          StatusType.loaded => MultiSliver(
                              children: [
                                SliverPinnedHeader(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 4, top: 2, bottom: 2),
                                    decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Số chương ${chaptersRes.data!.length}",
                                          style: textTheme.titleMedium,
                                        )),
                                        IconButton(
                                            onPressed: () {
                                              // _detailCubit.reverseChapters();
                                              showSearch(
                                                      context: context,
                                                      delegate:
                                                          ChapterSearchDelegate(
                                                              chapters: _detailCubit
                                                                  .chaptersState
                                                                  .data!))
                                                  .then((value) {
                                                if (value != null &&
                                                    value is Chapter) {
                                                  Navigator.pushNamed(context,
                                                      RoutesName.reader,
                                                      arguments: ReaderArgs(
                                                          book: _book.copyWith(
                                                              currentIndex:
                                                                  value.index),
                                                          chapters: chaptersRes
                                                              .data!));
                                                }
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.search_rounded)),
                                        IconButton(
                                            onPressed: () {
                                              _detailCubit.reverseChapters();
                                            },
                                            icon: const Icon(Icons.sort))
                                      ],
                                    ),
                                  ),
                                ),
                                SliverAnimatedPaintExtent(
                                  duration: const Duration(seconds: 3),
                                  child: SliverList.builder(
                                    itemCount: chaptersRes.data!.length,
                                    itemBuilder: (context, index) {
                                      final chapter = chaptersRes.data![index];
                                      return ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, RoutesName.reader,
                                              arguments: ReaderArgs(
                                                  book: _book.copyWith(
                                                      currentIndex:
                                                          chapter.index),
                                                  chapters: chaptersRes.data!));
                                        },
                                        title: Text(
                                          chapter.name,
                                          style: textTheme.bodyMedium,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          StatusType.error => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(chaptersRes.message ?? "ERR"),
                            ),
                          _ => const SizedBox()
                        };
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.reader,
                arguments: ReaderArgs(
                    book: book,
                    chapters: _detailCubit.chaptersState.data ?? []));
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8)),
              child: ValueListenableBuilder(
                valueListenable: isCollapsed,
                builder: (context, value, child) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow_rounded),
                    if (!value) ...[
                      Gaps.wGap8,
                      if (_book.id != null)
                        Text(
                          "Đọc tiếp",
                          style: textTheme.labelMedium,
                        ),
                      if (_book.id == null)
                        Text(
                          "Đọc từ đầu",
                          style: textTheme.labelMedium,
                        )
                    ],
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
