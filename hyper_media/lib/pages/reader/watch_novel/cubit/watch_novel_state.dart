// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_novel_cubit.dart';

class WatchNovelState extends Equatable {
  const WatchNovelState({required this.status, required this.watchChapter});
  final StatusType status;
  final Chapter watchChapter;
  @override
  List<Object> get props => [status, watchChapter];

  WatchNovelState copyWith({
    StatusType? status,
    Chapter? watchChapter,
  }) {
    return WatchNovelState(
      status: status ?? this.status,
      watchChapter: watchChapter ?? this.watchChapter,
    );
  }
}
