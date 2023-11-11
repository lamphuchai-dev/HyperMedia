// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/reader/cubit/reader_cubit.dart';
import 'package:hyper_media/widgets/widget.dart';

class ReaderChapter extends StatefulWidget {
  const ReaderChapter({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ReaderChapter> createState() => _ReaderChapterState();
}

class _ReaderChapterState extends State<ReaderChapter> {
  late final ReaderCubit _readerCubit;
  late ScrollController _scrollController;

  final ValueNotifier<ContentsPage> _contentsPage = ValueNotifier(
      const ContentsPage(
          maxScrollExtent: 0, pages: 0, currentPage: 0, show: false));

  double? _heightScreen;
  Timer? _timerAutoScroll;
  double _maxScrollExtent = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_timerAutoScroll != null) {
        _timerAutoScroll?.cancel();
      }
      _timerAutoScroll = Timer(const Duration(seconds: 1), () {
        _contentsPage.value = _contentsPage.value.copyWith(show: false);
      });

      // if (_readerCubit.state.menuType == MenuType.autoScroll &&
      //     _readerCubit.state.controlStatus != ControlStatus.pause) {
      //   if (_maxScrollExtent != _scrollController.position.maxScrollExtent) {
      //     _handlerAutoScroll();
      //   }
      // }
      _calculateContents();
    });

    _readerCubit = context.read<ReaderCubit>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_ReaderCubit.state.menuType == MenuType.autoScroll) {
    //     Future.delayed(const Duration(seconds: 2)).then((value) {
    //       _handlerAutoScroll();
    //       _ReaderCubit.handlerAutoScroll ??= _handlerAutoScroll;
    //     });
    //   }
    // });

    super.initState();
  }

  void _calculateContents() {
    _maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset;
    _heightScreen ??= context.height;
    final totalPages = _maxScrollExtent ~/ _heightScreen! == 0
        ? 1
        : _maxScrollExtent ~/ _heightScreen!;
    final currentPage = currentOffset ~/ _heightScreen! == 0
        ? 1
        : currentOffset ~/ _heightScreen!;
    _contentsPage.value = ContentsPage(
        maxScrollExtent: _maxScrollExtent,
        pages: totalPages,
        currentPage: currentPage,
        show: true);
  }

  void _handlerAutoScroll() async {
    _maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (_scrollController.offset == _maxScrollExtent) {
      // _ReaderCubit.onNextChapter();
      return;
    }
    // _heightScreen ??= context.height;
    // _maxScrollExtent = _scrollController.position.maxScrollExtent;
    // final heightText = _maxScrollExtent - _scrollController.offset;
    // double timer =
    //     (heightText / _heightScreen!) * _ReaderCubit.timeAutoScroll.value;
    // if (timer <= 0) timer = 0.5;
    // await _scrollController.animateTo(_maxScrollExtent,
    //     duration: Duration(seconds: timer.toInt()), curve: Curves.linear);
    // if (_scrollController.offset == _maxScrollExtent) {
    //   _ReaderCubit.onNextChapter();
    // }
  }

  void _closeAutoScroll() {
    _scrollController.position.hold(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final headers = {"Referer": widget.chapter.host};
    final width = context.width;
    final textTheme = context.appTextTheme;
    return BlocConsumer<ReaderCubit, ReaderState>(
        listenWhen: (previous, current) =>
            previous.readerType != current.readerType,
        listener: (context, state) {
          // switch (state.controlStatus) {
          //   case ControlStatus.init:
          //   case ControlStatus.start:
          //     _handlerAutoScroll();
          //     _ReaderCubit.handlerAutoScroll ??= _handlerAutoScroll;
          //     break;
          //   case ControlStatus.stop:
          //   case ControlStatus.pause:
          //   case ControlStatus.none:
          //     _closeAutoScroll();
          //     _ReaderCubit.handlerAutoScroll = null;
          //     break;
          //   default:
          //     break;
          // }
        },
        // buildWhen: (previous, current) =>
        //     previous.menuType != current.menuType,
        builder: (_, state) => SingleChildScrollView(
              controller: _scrollController,
              // physics: _ReaderCubit.getPhysicsScroll,
              child: Builder(
                builder: (context) {
                  if (widget.chapter.contentNovel != null) {
                    return Text(widget.chapter.contentNovel!);
                  } else if (widget.chapter.contentComic != null) {
                    return Column(
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
                    }).toList());
                  }
                  return const Text("data");
                },
              ),
            ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _ReaderCubit.handlerAutoScroll = null;
    super.dispose();
  }
}

class ImageFileWidget extends StatelessWidget {
  const ImageFileWidget({super.key, required this.pathFile});
  final String pathFile;

  @override
  Widget build(BuildContext context) {
    final file = File(pathFile);
    if (file.existsSync()) {
      return Image.file(File(pathFile));
    }
    return const SizedBox();
  }
}

class ContentsPage {
  final double maxScrollExtent;
  final int pages;
  final int currentPage;
  final bool show;
  const ContentsPage(
      {required this.maxScrollExtent,
      required this.pages,
      required this.currentPage,
      this.show = false});

  ContentsPage copyWith({
    double? maxScrollExtent,
    int? pages,
    int? currentPage,
    bool? show,
  }) {
    return ContentsPage(
        maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
        pages: pages ?? this.pages,
        currentPage: currentPage ?? this.currentPage,
        show: show ?? this.show);
  }

  @override
  String toString() =>
      'ContentsPage(maxScrollExtent: $maxScrollExtent, pages: $pages, currentPage: $currentPage)';
}
