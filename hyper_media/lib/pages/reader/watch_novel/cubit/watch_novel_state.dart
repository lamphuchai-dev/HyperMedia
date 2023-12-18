// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_novel_cubit.dart';

class WatchNovelState extends Equatable {
  const WatchNovelState(
      {required this.status,
      required this.watchChapter,
      required this.settings});
  final StatusType status;
  final Chapter watchChapter;
  final WatchNovelSetting settings;
  @override
  List<Object> get props => [status, watchChapter, settings];

  WatchNovelState copyWith(
      {StatusType? status,
      Chapter? watchChapter,
      WatchNovelSetting? settings}) {
    return WatchNovelState(
        status: status ?? this.status,
        watchChapter: watchChapter ?? this.watchChapter,
        settings: settings ?? this.settings);
  }
}
