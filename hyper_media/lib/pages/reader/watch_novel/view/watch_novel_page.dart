part of "./watch_novel_view.dart";

class WatchNovelPage extends StatefulWidget {
  const WatchNovelPage({super.key});

  @override
  State<WatchNovelPage> createState() => _WatchNovelPageState();
}

class _WatchNovelPageState extends State<WatchNovelPage> {
  late WatchNovelCubit _watchNovelCubit;

  @override
  void initState() {
    _watchNovelCubit = context.read<WatchNovelCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchNovelCubit.setup(context.height);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WatchNovelCubit, WatchNovelState, ThemeWatchNovel>(
      selector: (state) {
        return state.settings.themeWatchNovel;
      },
      builder: (context, themeWatchNovel) {
        return Theme(
          data: _watchNovelCubit.themeData(context.appTheme),
          child: Scaffold(
            drawer: const ChaptersDrawer(),
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _watchNovelCubit.menuController.onTapScreen,
                    onPanDown: (_) =>
                        _watchNovelCubit.menuController.onTouchScreen(),
                    child: BlocSelector<WatchNovelCubit, WatchNovelState,
                        WatchNovelSetting>(
                      selector: (state) {
                        return state.settings;
                      },
                      builder: (context, settings) {
                        return Container(
                          color: themeWatchNovel.background,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.horizontalPadding),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: settings.themeWatchNovel.text,
                              fontSize: settings.fontSize,
                              wordSpacing: settings.textScaleFactor,
                            ),
                            child: SafeArea(
                              bottom: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocSelector<WatchNovelCubit, WatchNovelState,
                                      Chapter>(
                                    selector: (state) => state.watchChapter,
                                    builder: (context, chapter) {
                                      return Text(
                                        chapter.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: BlocConsumer<WatchNovelCubit,
                                        WatchNovelState>(
                                      listenWhen: (previous, current) {
                                        // Kiểm tra điều kiện để tự động chạy autoScroll khi qua chương mới
                                        // Qua chương đã có nội dung

                                        if (previous.watchChapter.index !=
                                                current.watchChapter.index &&
                                            current.status ==
                                                StatusType.loaded) {
                                          return true;
                                          // Qua chương chưa có nội dung , loaded xong nội dung
                                        } else if (previous
                                                    .watchChapter.index ==
                                                current.watchChapter.index &&
                                            previous.status !=
                                                StatusType.loaded &&
                                            current.status ==
                                                StatusType.loaded) {
                                          return true;
                                        } else {
                                          return false;
                                        }
                                      },
                                      listener: (context, state) {
                                        _watchNovelCubit
                                            .onCheckAutoScrollNextChapter();
                                      },
                                      buildWhen: (previous, current) =>
                                          previous.status != current.status ||
                                          previous.watchChapter !=
                                              current.watchChapter,
                                      builder: (context, state) {
                                        return switch (state.status) {
                                          StatusType.loading =>
                                            const LoadingWidget(),
                                          StatusType.loaded => switch (
                                                settings.watchType) {
                                              WatchNovelType.horizontal =>
                                                ValueListenableBuilder(
                                                  valueListenable:
                                                      _watchNovelCubit
                                                          .autoScrollValue,
                                                  builder:
                                                      (context, value, child) {
                                                    return SingleChildScrollView(
                                                      physics: value ==
                                                              AutoScrollStatus
                                                                  .active
                                                          ? const NeverScrollableScrollPhysics()
                                                          : null,
                                                      controller:
                                                          _watchNovelCubit
                                                              .scrollController,
                                                      child: TextContent(
                                                        data: state.watchChapter
                                                            .contentNovel!,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              WatchNovelType.vertical =>
                                                _WatchNovelVertical(
                                                    content: state.watchChapter
                                                        .contentNovel!),
                                            },
                                          StatusType.error => Center(
                                              child: Text(
                                                _watchNovelCubit.getMessage ??
                                                    "Error",
                                              ),
                                            ),
                                          _ => const SizedBox()
                                        };
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: ValueListenableBuilder(
                                      valueListenable:
                                          _watchNovelCubit.progressWatchValue,
                                      builder: (context, value, child) {
                                        return Row(
                                          children: [
                                            BlocBuilder<WatchNovelCubit,
                                                WatchNovelState>(
                                              buildWhen: (previous, current) =>
                                                  previous.watchChapter !=
                                                  current.watchChapter,
                                              builder: (context, state) {
                                                return Text(
                                                  _watchNovelCubit
                                                      .progressReader,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                );
                                              },
                                            ),
                                            const Expanded(child: SizedBox()),
                                            if (value != null)
                                              Row(
                                                children: [
                                                  Text(
                                                    value.getProgressPage,
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  Gaps.wGap8,
                                                  Text(
                                                    value.getPercent,
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                    child: MenuWatchNovel(
                        watchNovelCubit: _watchNovelCubit,
                        controller: _watchNovelCubit.menuController))
              ],
            ),
          ),
        );
      },
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
    );
  }
}

class _WatchNovelVertical extends StatefulWidget {
  const _WatchNovelVertical({required this.content});
  final String content;

  @override
  State<_WatchNovelVertical> createState() => __WatchNovelVerticalState();
}

class __WatchNovelVerticalState extends State<_WatchNovelVertical> {
  final TextStyle _textStyle = const TextStyle(fontSize: 16);
  final List<String> _pageTexts = [];
  final _pageKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paginate(widget.content);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      key: _pageKey,
      itemCount: _pageTexts.length,
      itemBuilder: (context, index) {
        return Text(
          _pageTexts[index],
          style: _textStyle,
        );
      },
    );
  }

  void _paginate(String content) {
    final pageSize =
        (_pageKey.currentContext?.findRenderObject() as RenderBox).size;
    print(pageSize.height);
    print(context.height);
    _pageTexts.clear();

    content = content.replaceAll("\n\n", "\n");

    final textSpan = TextSpan(
      text: content,
      style: _textStyle,
    );
    final textPainter =
        TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    textPainter.layout(
      minWidth: 0,
      maxWidth: pageSize.width,
    );

    // https://medium.com/swlh/flutter-line-metrics-fd98ab180a64
    List<ui.LineMetrics> lines = textPainter.computeLineMetrics();
    double currentPageBottom = 750;
    int currentPageStartIndex = 0;
    int currentPageEndIndex = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      final left = line.left;
      final top = line.baseline - line.ascent;
      final bottom = line.baseline + line.descent;

      // Current line overflow page
      if (currentPageBottom < bottom) {
        // https://stackoverflow.com/questions/56943994/how-to-get-the-raw-text-from-a-flutter-textbox/56943995#56943995
        currentPageEndIndex =
            textPainter.getPositionForOffset(Offset(left, top)).offset;
        final pageText =
            content.substring(currentPageStartIndex, currentPageEndIndex);
        _pageTexts.add(pageText);

        currentPageStartIndex = currentPageEndIndex;
        currentPageBottom = top + 750;
      }
    }

    final lastPageText = content.substring(currentPageStartIndex);
    _pageTexts.add(lastPageText);
    setState(() {});
  }
}
