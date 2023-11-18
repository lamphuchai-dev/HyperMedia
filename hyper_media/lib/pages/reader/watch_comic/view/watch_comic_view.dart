import 'package:flutter/material.dart';
import '../../reader/cubit/reader_cubit.dart';
import '../cubit/watch_comic_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'watch_comic_page.dart';

class WatchComicView extends StatelessWidget {
  const WatchComicView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WatchComicCubit(readerBookCubit: context.read<ReaderCubit>())
            ..onInit(),
      child: const WatchComicPage(),
    );
  }
}
