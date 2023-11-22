import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/route/routes.dart';
import 'package:hyper_media/pages/explore/widgets/widgets.dart';
import 'package:hyper_media/widgets/loading_widget.dart';
import '../cubit/explore_cubit.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ExploreCubit _exploreCubit;
  @override
  void initState() {
    _exploreCubit = context.read<ExploreCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreCubit, ExploreState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return switch (state) {
          ExploreExtensionLoading() => const LoadingWidget(),
          ExploreExtensionLoaded() => ExtensionReady(
              extension: state.extension,
              exploreCubit: _exploreCubit,
            ),
          ExploreExtensionError() => const ExtensionLoadError(),
          ExploreExtensionNull() => ExtensionNull(
              exploreCubit: _exploreCubit,
            ),
          _ => const SizedBox()
        };
      },
    );
    // return Navigator(
    //   onGenerateRoute: Routes.onGenerateRoute,
    //   initialRoute: Routes.initialRoute,

    // );
  }
}
