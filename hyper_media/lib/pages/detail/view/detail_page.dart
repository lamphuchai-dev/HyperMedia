import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/widgets/loading_widget.dart';

import '../cubit/detail_cubit.dart';
import '../widgets/book_loaded.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailCubit>().onInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DetailCubit, DetailState, DetailState>(
      selector: (state) => state,
      builder: (context, state) {
        return switch (state) {
          DetailLoaded() => BookLoaded(
              book: state.book,
            ),
          DetailError() => DefaultWidget(
              key: const ValueKey("error"),
              child: Text((state).message),
            ),
          _ => const DefaultWidget(
              key: ValueKey("default"),
              child: Center(
                child: LoadingWidget(),
              ),
            )
        };
      },
    );
  }
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: child);
  }
}
