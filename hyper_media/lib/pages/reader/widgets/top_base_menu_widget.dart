import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/extensions/index.dart';

import '../cubit/reader_cubit.dart';

class TopBaseMenuWidget extends StatelessWidget {
  const TopBaseMenuWidget({super.key, required this.readerCubit});
  final ReaderCubit readerCubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final book = readerCubit.book;
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
                        // ReaderCubit.onEnableAutoScroll();
                      },
                      icon: const Icon(
                        Icons.swipe_down_alt_rounded,
                        size: 28,
                      )),
                  BlocSelector<ReaderCubit, ReaderState, bool>(
                    selector: (state) => state.book.id != null,
                    builder: (context, bookmark) {
                      if (bookmark) {
                        return IconButton(
                            onPressed: () {
                              // ReaderCubit.onDeleteToBookmark();
                            },
                            icon: Icon(
                              Icons.bookmark_added_rounded,
                              color: colorScheme.primary,
                            ));
                      }
                      return IconButton(
                          onPressed: () {
                            // ReaderCubit.onAddToBookmark();
                          },
                          icon: const Icon(Icons.bookmark_add_rounded));
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }
}
