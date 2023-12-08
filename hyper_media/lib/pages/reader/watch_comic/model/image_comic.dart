// ignore_for_file: public_member_api_docs, sort_constructors_first

part of '../view/watch_comic_view.dart';

class ImageComic {
  final String url;
  final int index;
  final double height;
  ImageComic({
    required this.url,
    required this.index,
    required this.height,
  });

  @override
  String toString() => 'ImageComic(url: $url, index: $index, height: $height)';
}
