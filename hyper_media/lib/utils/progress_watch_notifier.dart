import 'package:flutter/foundation.dart';

class ProgressWatchNotifier extends ValueNotifier<ProgressWatch?> {
  double? height;

  ProgressWatchNotifier({
    ProgressWatch? progressWatch,
  }) : super(progressWatch);

  void addListenerProgress(
      {required double maxScrollExtent,
      required double offsetCurrent,
      required double height}) {
    final progress = ProgressWatch(
        totalPage:
            maxScrollExtent ~/ height == 0 ? 1 : maxScrollExtent ~/ height,
        currentPage: offsetCurrent ~/ height == 0 ? 1 : offsetCurrent ~/ height,
        percent: (offsetCurrent / maxScrollExtent) * 100);
    if (value == null || progress != value) {
      value = progress;
    }
  }
}

class ProgressWatch {
  final int totalPage;
  final int currentPage;
  final double percent;
  const ProgressWatch({
    required this.totalPage,
    required this.currentPage,
    required this.percent,
  });

  factory ProgressWatch.init() =>
      const ProgressWatch(currentPage: 0, totalPage: 1, percent: 0.0);

  String get getProgressPage => "$currentPage/$totalPage";
  String get getPercent => "${percent.toInt()}%";

  @override
  String toString() =>
      'ProgressWatch(totalPage: $totalPage, currentPage: $currentPage, percent: $percent)';

  @override
  bool operator ==(covariant ProgressWatch other) {
    if (identical(this, other)) return true;

    return other.totalPage == totalPage &&
        other.currentPage == currentPage &&
        other.percent == percent;
  }

  @override
  int get hashCode =>
      totalPage.hashCode ^ currentPage.hashCode ^ percent.hashCode;
}
