import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/watch_movie_cubit.dart';
import '../widgets/widgets.dart';

class WatchMoviePage extends StatefulWidget {
  const WatchMoviePage({super.key});

  @override
  State<WatchMoviePage> createState() => _WatchMoviePageState();
}

class _WatchMoviePageState extends State<WatchMoviePage> {
  late WatchMovieCubit _watchMovieCubit;
  @override
  void initState() {
    _watchMovieCubit = context.read<WatchMovieCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Watch movie")),
      body: SizedBox(),
    );
  }
}
