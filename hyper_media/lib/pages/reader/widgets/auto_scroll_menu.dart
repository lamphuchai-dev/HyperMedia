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
            // child: RotatedBox(
            //     quarterTurns: 1,
            //     child: ValueListenableBuilder(
            //       valueListenable: ReaderCubit.timeAutoScroll,
            //       builder: (context, value, child) => Slider(
            //         min: 0.2,
            //         max: 30,
            //         onChanged: (value) {
            //           ReaderCubit.onChangeTimerAutoScroll(value);
            //         },
            //         value: value,
            //       ),
            //     )),
          )),
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<ReaderCubit, ReaderState>(
            buildWhen: (previous, current) {
              return true;
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  // if (state.controlStatus == ControlStatus.pause) {
                  //   ReaderCubit.onUnpauseAutoScroll();
                  // } else {
                  //   ReaderCubit.onPauseAutoScroll();
                  // }
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  // child: Icon(state.controlStatus == ControlStatus.pause
                  //     ? Icons.play_arrow
                  //     : Icons.pause),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              // ReaderCubit.onCloseAutoScroll();
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
