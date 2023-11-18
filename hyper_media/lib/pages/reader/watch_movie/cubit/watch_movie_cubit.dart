import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watch_movie_state.dart';

class WatchMovieCubit extends Cubit<WatchMovieState> {
  WatchMovieCubit() : super(WatchMovieInitial());

  void onInit() {}
}
