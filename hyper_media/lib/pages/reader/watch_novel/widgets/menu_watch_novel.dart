part of "../view/watch_novel_view.dart";

class MenuWatchNovelController {
  _MenuWatchNovelState? _state;

  void _bind(_MenuWatchNovelState state) {
    _state = state;
  }

  void changeMenu(MenuNovelType menu) {
    _state?._changeMenuType(menu);
  }

  Future<void> hide() async {
    await _state?._hide();
  }

  void onTapScreen() {
    _state?._onTapScreen();
  }

  void onTouchScreen() {
    _state?._onTouchScreen();
  }
}

enum MenuNovelType { base, autoScroll, audio }

class MenuWatchNovel extends StatefulWidget {
  const MenuWatchNovel(
      {super.key, required this.controller, required this.watchNovelCubit});
  final MenuWatchNovelController controller;
  final WatchNovelCubit watchNovelCubit;

  @override
  State<MenuWatchNovel> createState() => _MenuWatchNovelState();
}

class _MenuWatchNovelState extends State<MenuWatchNovel>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _currentOnTouchScreen = false;

  MenuNovelType _menuNovelType = MenuNovelType.base;
  late WatchNovelCubit _watchNovelCubit;

  @override
  void initState() {
    _watchNovelCubit = widget.watchNovelCubit;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    widget.controller._bind(this);
    super.initState();
  }

  void _onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    _onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  bool get _isShowMenu =>
      _animationController.status == AnimationStatus.completed;

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void _onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    _onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  Future<void> _onChangeIsShowMenu(bool value) async {
    if (value) {
      await _animationController.forward();
    } else {
      await _animationController.reverse();
    }
  }

  Future<void> _hide() async {
    if (!_isShowMenu) return;
    await _onChangeIsShowMenu(false);
  }

  void _changeMenuType(MenuNovelType type) async {
    if (_isShowMenu) {
      await _onChangeIsShowMenu(false);
    }
    setState(() {
      _menuNovelType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WatchNovelCubit, WatchNovelState, WatchNovelSetting>(
        selector: (state) {
      return state.settings;
    }, builder: (context, settings) {
      return switch (_menuNovelType) {
        MenuNovelType.base => Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, -1), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutQuad)),
                    child: child,
                  ),
                  child: _TopBaseMenu(
                    watchNovelCubit: _watchNovelCubit,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 1), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutQuad)),
                    child: child,
                  ),
                  child: _BottomBaseMenu(watchNovelCubit: _watchNovelCubit),
                ),
              )
            ],
          ),
        MenuNovelType.autoScroll => Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutQuad)),
                child: child,
              ),
              child: _AutoScrollMenu(watchNovelCubit: _watchNovelCubit),
            ),
          ),
        _ => const SizedBox(),
      };
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _TopBaseMenu extends StatelessWidget {
  const _TopBaseMenu({required this.watchNovelCubit});
  final WatchNovelCubit watchNovelCubit;

  @override
  Widget build(BuildContext context) {
    final book = watchNovelCubit.getBook;

    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => Container(
        decoration: BoxDecoration(
            color: colorScheme.background.withOpacity(0.95),
            border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
        child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    Expanded(
                        child: Text(
                      book.name,
                      style: textTheme.labelMedium,
                    )),
                    // if (!readerCubit.isHideAction)
                    IconButton(
                        onPressed: () {
                          watchNovelCubit.onEnableAutoScroll();
                        },
                        icon: const Icon(
                          Icons.swipe_down_alt_rounded,
                          size: 28,
                        )),
                    // BlocSelector<ReaderCubit, ReaderState, bool>(
                    //   selector: (state) => state.book.id != null,
                    //   builder: (context, bookmark) {
                    //     if (bookmark) {
                    //       return IconButton(
                    //           onPressed: () {
                    //             // ReaderCubit.onDeleteToBookmark();
                    //           },
                    //           icon: Icon(
                    //             Icons.bookmark_added_rounded,
                    //             color: colorScheme.primary,
                    //           ));
                    //     }
                    //     return IconButton(
                    //         onPressed: () {
                    //           // ReaderCubit.onAddToBookmark();
                    //         },
                    //         icon: const Icon(Icons.bookmark_add_rounded));
                    //   },
                    // ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class _BottomBaseMenu extends StatelessWidget {
  const _BottomBaseMenu({required this.watchNovelCubit});
  final WatchNovelCubit watchNovelCubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: colorScheme.background.withOpacity(0.95),
          border: Border(
              top:
                  BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.8))),
      child: BlocBuilder<WatchNovelCubit, WatchNovelState>(
        buildWhen: (previous, current) =>
            previous.watchChapter != current.watchChapter,
        builder: (context, state) {
          final chapter = state.watchChapter;
          double valueSlider = chapter.index.toDouble();

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 16,
              ),
              StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Row(
                      children: [
                        Gaps.wGap16,
                        Expanded(
                            child: Text(
                          state.watchChapter.name,
                          textAlign: TextAlign.center,
                        )),
                        Gaps.wGap16,
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        IconButton(
                            onPressed: () {
                              watchNovelCubit.onCloseMenu();

                              watchNovelCubit.onPrevious();
                            },
                            icon: const Icon(Icons.skip_previous)),
                        Expanded(
                          child: Slider(
                            min: 0,
                            value: valueSlider,
                            label: "3",
                            max: watchNovelCubit.getBook.totalChapters
                                .toDouble(),
                            onChanged: (value) {
                              setState(() {
                                valueSlider = value;
                              });
                              // ReaderCubit.onChangeChaptersSlider(
                              //     valueSlider.toInt());
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              watchNovelCubit.onCloseMenu();
                              watchNovelCubit.onNext();
                            },
                            icon: const Icon(Icons.skip_next)),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          watchNovelCubit.onCloseMenu();
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(Icons.format_list_bulleted)),
                    IconButton(
                        onPressed: () {
                          var isPortrait = MediaQuery.of(context).orientation ==
                              Orientation.portrait;
                          if (isPortrait) {
                            SystemUtils.setRotationDevice();
                          } else {
                            SystemUtils.setPreferredOrientations();
                          }
                          watchNovelCubit.onCloseMenu();
                        },
                        icon: const Icon(Icons.screen_rotation_rounded)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.headphones)),
                    IconButton(
                      onPressed: () async {
                        watchNovelCubit.onCloseMenu();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => SettingsWatchNovel(
                              watchNovelCubit: watchNovelCubit),
                        );
                      },
                      icon: const Icon(Icons.settings),
                    )
                  ].expandedEqually().toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AutoScrollMenu extends StatelessWidget {
  const _AutoScrollMenu({required this.watchNovelCubit});
  final WatchNovelCubit watchNovelCubit;

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
                  valueListenable: watchNovelCubit.autoScrollValue.timeAuto,
                  builder: (context, value, child) {
                    return Slider(
                      min: 0.5,
                      max: 40,
                      value: value,
                      onChanged: (value) {
                        watchNovelCubit.onChangeTimeAutoScroll(value);
                      },
                    );
                  }),
            ),
          )),
          Gaps.hGap12,
          ValueListenableBuilder(
            valueListenable: watchNovelCubit.autoScrollValue,
            builder: (context, value, child) {
              return IconButtonComic(
                  colorBackground: colorBackground,
                  onTap: () {
                    watchNovelCubit.onActionAutoScroll();
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
                watchNovelCubit.onCloseAutoScroll();
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
