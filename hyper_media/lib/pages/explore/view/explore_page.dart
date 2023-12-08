part of 'explore_view.dart';

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
          ExploreLoading() => const LoadingWidget(),
          ExploreLoaded() => ExtensionReady(
              extension: state.extension,
              exploreCubit: _exploreCubit,
            ),
          ExploreError() => const ExtensionLoadError(),
          ExploreNotExtension() => ExploreExtensionNull(
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
