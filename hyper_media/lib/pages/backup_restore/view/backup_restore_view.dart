import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';

import '../cubit/backup_restore_cubit.dart';

part 'backup_restore_page.dart';
part '../widgets/widgets.dart';

class BackupRestoreView extends StatelessWidget {
  const BackupRestoreView({super.key});
  static const String routeName = '/backup_restore_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BackupRestoreCubit(database: getIt<DatabaseUtils>())..onInit(),
      child: const BackupRestorePage(),
    );
  }
}
