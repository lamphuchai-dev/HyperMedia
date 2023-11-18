// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_comic_cubit.dart';

class WatchComicState extends Equatable {
  const WatchComicState(
      {required this.watchChapter, required this.watchStatus});
  final Chapter watchChapter;
  final StatusType watchStatus;
  @override
  List<Object> get props => [watchChapter, watchStatus];

  WatchComicState copyWith({
    Chapter? watchChapter,
    StatusType? watchStatus,
  }) {
    return WatchComicState(
      watchChapter: watchChapter ?? this.watchChapter,
      watchStatus: watchStatus ?? this.watchStatus,
    );
  }
}
