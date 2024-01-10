import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/download.dart';
import 'package:hyper_media/services/download_manager.dart';
import 'package:hyper_media/utils/download_service.dart';

part 'downloads_state.dart';

class DownloadsCubit extends Cubit<DownloadsState> {
  DownloadsCubit({required DownloadManager downloadService})
      : _downloadService = downloadService,
        super(const DownloadsState(
            status: StatusType.init, downloaded: [], waitingDownload: [])) {
    _streamSubscription = downloadService.downloadStream.listen((download) {
      if (download != null) {
        if (isClosed) return;
        emit(state.copyWith(currentDownload: download));
      } else {
        if (isClosed) return;
        emit(state.setCurrentDownloadNull());
        // onInit();
      }
    });
  }
  final DownloadManager _downloadService;

  late StreamSubscription _streamSubscription;

  void onInit() async {
    // final currentDownload = _downloadService.currentDownload;

    // DownloadsState downloadsState = state.setCurrentDownloadNull();
    // if (currentDownload != null) {
    //   downloadsState =
    //       downloadsState.copyWith(currentDownload: currentDownload);
    // }

    // final downloads = await _downloadService.downloads();

    // final waitingDownload = downloads
    //     .where((element) => element.status == DownloadStatus.waiting)
    //     .toList();

    // downloadsState = downloadsState.copyWith(
    //     downloaded: downloads, waitingDownload: waitingDownload);
    // emit(downloadsState);
  }

  void closeDownload() async {
    await _downloadService.closeCurrentDownload();
    emit(state.setCurrentDownloadNull());
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
