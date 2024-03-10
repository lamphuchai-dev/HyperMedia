import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/di/modules/local_module.dart';
import 'package:hyper_media/services/local_notification.service.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/directory_utils.dart';
import 'package:hyper_media/utils/permission_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../cubit/settings_cubit.dart';

part 'settings_page.dart';
part '../widgets/widgets.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String routeName = '/settings_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..onInit(),
      child: const SettingsPage(),
    );
  }
}
