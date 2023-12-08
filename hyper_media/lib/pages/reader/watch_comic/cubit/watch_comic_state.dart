// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_comic_cubit.dart';

class WatchComicState extends Equatable {
  const WatchComicState(
      {required this.settings,
      required this.status,
      required this.watchChapter});
  final WatchComicSettings settings;
  final StatusType status;
  final Chapter watchChapter;
  @override
  List<Object> get props => [settings, status,watchChapter];

  WatchComicState copyWith(
      {WatchComicSettings? settings,
      StatusType? status,
      Chapter? watchChapter}) {
    return WatchComicState(
        settings: settings ?? this.settings,
        status: status ?? this.status,
        watchChapter: watchChapter ?? this.watchChapter);
  }
}
