part of '../view/watch_comic_view.dart';

class MenuController {
  _MenuWatchComicState? _state;

  void _bind(_MenuWatchComicState state) {
    _state = state;
  }

  void onTapScreen() {
    _state?._onTapScreen();
  }

  void onTouchScreen() {
    _state?._onTouchScreen();
  }

  void hide() {
    _state?._hide();
  }

  void changeMenuType(MenuType type) {
    _state?._changeMenuType(type);
  }
}

enum MenuType { base, autoScroll }

class MenuWatchComic extends StatefulWidget {
  const MenuWatchComic(
      {super.key, required this.controller, required this.watchComicCubit});
  final MenuController controller;
  final WatchComicCubit watchComicCubit;

  @override
  State<MenuWatchComic> createState() => _MenuWatchComicState();
}

class _MenuWatchComicState extends State<MenuWatchComic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _currentOnTouchScreen = false;
  MenuType _menuType = MenuType.base;
  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));
    _animationFade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    widget.controller._bind(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    _onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  bool get _isShowMenu => _controller.status == AnimationStatus.completed;

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void _onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    _onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  Future<void> _onChangeIsShowMenu(bool value) async {
    if (value) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }
  }

  void _hide() {
    if (!_isShowMenu) return;
    _onChangeIsShowMenu(false);
  }

  void _changeMenuType(MenuType type) async {
    if (_isShowMenu) {
      await _onChangeIsShowMenu(false);
    }
    setState(() {
      _menuType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorBackground = Colors.black87.withOpacity(0.7);
    final textTheme = context.appTextTheme;
    return switch (_menuType) {
      MenuType.base => Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _animationFade,
                builder: (context, child) => FadeTransition(
                  opacity: _animationFade,
                  child: child,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.black54,
                        Colors.black26,
                        Colors.black12,
                        Colors.transparent,
                      ],
                          stops: [
                        0.2,
                        0.8,
                        0.92,
                        5,
                      ])),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.horizontalPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButtonComic(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    colorBackground: colorBackground,
                                    icon: const Icon(
                                      Icons.close,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              IconButtonComic(
                                onTap: () {
                                  widget.watchComicCubit.onRefresh();
                                },
                                colorBackground: colorBackground,
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.wGap12,
                              IconButtonComic(
                                onTap:
                                    widget.watchComicCubit.onEnableAutoScroll,
                                colorBackground: colorBackground,
                                icon: const Icon(
                                  Icons.swipe_down_alt_rounded,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.wGap12,
                              IconButtonComic(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (_) => SettingsWatchComic(
                                            watchComicCubit:
                                                widget.watchComicCubit,
                                          ));
                                },
                                colorBackground: colorBackground,
                                icon: const Icon(
                                  Icons.more_vert,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Gaps.hGap12,
                          BlocBuilder<WatchComicCubit, WatchComicState>(
                            buildWhen: (previous, current) =>
                                previous.watchChapter != current.watchChapter,
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    elevation: 0,
                                    enableDrag: false,
                                    clipBehavior: Clip.hardEdge,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => ChaptersBottomSheet(
                                      readerCubit: context.read<ReaderCubit>(),
                                      currentIndex: state.watchChapter.index,
                                      onTapChapter: widget
                                          .watchComicCubit.onChangeChapter,
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.watchComicCubit.bookName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          state.watchChapter.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        )),
                                        const Icon(
                                          Icons.expand_more_rounded,
                                          color: Colors.white,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Gaps.hGap12
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => SlideTransition(
                  position:
                      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: _controller, curve: Curves.easeOutQuad)),
                  child: child,
                ),
                child: Container(
                  margin:
                      EdgeInsets.only(right: 24, bottom: context.height * 0.1),
                  width: 30,
                  height: context.height * 0.7,
                  child: Column(
                    children: [
                      IconButtonComic(
                          colorBackground: colorBackground,
                          onTap: widget.watchComicCubit.onPrevious,
                          icon: const Icon(
                            Icons.north_rounded,
                            size: 16,
                            color: Colors.white,
                          )),
                      Gaps.hGap16,
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: colorBackground,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                                bottom: Radius.circular(20))),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: ValueListenableBuilder(
                            valueListenable:
                                widget.watchComicCubit.progressWatchValue,
                            builder: (context, value, child) {
                              return Slider(
                                min: 0,
                                max: 100,
                                value: value?.percent.clamp(0, 100) ?? 0,
                                onChanged: (value) {
                                  widget.watchComicCubit
                                      .onChangeSliderScroll(value);
                                },
                              );
                            },
                          ),
                        ),
                      )),
                      Gaps.hGap16,
                      IconButtonComic(
                          colorBackground: colorBackground,
                          onTap: widget.watchComicCubit.onNext,
                          icon: const Icon(
                            Icons.south_rounded,
                            size: 16,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      MenuType.autoScroll => Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.easeOutQuad)),
              child: child,
            ),
            child: AutoScrollMenu(watchComicCubit: widget.watchComicCubit),
          ),
        ),
    };
  }
}

class AutoScrollMenu extends StatelessWidget {
  const AutoScrollMenu({super.key, required this.watchComicCubit});
  final WatchComicCubit watchComicCubit;

  @override
  Widget build(BuildContext context) {
    final colorBackground = Colors.black87.withOpacity(0.7);
    return Container(
      margin: const EdgeInsets.only(right: 24),
      width: 30,
      height: context.height * 0.7,
      child: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20), bottom: Radius.circular(20))),
            child: RotatedBox(
              quarterTurns: 1,
              child: ValueListenableBuilder(
                  valueListenable: watchComicCubit.timerAutoScrollStatus,
                  builder: (context, value, child) {
                    return Slider(
                      min: 0.0,
                      max: 40,
                      value: value,
                      onChanged: (value) {
                        watchComicCubit.onChangeTimeAutoScroll(value);
                      },
                    );
                  }),
            ),
          )),
          Gaps.hGap12,
          ValueListenableBuilder(
            valueListenable: watchComicCubit.autoScrollStatus,
            builder: (context, value, child) {
              return IconButtonComic(
                  colorBackground: colorBackground,
                  onTap: () {
                    watchComicCubit.onActionAutoScroll();
                  },
                  icon: Icon(
                    value == AutoScrollStatus.active
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                  ));
            },
          ),
          Gaps.hGap12,
          IconButtonComic(
              colorBackground: colorBackground,
              onTap: () {
                watchComicCubit.onCloseAutoScroll();
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 20,
              )),
        ],
      ),
    );
  }
}
