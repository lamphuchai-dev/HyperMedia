// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/pages/reader/widgets/reader_chapter.dart';

import '../cubit/reader_cubit.dart';
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
    return Scaffold(
      drawer: const BookDrawer(),
      body: BlocConsumer<ReaderCubit, ReaderState>(
        listenWhen: (previous, current) =>
            previous.extensionStatus != current.extensionStatus,
        listener: (context, state) {
          if (state.extensionStatus == ExtensionStatus.ready) {
            _readerCubit.setHeight(context.height);
          }
        },
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
                          child: BlocBuilder<ReaderCubit, ReaderState>(
                            buildWhen: (previous, current) =>
                                previous.watchChapter != current.watchChapter,
                            builder: (context, state) {
                              // if (_readerCubit.getExtensionType ==
                              //     ExtensionType.movie) {
                              //   return ReaderPageChapter(
                              //     index: state.currentReader!.index,
                              //   );
                              // }
                              return EasyRefresh(
                                controller: _readerCubit.easyRefreshController,
                                onRefresh: () async {
                                  _readerCubit.onPreviousChapter(menu: false);
                                },
                                onLoad: () async {
                                  _readerCubit.onNextChapter(menu: false);
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
                                  // triggerWhenRelease: true,
                                  // hapticFeedback: true,
                                ),
                                footer: const ClassicFooter(
                                  dragText: 'Kéo để qua chương mới',
                                  armedText: 'Thả để qua chương mới',
                                  readyText: 'Đang tải nội dung',
                                  processedText: "Tải thành công",
                                  processingText: "Đang tải nội dung",
                                  infiniteOffset: null,
                                  safeArea: false,
                                  processedDuration: Duration.zero,
                                  // triggerWhenRelease: true,
                                  hapticFeedback: true,
                                ),
                                child: WatchChapterWidget(
                                    readerCubit: _readerCubit),
                                // child: PageView.builder(
                                //   scrollDirection: Axis.vertical,
                                //   controller: _readerCubit.pageController,
                                //   itemCount: _readerCubit.getChapters.length,
                                //   physics:
                                //       const NeverScrollableScrollPhysics(),
                                //   itemBuilder: (context, index) {
                                //     return ReaderPageChapter(
                                //       index: index,
                                //     );
                                //   },
                                // ),
                              );
                            },
                          ))),
                  // if (state.book.type != BookType.video)
                  Positioned.fill(
                    child: BlocSelector<ReaderCubit, ReaderState, MenuType>(
                      selector: (state) {
                        return state.menuType;
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
