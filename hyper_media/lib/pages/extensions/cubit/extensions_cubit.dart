import 'dart:async';
import 'dart:convert';

import 'package:dio_client/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/constants.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/logger.dart';

part 'extensions_state.dart';

class ExtensionsCubit extends Cubit<ExtensionsState> {
  ExtensionsCubit(
      {required DatabaseUtils database, required DioClient dioClient})
      : _database = database,
        _dioClient = dioClient,
        super(ExtensionsState(
            allExtension: StateModel.init(), installed: StateModel.init()));
  final _logger = Logger("ExtensionsCubit");
  final DatabaseUtils _database;
  final DioClient _dioClient;
  void onInit() async {
    getExtensions();
    getExtensionsInstalledTab();
  }

  void getExtensionsInstalledTab() async {
    try {
      emit(state.copyWith(
          installed: const StateModel(data: [], status: StatusType.init)));
      final exts = await _database.getExtensions;
      emit(state.copyWith(
          installed: StateModel(data: exts, status: StatusType.loaded)));
    } catch (error) {
      _logger.error(error, name: "getExtensionsInstalledTab");
      emit(state.copyWith(
          installed: const StateModel(data: [], status: StatusType.error)));
    }
  }

  void getExtensions() async {
    try {
      emit(state.copyWith(
          allExtension:
              const StateModel(data: [], status: StatusType.loading)));
      final res = await _dioClient.get(Constants.urlExtensions);
      final data = jsonDecode(res);
      if (data is List) {
        List<Metadata> metadata =
            data.map<Metadata>((map) => Metadata.fromMap(map)).toList();
        emit(state.copyWith(
            allExtension:
                StateModel(data: metadata, status: StatusType.loaded)));
      } else {
        emit(state.copyWith(
            allExtension:
                const StateModel(data: [], status: StatusType.error)));
      }
    } catch (error) {
      _logger.error(error, name: "getExtensions");
      emit(state.copyWith(
          allExtension: const StateModel(data: [], status: StatusType.error)));
    }
  }

  Future<bool> onUninstallExt(Extension extension) async {
    final isDelete = await _database.deleteExtensionById(extension.id!);
    if (!isDelete) return false;

    final all = state.allExtension.data;
    final install = await _database.getExtensions;
    emit(state.copyWith(
        allExtension: StateModel(
            data: [...all, extension.metadata], status: StatusType.loaded),
        installed: StateModel(data: install, status: StatusType.loaded)));
    return true;
  }

  Future<bool> onInstallExt(String url) async {
    final ext = await _database.installExtensionByUrl(url);
    if (ext == null) return false;
    final data = state.allExtension.data.where((el) => el.path != url).toList();
    final install = await _database.getExtensions;
    emit(state.copyWith(
        allExtension: StateModel(data: data, status: StatusType.loaded),
        installed: StateModel(data: install, status: StatusType.loaded)));
    return true;
  }

  List<Metadata> removeExtInstalled(List<Metadata> list) {
    Map<String, Metadata> mapList = {
      for (var element in list) element.name!: element
    };
    for (var ext in state.installed.data) {
      if (mapList[ext.metadata.name] != null) {
        mapList.remove(ext.metadata.name);
      }
    }
    return mapList.values.toList();
  }
}
