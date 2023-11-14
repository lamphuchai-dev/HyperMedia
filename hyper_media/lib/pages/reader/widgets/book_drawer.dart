import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/gaps.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/book.dart';
import 'package:hyper_media/widgets/widget.dart';

import '../cubit/reader_cubit.dart';

class BookDrawer extends StatefulWidget {
  const BookDrawer({super.key});

  @override
  State<BookDrawer> createState() => _BookDrawerState();
}

class _BookDrawerState extends State<BookDrawer> {
  final backgroundColor = Colors.grey;
  late ReaderCubit _readerCubit;
  late Book _book;

  @override
  void initState() {
    _readerCubit = context.read<ReaderCubit>();
    _book = _readerCubit.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Drawer(
      width: context.width * 0.85,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(),
      child: Column(children: [
        _headerDrawer(),
        Expanded(
          child: ListChaptersWidget(
                indexSelect: _readerCubit.state.watchChapter!.chapter.index,
                chapters: _readerCubit.getChapters,
                usePage: UsePage.readChapter,
                onTapChapter: (chapter) {
                  _readerCubit.onChangeReadChapter(chapter.index);
                  Scaffold.of(context).openEndDrawer();
                },
              ),
        ),
        // if (_book.type != BookType.video)
        ColoredBox(
          color: colorScheme.background,
          child: SafeArea(
            top: false,
            bottom: true,
            child: Container(
              height: 56,
              decoration: BoxDecoration(color: colorScheme.background),
              alignment: Alignment.center,
              child: Row(
                children: [
                  const Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.download_rounded),
                  )),
                  Gaps.wGap8,
                  Text(
                    "book.downloadBookChapters".tr(
                        args: [_readerCubit.getChapters.length.toString()]),
                    style: textTheme.titleMedium,
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget _headerDrawer() {
    return SizedBox(
      height: context.height * 0.22,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesName.detail,
              arguments: _book.bookUrl);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
                child: BlurredBackdropImage(
              url: _book.cover,
            )),
            Positioned(
                top: kToolbarHeight,
                left: 16,
                bottom: 10,
                right: 0,
                child: Row(
                  children: [
                    CacheNetWorkImage(_book.cover),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(_book.name),
                          ),
                          Expanded(child: Text(_book.author))
                        ],
                      ),
                    ))
                  ],
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // _readerCubit.onRefreshChapters();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
