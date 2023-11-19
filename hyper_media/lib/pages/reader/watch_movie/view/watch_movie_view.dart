import 'package:flutter/material.dart';
import '../../reader/cubit/reader_cubit.dart';
import '../cubit/watch_movie_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'watch_movie_page.dart';

class WatchMovieView extends StatelessWidget {
  const WatchMovieView({super.key});
  static const String routeName = '/watch_movie_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WatchMovieCubit(readerBookCubit: context.read<ReaderCubit>())
            ..onInit(),
      child: const WatchMoviePage(),
    );
  }
}
