// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'downloads_cubit.dart';

class DownloadsState extends Equatable {
  const DownloadsState(
      {required this.downloaded,
      required this.status,
      this.currentDownload,
      required this.waitingDownload});
  final StatusType status;
  final List<Download> downloaded;
  final List<Download> waitingDownload;

  final Download? currentDownload;

  @override
  List<Object?> get props =>
      [status, currentDownload, downloaded, waitingDownload];

  DownloadsState copyWith({
    StatusType? status,
    List<Download>? downloaded,
    List<Download>? waitingDownload,
    Download? currentDownload,
  }) {
    return DownloadsState(
      status: status ?? this.status,
      downloaded: downloaded ?? this.downloaded,
      waitingDownload: waitingDownload ?? this.waitingDownload,
      currentDownload: currentDownload ?? this.currentDownload,
    );
  }

  DownloadsState setCurrentDownload(Download? currentDownload) {
    return DownloadsState(
      status: status,
      downloaded: downloaded,
      waitingDownload: waitingDownload,
      currentDownload: currentDownload,
    );
  }
}
