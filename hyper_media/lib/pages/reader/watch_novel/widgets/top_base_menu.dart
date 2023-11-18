import 'package:flutter/material.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/pages/reader/watch_novel/cubit/watch_novel_cubit.dart';

class TopBaseMenu extends StatelessWidget {
  const TopBaseMenu({super.key, required this.watchNovelCubit});
  final WatchNovelCubit watchNovelCubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final book = watchNovelCubit.getBook;
    return Container(
      // height: 110,
      decoration: BoxDecoration(
          color: colorScheme.background,
          border: Border(bottom: BorderSide(color: colorScheme.surface))),
      child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Expanded(child: Text(book.name)),
                  // if (!readerCubit.isHideAction)
                  IconButton(
                      onPressed: () {
                        watchNovelCubit.onEnableAutoScroll();
                      },
                      icon: const Icon(
                        Icons.swipe_down_alt_rounded,
                        size: 28,
                      )),
                  // BlocSelector<ReaderCubit, ReaderState, bool>(
                  //   selector: (state) => state.book.id != null,
                  //   builder: (context, bookmark) {
                  //     if (bookmark) {
                  //       return IconButton(
                  //           onPressed: () {
                  //             // ReaderCubit.onDeleteToBookmark();
                  //           },
                  //           icon: Icon(
                  //             Icons.bookmark_added_rounded,
                  //             color: colorScheme.primary,
                  //           ));
                  //     }
                  //     return IconButton(
                  //         onPressed: () {
                  //           // ReaderCubit.onAddToBookmark();
                  //         },
                  //         icon: const Icon(Icons.bookmark_add_rounded));
                  //   },
                  // ),
                ],
              )
            ],
          )),
    );
  }
}
