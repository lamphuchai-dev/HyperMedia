import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/dimens.dart';
import 'package:hyper_media/app/constants/gaps.dart';
import 'package:hyper_media/app/extensions/context_extension.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/chapters/chapters.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/detail_cubit.dart';
import 'book_detail.dart';

class BookLoaded extends StatefulWidget {
  const BookLoaded({super.key, required this.book});
  final Book book;

  @override
  State<BookLoaded> createState() => _BookLoadedState();
}

class _BookLoadedState extends State<BookLoaded> {
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
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final coverUrl = widget.book.cover;
    final book = widget.book;

    final expandedBarHeight =
        (context.height * 0.3) < 250 ? 250.0 : (context.height * 0.3);
    const paddingAppBar = 16.0;

    return Scaffold(
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
                      Navigator.pushNamed(context, RoutesName.webView,
                          arguments: book.bookUrl);
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
                            Flexible(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                clipBehavior: Clip.hardEdge,
                                child: CacheNetWorkImage(
                                  coverUrl,
                                ),
                              ),
                            ),
                            Gaps.wGap12,
                            Expanded(
                                flex: 3,
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
    );
  }

  Widget _tradingWidget(bool isBookmark, ColorScheme colorScheme, Book book,
      TextStyle textStyle) {
    if (isBookmark) {
      return GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, RoutesName.readBook,
          //     arguments: ReadBookArgs(
          //         book: book,
          //         chapters: [],
          //         readChapter: book.readBook?.index ?? 0,
          //         fromBookmarks: true,
          //         loadChapters: true));
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
      );
    } else {
      return GestureDetector(
        onTap: () {
          _detailCubit.addBookmark();
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
      );
    }
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
