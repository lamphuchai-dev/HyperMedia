part of 'backup_restore_cubit.dart';

abstract class BackupRestoreState extends Equatable {
  const BackupRestoreState();
  @override
  List<Object> get props => [];
}

class BackupRestoreInitial extends BackupRestoreState {}
