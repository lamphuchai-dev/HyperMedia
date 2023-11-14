import 'package:flutter/material.dart';

class WatchProgress extends ValueNotifier<String> {
  double? height;
  int? pages;
  int? currentPage;

  WatchProgress() : super("0/1");

  set setHeight(double value) => height = value;

  void restart() {
    value = "0/1";
  }

  void addListenerScroll(ScrollController scrollController) {
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final currentOffset = scrollController.offset;
    final totalPages =
        maxScrollExtent ~/ height! == 0 ? 1 : maxScrollExtent ~/ height!;
    final currentPage =
        currentOffset ~/ height! == 0 ? 1 : currentOffset ~/ height!;

    value = "$currentPage/$totalPages";
  }
}
