import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/reader_cubit.dart';
import '../widgets/page_chapter.dart';
import '../widgets/widgets.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage>
    with SingleTickerProviderStateMixin {
  late ReaderCubit _readerCubit;
  late AnimationController _animationController;

  ColorScheme? _colorScheme;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _readerCubit = context.read<ReaderCubit>();
    _readerCubit.setMenuAnimationController(_animationController);
    _readerCubit.onInitFToat(context);
    // SystemUtils.setEnabledSystemUIModeReadBookPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _colorScheme = context.colorScheme;
    return Scaffold(
      drawer: const BookDrawer(),
      body: BlocBuilder<ReaderCubit, ReaderState>(
        buildWhen: (previous, current) =>
            previous.extensionStatus != current.extensionStatus,
        builder: (context, state) {
          return switch (state.extensionStatus) {
            ExtensionStatus.init => const SizedBox(),
            ExtensionStatus.unknown => Scaffold(
                appBar: AppBar(),
                body: const Center(
                  child: Text("Chưa cài extension"),
                ),
              ),
            ExtensionStatus.ready => Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                      child: GestureDetector(
                          onTap: _readerCubit.onTapScreen,
                          onPanDown: (_) => _readerCubit.onTouchScreen(),
                          child: TestPageView(
                            initialPage: state.readChapter!.chapter.index,
                          )
                          // child: _ReadChapter(
                          //   readerCubit: _readerCubit,
                          // )

                          )),
                  // if (state.book.type != BookType.video)
                  Positioned.fill(
                    child: BlocSelector<ReaderCubit, ReaderState, MenuType>(
                      selector: (state) {
                        return state.readerType.getMenuType;
                      },
                      builder: (context, menuType) {
                        return MenuSliderAnimation(
                            menu: menuType,
                            bottomMenu:
                                BottomBaseMenuWidget(readerCubit: _readerCubit),
                            topMenu:
                                TopBaseMenuWidget(readerCubit: _readerCubit),
                            autoScrollMenu:
                                AutoScrollMenu(readerCubit: _readerCubit),
                            mediaMenu: const SizedBox(),
                            controller: _animationController);
                      },
                    ),
                  )
                ],
              ),
            _ => const SizedBox()
          };
        },
      ),
    );
  }
}

class _ReadChapter extends StatelessWidget {
  const _ReadChapter({required this.readerCubit});
  final ReaderCubit readerCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReaderCubit, ReaderState>(
      listenWhen: (previous, current) =>
          previous.readChapter != current.readChapter,
      listener: (context, state) {
        if (state.readChapter?.status == StatusType.init) {
          readerCubit.getContentsChapter();
        }
      },
      buildWhen: (previous, current) =>
          previous.readChapter != current.readChapter,
      builder: (context, state) {
        if (state.readChapter == null) {
          return const Center(
            child: Text(
              "ERROR",
              style: TextStyle(fontSize: 27, color: Colors.red),
            ),
          );
        }
        return switch (state.readChapter!.status) {
          StatusType.loading => const LoadingWidget(),
          StatusType.loaded => TestPageView(
              initialPage: state.readChapter!.chapter.index,
            ),
          // StatusType.loaded => EasyRefresh(
          //     scrollController: readerCubit.scrollController,
          //     header: ClassicHeader(
          //         dragText: 'Kéo để quay lại chương trước',
          //         armedText: 'Thả để qua chương trước',
          //         readyText: 'Đang tải nội dung',
          //         processedText: "Tải thành công",
          //         processingText: "Đang tải nội dung",
          //         processedDuration: const Duration(milliseconds: 500),
          //         triggerWhenRelease: true,
          //         triggerWhenReach: state.readChapter!.previousChapter == null,
          //         hapticFeedback: true,
          //         messageText: state.readChapter!.previousChapter == null
          //             ? "Không có chương trước đó"
          //             : state.readChapter!.previousChapter!.name),
          //     footer: ClassicFooter(
          //         dragText: 'Kéo để qua chương mới',
          //         armedText: 'Thả để qua chương mới',
          //         readyText: 'Đang tải nội dung',
          //         processedText: "Tải thành công",
          //         processingText: "Đang tải nội dung",
          //         infiniteOffset: null,
          //         safeArea: false,
          //         processedDuration: Duration.zero,
          //         triggerWhenRelease: true,
          //         hapticFeedback: true,
          //         messageText: state.readChapter!.nextChapter == null
          //             ? "Bạn đã xem chương mới nhất"
          //             : state.readChapter!.nextChapter!.name),
          //     onRefresh: readerCubit.onPreviousChapter,
          //     onLoad: readerCubit.onNextChapter,
          //     child: switch (readerCubit.getExtensionType) {
          //       ExtensionType.comic => ReaderChapter(
          //           chapter: state.readChapter!.chapter,
          //         ),
          //       ExtensionType.movie => ReaderChapter(
          //           chapter: state.readChapter!.chapter,
          //         ),
          //       ExtensionType.novel => ReaderChapter(
          //           chapter: state.readChapter!.chapter,
          //         ),
          //     },
          //   ),
          _ => const LoadingWidget()
        };
      },
    );
  }
}

class TestPageView extends StatefulWidget {
  const TestPageView({super.key, required this.initialPage});
  final int initialPage;

  @override
  State<TestPageView> createState() => _TestPageViewState();
}

class _TestPageViewState extends State<TestPageView> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController =
        PageController(initialPage: widget.initialPage, keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReaderCubit, ReaderState>(
      buildWhen: (previous, current) => previous.chapters != current.chapters,
      builder: (context, state) {
        return EasyRefresh(
          onRefresh: () async {
            await _pageController.previousPage(
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear);
            return true;
          },
          onLoad: () async {
            await _pageController.nextPage(
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear);
            return true;
          },
          header: const ClassicHeader(
            dragText: 'Pull to refresh',
            armedText: 'Release ready',
            readyText: 'Refreshing...',
            processingText: 'Refreshing...',
            processedText: 'Succeeded',
            noMoreText: 'No more',
            failedText: 'Failed',
            messageText: 'Last updated at %T',
            processedDuration: Duration.zero,
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          footer: const ClassicFooter(
            dragText: 'Pull to load',
            armedText: 'Release ready',
            readyText: 'Loading...',
            processingText: 'Loading...',
            processedText: 'Succeeded',
            noMoreText: 'No more',
            failedText: 'Failed',
            processedDuration: Duration.zero,
            messageText: 'Last updated at %T',
            infiniteOffset: null,
          ),
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: state.chapters.length,
            itemBuilder: (context, index) {
              return ReaderPageChapter(
                index: index,
              );
            },
            onPageChanged: (value) {
              print(value);
            },
          ),
        );
      },
    );
  }
}
