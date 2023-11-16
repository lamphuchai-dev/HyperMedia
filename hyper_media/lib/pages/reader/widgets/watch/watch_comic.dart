// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/chapter.dart';
import 'package:hyper_media/pages/reader/controller/watch_progress.dart';
import 'package:hyper_media/pages/reader/cubit/reader_cubit.dart';
import 'package:hyper_media/widgets/animated_fade.dart';
import 'package:hyper_media/widgets/widget.dart';

class ReaderComic extends StatefulWidget {
  const ReaderComic({
    Key? key,
    required this.chapter,
    required this.readerCubit,
  }) : super(key: key);
  final Chapter chapter;
  final ReaderCubit readerCubit;

  @override
  State<ReaderComic> createState() => _ReaderComicState();
}

class _ReaderComicState extends State<ReaderComic> {
  late ReaderCubit _readerCubit;
  late ScrollController _scrollController;
  late ValueNotifier<WatchComicProgress> _watchProgress;
  double? _heightScreen;
  Timer? _showProgressTimer;
  late ProgressWatchValue _progressWatchValue;
  @override
  void initState() {
    _readerCubit = widget.readerCubit;
    _scrollController = ScrollController();
    _progressWatchValue = ProgressWatchValue();

    _watchProgress =
        ValueNotifier(const WatchComicProgress(show: false, progress: ""));
    _scrollController.addListener(() {
      if (_showProgressTimer != null) {
        _showProgressTimer!.cancel();
      }
      _showProgressTimer = Timer(const Duration(seconds: 1), () {
        _watchProgress.value = _watchProgress.value.copyWith(show: false);
      });
      _handlerProgress();
      _progressWatchValue.addListenerProgress(
          maxScrollExtent: _scrollController.position.maxScrollExtent,
          offsetCurrent: _scrollController.offset,
          height: _heightScreen ??= context.height);
    });
    _readerCubit.setScrollController(_scrollController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_readerCubit.state.menuType == MenuType.autoScroll) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          _readerCubit.onUnpauseAutoScroll();
        });
      }
    });

    super.initState();
  }

  void _handlerProgress() {
    // final maxScrollExtent = _scrollController.position.maxScrollExtent;
    // final currentOffset = _scrollController.offset;
    // _heightScreen ??= context.height;
    // final totalPages = maxScrollExtent ~/ _heightScreen! == 0
    //     ? 1
    //     : maxScrollExtent ~/ _heightScreen!;
    // final currentPage = currentOffset ~/ _heightScreen! == 0
    //     ? 1
    //     : currentOffset ~/ _heightScreen!;

    // _watchProgress.value = _watchProgress.value
    //     .copyWith(progress: "$currentPage/$totalPages", show: true);
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final headers = {"Referer": widget.chapter.host};
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: BlocBuilder<ReaderCubit, ReaderState>(
              buildWhen: (previous, current) =>
                  previous.menuType != current.menuType,
              builder: (context, state) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: _readerCubit.getPhysicsScroll,
                  child: Column(
                      children: widget.chapter.contentComic!.map((src) {
                    if (src.startsWith("http")) {
                      return CacheNetWorkImage(
                        src,
                        fit: BoxFit.fitWidth,
                        width: width,
                        headers: headers,
                        placeholder: Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: const SpinKitPulse(
                              color: Colors.grey,
                            )),
                      );
                    } else if (!src.startsWith("http")) {
                      return ImageFileWidget(
                        pathFile: src,
                      );
                    }
                    return const SizedBox();
                  }).toList()),
                );
              }),
        ),
        Positioned(
            right: 16,
            top: 0,
            child: SafeArea(
              child: ValueListenableBuilder(
                  key: UniqueKey(),
                  valueListenable: _progressWatchValue,
                  builder: (context, value, child) {
                    if (value == null) return SizedBox();
                    return AnimatedFade(
                      // status: value.show,
                      status: true,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          value!.getPercent,
                          style: textTheme.labelSmall?.copyWith(fontSize: 11),
                        ),
                      ),
                    );
                  }),
            ))
      ],
    );
  }

  @override
  void dispose() {
    _watchProgress.dispose();
    _showProgressTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}

class WatchComicProgress {
  final bool show;
  final String progress;
  const WatchComicProgress({
    required this.show,
    required this.progress,
  });

  WatchComicProgress copyWith({
    bool? show,
    String? progress,
  }) {
    return WatchComicProgress(
      show: show ?? this.show,
      progress: progress ?? this.progress,
    );
  }
}
