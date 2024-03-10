import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:path_provider/path_provider.dart';

part 'backup_restore_state.dart';

class BackupRestoreCubit extends Cubit<BackupRestoreState> {
  BackupRestoreCubit({required DatabaseUtils database})
      : _database = database,
        super(BackupRestoreInitial());
  final DatabaseUtils _database;
  void onInit() {}

  void backup() async {
    await _database.backupDatabase();
  }


  Future<bool> restore() => _database.restoreDatabase();
}
