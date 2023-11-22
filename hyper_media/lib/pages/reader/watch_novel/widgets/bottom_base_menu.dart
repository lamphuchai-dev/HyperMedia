import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/utils/system_utils.dart';

import '../cubit/watch_novel_cubit.dart';

class BottomBaseMenu extends StatelessWidget {
  const BottomBaseMenu({super.key, required this.watchNovelCubit});
  final WatchNovelCubit watchNovelCubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: colorScheme.background,
          border:
              Border(top: BorderSide(color: colorScheme.surface, width: 2))),
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
                              watchNovelCubit.onHideCurrentMenu();

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
                              watchNovelCubit.onHideCurrentMenu();

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
                          watchNovelCubit.onHideCurrentMenu();
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
                          watchNovelCubit.onHideCurrentMenu();
                        },
                        icon: const Icon(Icons.screen_rotation_rounded)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.headphones)),
                    IconButton(
                      onPressed: () async {},
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
