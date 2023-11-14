// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';

import 'package:hyper_media/pages/reader/cubit/reader_cubit.dart';
import 'package:hyper_media/widgets/widget.dart';

import 'watch/watch_comic.dart';
import 'watch/watch_movie.dart';
import 'watch/watch_novel.dart';

class WatchChapterWidget extends StatelessWidget {
  const WatchChapterWidget({super.key, required this.readerCubit});
  final ReaderCubit readerCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReaderCubit, ReaderState>(
      listenWhen: (previous, current) =>
          previous.watchChapter!.status != current.watchChapter!.status,
      listener: (context, state) {
        if (state.watchChapter == null) return;
        switch (state.watchChapter!.status) {
          case StatusType.init:
            readerCubit.onInitWatchChapter();
            break;
          default:
            break;
        }
      },
      buildWhen: (previous, current) =>
          previous.watchChapter != current.watchChapter,
      builder: (context, state) {
        return switch (state.watchChapter!.status) {
          StatusType.loading => const LoadingWidget(),
          StatusType.loaded => switch (readerCubit.getExtensionType) {
              ExtensionType.comic => ReaderComic(
                  chapter: state.watchChapter!.chapter,
                  readerCubit: readerCubit,
                ),
              ExtensionType.novel => WatchNovel(
                  chapter: state.watchChapter!.chapter,
                ),
              ExtensionType.movie => WatchMovie(
                  chapter: state.watchChapter!.chapter,
                ),
            },
          _ => const SizedBox()
        };
      },
    );
  }
}
