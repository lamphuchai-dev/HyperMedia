import 'package:dio_client/index.dart';
import 'package:flutter/material.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import '../cubit/extensions_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'extensions_page.dart';

class ExtensionsView extends StatelessWidget {
  const ExtensionsView({super.key});
  static const String routeName = '/extensions_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExtensionsCubit(
          database: getIt<DatabaseUtils>(), dioClient: getIt<DioClient>())
        ..onInit(),
      child: const ExtensionsPage(),
    );
  }
}
