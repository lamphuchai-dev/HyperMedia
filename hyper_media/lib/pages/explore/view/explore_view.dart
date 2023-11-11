import 'package:flutter/material.dart';
import 'package:hyper_media/app/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:js_runtime/js_runtime.dart';
import '../cubit/explore_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'explore_page.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});
  static const String routeName = '/explore_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(
          database: getIt<DatabaseUtils>(), jsRuntime: getIt<JsRuntime>())
        ..onInit(),
      child: const ExplorePage(),
    );
  }
}
