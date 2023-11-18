import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/gaps.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/pages/reader/watch_comic/cubit/watch_comic_cubit.dart';
import 'package:hyper_media/widgets/widget.dart';


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
                  valueListenable: watchComicCubit.autoScrollValue.timeAuto,
                  builder: (context, value, child) {
                    return Slider(
                      min: 0.5,
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
            valueListenable: watchComicCubit.autoScrollValue,
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
