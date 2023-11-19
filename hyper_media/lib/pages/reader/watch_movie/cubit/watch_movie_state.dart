// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_movie_cubit.dart';

class WatchMovieState extends Equatable {
  const WatchMovieState(
      {required this.watchChapter, required this.status, this.server});
  final Chapter watchChapter;
  final StatusType status;
  final MovieServer? server;
  @override
  List<Object?> get props => [watchChapter, status, server];

  WatchMovieState copyWith(
      {Chapter? watchChapter, StatusType? status, MovieServer? server}) {
    return WatchMovieState(
        watchChapter: watchChapter ?? this.watchChapter,
        status: status ?? this.status,
        server: server ?? this.server);
  }
}
