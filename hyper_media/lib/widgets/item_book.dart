import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/models.dart';

import 'book_cover_image.dart';
import 'cache_network_image.dart';

enum BookLayoutType { column, stack }

class ItemBook extends StatelessWidget {
  const ItemBook(
      {super.key,
      required this.book,
      this.onTap,
      this.onLongTap,
      this.layout = BookLayoutType.column,
      this.bookMark = false});
  final Book book;
  final bool bookMark;
  final BookLayoutType layout;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Builder(
          builder: (context) => switch (layout) {
                BookLayoutType.column => Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: Dimens.cardBookBorderRadius,
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(child: _coverBook()),
                                  // Positioned(
                                  //     left: 0, top: 0, child: _cardPercent()),
                                ],
                              ))),
                      Gaps.hGap4,
                      _info()
                    ],
                  ),
                BookLayoutType.stack => Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: Dimens.cardBookBorderRadius,
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(child: _coverBook()),
                                  Positioned(
                                      left: 0, top: 0, child: _cardPercent()),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: _readChapter()),
                                ],
                              ))),
                      Gaps.hGap4,
                      _info(des: false)
                    ],
                  ),
              }),
    );
  }

  Widget _coverBook() {
    return BookCoverImage(
      cover: book.cover,
    );
    if (book.cover.startsWith("http")) {
      return CacheNetWorkImage(book.cover);
    }
    try {
      final bytes = base64Decode(book.cover);
      return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
          ));
    } catch (e) {
      return Image.asset(
        AppAssets.backgroundBook,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _cardPercent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8))),
      child: Text(
        "${book.currentIndex! + 1}/${book.totalChapters}",
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _readChapter() {
    if (book.currentTitleChapter == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8))),
      child: Text(
        "${book.latestChapterTitle}",
        style: const TextStyle(
          fontSize: 10,
        ),
        maxLines: 3,
      ),
    );
  }

  Widget _info({bool des = true}) {
    return Column(
      children: [
        SizedBox(
          height: 35,
          child: Text(
            book.name.toTitleCase(),
            style: const TextStyle(fontSize: 15, height: 1),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        if (des)
          Text(
            book.description,
            style: const TextStyle(fontSize: 11, height: 0.8),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
      ],
    );
  }
}
