// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_movie_cubit.dart';

class WatchMovieState extends Equatable {
  const WatchMovieState(
      {required this.servers, required this.watchChapter, required this.status});
  final List<MovieServer> servers;
  final Chapter watchChapter;
  final StatusType status;
  @override
  List<Object> get props => [servers, watchChapter, status];

  WatchMovieState copyWith({
    List<MovieServer>? servers,
    Chapter? watchChapter,
    StatusType? status,
  }) {
    return WatchMovieState(
      servers: servers ?? this.servers,
      watchChapter: watchChapter ?? this.watchChapter,
      status: status ?? this.status,
    );
  }
}
