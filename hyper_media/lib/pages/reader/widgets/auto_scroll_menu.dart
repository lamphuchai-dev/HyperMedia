import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/extensions/index.dart';

import '../cubit/reader_cubit.dart';

class AutoScrollMenu extends StatelessWidget {
  const AutoScrollMenu({super.key, required this.readerCubit});
  final ReaderCubit readerCubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 24, left: 16),
      height: context.height * 0.6,
      width: 30,
      child: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20), bottom: Radius.circular(20))),
            child: RotatedBox(
                quarterTurns: 1,
                child: ValueListenableBuilder(
                  valueListenable: readerCubit.getAutoScrollController.timeAuto,
                  builder: (context, value, child) => Slider(
                    min: readerCubit.getAutoScrollController.minTime,
                    max: readerCubit.getAutoScrollController.maxTime,
                    onChanged: (value) {
                      readerCubit.getAutoScrollController
                          .onChangeTimerAuto(value);
                    },
                    value: value,
                  ),
                )),
          )),
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<ReaderCubit, ReaderState>(
            buildWhen: (previous, current) {
              return previous.controlStatus != current.controlStatus;
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  if (state.controlStatus == ControlStatus.pause) {
                    readerCubit.onUnpauseAutoScroll();
                  } else {
                    readerCubit.onPauseAutoScroll();
                  }
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: Icon(state.controlStatus == ControlStatus.pause
                      ? Icons.play_arrow
                      : Icons.pause),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              readerCubit.onCloseAutoScroll();
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(4)),
              alignment: Alignment.center,
              child: const Icon(
                Icons.circle,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
