import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/download.dart';
import 'package:hyper_media/services/download_manager.dart';
import 'package:rxdart/utils.dart';

part 'downloads_state.dart';

class DownloadsCubit extends Cubit<DownloadsState> {
  DownloadsCubit({required DownloadManager downloadService})
      : _downloadService = downloadService,
        super(const DownloadsState(
            status: StatusType.init, downloaded: [], waitingDownload: [])) {
    final streamSubscription =
        downloadService.waitingDownload.listen((downloads) {
      emit(state.copyWith(waitingDownload: downloads));
      // print("waiting : ${state.waitingDownload.length}");
    });
    final currentStreamSubscription =
        downloadService.downloadStream.listen((download) {
      emit(state.setCurrentDownload(download));
      // print("waiting : ${state.waitingDownload.length}");
    });
    _compositeSubscription.add(currentStreamSubscription);
    _compositeSubscription.add(streamSubscription);
  }
  final DownloadManager _downloadService;

  final _compositeSubscription = CompositeSubscription();

  void onInit() async {
    _loadDownloadComplete();
  }

  void _loadDownloadComplete() async {
    final downloads = await _downloadService.getListDownloadComplete;
    emit(state.copyWith(downloaded: downloads));
  }

  @override
  void onChange(Change<DownloadsState> change) {
    super.onChange(change);
    if (change.currentState.currentDownload != null &&
        change.currentState.currentDownload!.status ==
            DownloadStatus.downloaded) {
      _loadDownloadComplete();
    }
  }

  void closeCurrentDownload() async {
    await _downloadService.closeCurrentDownload();
    _loadDownloadComplete();
  }

  void onTapDeleteById(int id) async {
    final isDelete = await _downloadService.deleteDownloadById(id);
    if (isDelete) {
      _loadDownloadComplete();
    }
  }

  void onCancelDownload(Download download) async {
    await _downloadService.cancelDownload(download);
    _loadDownloadComplete();
  }

  @override
  Future<void> close() {
    _compositeSubscription.cancel();
    return super.close();
  }
}
