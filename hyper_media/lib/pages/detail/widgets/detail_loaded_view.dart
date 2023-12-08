part of '../view/detail_view.dart';

class DetailLoadedView extends StatefulWidget {
  const DetailLoadedView({super.key, required this.book});
  final Book book;

  @override
  State<DetailLoadedView> createState() => _DetailLoadedViewState();
}

class _DetailLoadedViewState extends State<DetailLoadedView> {
  late DetailCubit _detailCubit;

  final collapsedBarHeight = kToolbarHeight;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isCollapsed = ValueNotifier(false);
  final ValueNotifier<double> _offset = ValueNotifier(0.0);
  @override
  void initState() {
    _detailCubit = context.read<DetailCubit>();
    _detailCubit.onInitFToat(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = widget.book.cover;
    final book = widget.book;

    final expandedBarHeight =
        (context.height * 0.3) < 250 ? 250.0 : (context.height * 0.3);
    const paddingAppBar = 16.0;

    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => Scaffold(
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
                  IconButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, RoutesName.webView,
                        //     arguments: book.bookUrl);
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
                child: BookDetail(
                  book: book,
                  extension: _detailCubit.getExtension,
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: SlideTransitionAnimation(
          runAnimation: true,
          type: AnimationType.bottomToTop,
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimens.horizontalPadding, vertical: 10),
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.background,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(Dimens.radius)),
                      alignment: Alignment.center,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.download_rounded),
                            Text(
                              "Tải truyện",
                              style: textTheme.titleSmall,
                            )
                          ]),
                    ),
                  ),
                  Gaps.wGap8,
                  Expanded(
                      child: _listChapters(colorScheme.primary, widget.book)),
                  Gaps.wGap8,
                  BlocBuilder<DetailCubit, DetailState>(
                    builder: (context, state) {
                      return _tradingWidget(
                          (state as DetailLoaded).book.id != null,
                          colorScheme,
                          widget.book,
                          textTheme.titleSmall!);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tradingWidget(bool isBookmark, ColorScheme colorScheme, Book book,
      TextStyle textStyle) {
    return LoadingAction(
        onAction: () async {
          await _detailCubit.addBookmark();
        },
        initialDone: book.id != null,
        init: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(Dimens.radius)),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bookmark_add_rounded,
                size: 30,
              ),
              Text(
                "Thêm vào kệ",
                style: textStyle,
              )
            ],
          ),
        ),
        progress: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(Dimens.radius)),
          alignment: Alignment.center,
          child: const LoadingWidget(
            radius: 12,
          ),
        ),
        done: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.reader,
                arguments: ReaderArgs(book: book, chapters: []));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(Dimens.radius)),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RotatedBox(
                  quarterTurns: -2,
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 30,
                  ),
                ),
                Text(
                  "Đọc tiếp",
                  style: textStyle,
                )
              ],
            ),
          ),
        ));
  }

  Widget _listChapters(Color primaryColor, Book book) {
    final textTheme = context.appTextTheme;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.chaptersBook,
            arguments: ChaptersBookArgs(
                book: book, extensionModel: _detailCubit.getExtension));
      },
      child: Container(
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(Dimens.radius)),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 30,
            ),
            Text(
              "book.menu_book".tr(),
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
