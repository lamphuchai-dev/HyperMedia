import 'package:flutter/material.dart';
import '../../reader/cubit/reader_cubit.dart';
import '../cubit/watch_novel_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'watch_novel_page.dart';

class WatchNovelView extends StatelessWidget {
  const WatchNovelView({super.key});
  static const String routeName = '/watch_novel_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchNovelCubit(readerBookCubit: context.read<ReaderCubit>())..onInit(),
      child: const WatchNovelPage(),
    );
  }
}
