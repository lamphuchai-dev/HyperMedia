part of 'watch_comic_view.dart';

class WatchComicPage extends StatefulWidget {
  const WatchComicPage({super.key});

  @override
  State<WatchComicPage> createState() => _WatchComicPageState();
}

class _WatchComicPageState extends State<WatchComicPage> {
  late WatchComicCubit _watchComicCubit;

  @override
  void initState() {
    _watchComicCubit = context.read<WatchComicCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchComicCubit.setHeight(context.height);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocSelector<WatchComicCubit, WatchComicState, WatchComicSettings>(
        selector: (state) {
          return state.settings;
        },
        builder: (context, settings) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _watchComicCubit.menuController.onTapScreen,
                  onPanDown: (_) =>
                      _watchComicCubit.menuController.onTouchScreen(),
                  child: BlocConsumer<WatchComicCubit, WatchComicState>(
                    listenWhen: (previous, current) {
                      // Kiểm tra điều kiện để tự động chạy autoScroll khi qua chương mới
                      // Qua chương đã có nội dung
                      if (previous.watchChapter.index !=
                              current.watchChapter.index &&
                          current.status == StatusType.loaded) {
                        return true;
                        // Qua chương chưa có nội dung , loaded xong nội dung
                      } else if (previous.watchChapter.index ==
                              current.watchChapter.index &&
                          previous.status != StatusType.loaded &&
                          current.status == StatusType.loaded) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    listener: (context, state) {
                      _watchComicCubit.onCheckAutoScrollNextChapter();
                    },
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      return switch (state.status) {
                        StatusType.loading => const LoadingWidget(),
                        StatusType.loaded => AutoScrollWidget(
                            key: ValueKey(state.watchChapter.index),
                            controller: _watchComicCubit.autoScrollController,
                            onChangeStatus: (value) {
                              _watchComicCubit.onChangeAutoScrollStatus(value);
                            },
                            builderList: (scrollController, physics) {
                              final listImage = _watchComicCubit
                                  .state.watchChapter.contentComic!
                                  .asMap()
                                  .entries
                                  .map((e) => _buildImage(
                                      e.value, e.key, settings.longPressImage))
                                  .toList();

                              final footer = _watchComicCubit.isLastChapter
                                  ? ThemeBuildWidget(
                                      builder: (context, themeData, textTheme,
                                              colorScheme) =>
                                          Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        child: Column(
                                          children: [
                                            Gaps.hGap16,
                                            Text(
                                              "Bạn đã đọc chương mới nhất",
                                              style: textTheme.bodyMedium,
                                            ),
                                            Gaps.hGap16,
                                            TextButton(
                                                onPressed: () {
                                                  _watchComicCubit
                                                      .onRefreshChapters();
                                                },
                                                child: const Text(
                                                    "Kiểm tra chương")),
                                            Gaps.hGap16,
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _watchComicCubit.onPrevious();
                                              },
                                              icon: const Icon(
                                                  Icons.arrow_back_rounded)),
                                          Expanded(
                                              child: Text(
                                            state.watchChapter.name,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.visible,
                                          )),
                                          IconButton(
                                              onPressed: () {
                                                _watchComicCubit.onNext();
                                              },
                                              icon: const Icon(
                                                  Icons.arrow_forward_rounded))
                                        ],
                                      ),
                                    );
                              return InitStateWidgetBinding(
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    physics: physics,
                                    child: Column(
                                      children: [
                                        ...listImage,
                                        SafeArea(
                                          top: false,
                                          child: footer,
                                        )
                                      ],
                                    ),
                                  ),
                                  onCallback: () {
                                    _watchComicCubit.autoScrollController
                                        .closeAutoScroll();
                                  });
                            },
                            builderPage: (pageController, physics) {
                              return PageView(
                                  controller: pageController,
                                  physics: physics,
                                  scrollDirection: settings.watchType ==
                                          WatchComicType.horizontal
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  children: state.watchChapter.contentComic!
                                      .asMap()
                                      .entries
                                      .map((e) => _buildImage(e.value, e.key,
                                          settings.longPressImage))
                                      .toList());
                            },
                          ),
                        _ => const SizedBox()
                      };
                    },
                  ),
                ),
              ),
              Positioned.fill(
                  child: MenuWatchComic(
                controller: _watchComicCubit.menuController,
                watchComicCubit: _watchComicCubit,
              ))
            ],
          );
        },
      ),
    );
  }

  Widget _buildImage(String data, int index, bool longPress) {
    return ItemImageComic(
      headers: _watchComicCubit.headersChapter,
      url: data,
      index: index,
      onImage: _watchComicCubit.autoScrollController.onChangeMapImage,
      onSaveImage: () {
        _watchComicCubit.onSaveImage(data);
      },
      onCopyImage: () {
        _watchComicCubit.onCopyImage(data);
      },
      longPress: longPress,
    );
  }
}
