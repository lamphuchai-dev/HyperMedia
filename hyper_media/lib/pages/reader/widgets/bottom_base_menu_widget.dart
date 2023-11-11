import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/utils/system_utils.dart';

import '../cubit/reader_cubit.dart';

class BottomBaseMenuWidget extends StatelessWidget {
  const BottomBaseMenuWidget({super.key, required this.readerCubit});
  final ReaderCubit readerCubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: colorScheme.background,
          border: Border(top: BorderSide(color: colorScheme.background))),
      child: BlocBuilder<ReaderCubit, ReaderState>(
        buildWhen: (previous, current) =>
            previous.readChapter != current.readChapter,
        builder: (context, state) {
          final chapter = state.readChapter!.chapter;
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
                        // Text("3/33"),
                        Expanded(
                            child: Text(
                          state.chapters[valueSlider.toInt()].name,
                          textAlign: TextAlign.center,
                        )),
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
                              readerCubit.onPreviousChapter();
                            },
                            icon: const Icon(Icons.skip_previous)),
                        Expanded(
                          child: Slider(
                            min: 0,
                            value: valueSlider,
                            label: "3",
                            max: (state.chapters.length - 1).toDouble(),
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
                              readerCubit.onNextChapter();
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
                          readerCubit.onHideCurrentMenu();
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
                          readerCubit.onHideCurrentMenu();
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
