import 'package:flutter/material.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/pages/explore/cubit/explore_cubit.dart';

class ExtensionNull extends StatelessWidget {
  const ExtensionNull({super.key, required this.exploreCubit});
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
