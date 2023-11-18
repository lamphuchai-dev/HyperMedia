// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hyper_media/app/constants/dimens.dart';
import 'package:hyper_media/app/constants/gaps.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/pages/reader/reader/cubit/reader_cubit.dart';
import 'package:hyper_media/pages/reader/watch_comic/cubit/watch_comic_cubit.dart';
import 'package:hyper_media/pages/reader/watch_comic/widgets/chapters_bottom_sheet.dart';
import 'package:hyper_media/widgets/widget.dart';

class BaseMenuComic extends StatelessWidget {
  const BaseMenuComic({super.key, required this.watchComicCubit});

  final WatchComicCubit watchComicCubit;
  @override
  Widget build(BuildContext context) {
    final colorBackground = Colors.black87.withOpacity(0.7);
    final textTheme = context.appTextTheme;
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 0,
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
                              watchComicCubit.onRefresh();
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
                            onTap: watchComicCubit.onEnableAutoScroll,
                            colorBackground: colorBackground,
                            icon: const Icon(
                              Icons.swipe_down_alt_rounded,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          Gaps.wGap12,
                          IconButtonComic(
                            onTap: () {},
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
                                  onTapChapter: watchComicCubit.onChangeChapter,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  watchComicCubit.bookName,
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
            )),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 24, bottom: context.height * 0.1),
            width: 30,
            height: context.height * 0.7,
            child: Column(
              children: [
                IconButtonComic(
                    colorBackground: colorBackground,
                    onTap: watchComicCubit.onPrevious,
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
                      valueListenable: watchComicCubit.progressWatchValue,
                      builder: (context, value, child) {
                        return Slider(
                          min: 0,
                          max: 100,
                          value: value?.percent ?? 0,
                          onChanged: (value) {
                            watchComicCubit.onChangeSliderScroll(value);
                          },
                        );
                      },
                    ),
                  ),
                )),
                Gaps.hGap16,
                IconButtonComic(
                    colorBackground: colorBackground,
                    onTap: watchComicCubit.onNext,
                    icon: const Icon(
                      Icons.south_rounded,
                      size: 16,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}
