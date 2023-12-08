import 'package:flutter/material.dart';

import 'package:dio_client/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/widgets/widget.dart';

import '../cubit/extensions_cubit.dart';

part './extensions_page.dart';

part '../widgets/extensions_installed_tab.dart';
part '../widgets/extensions_all_tab.dart';
part '../widgets/extension_card.dart';


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
