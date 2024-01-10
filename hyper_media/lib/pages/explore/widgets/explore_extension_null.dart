part of '../view/explore_view.dart';

class ExploreExtensionNull extends StatelessWidget {
  const ExploreExtensionNull({super.key, required this.exploreCubit});
  final ExploreCubit exploreCubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.extensions).then((value) {
              exploreCubit.onInit();
            });
          },
          child: const Text("Install")),
    );
  }
}
