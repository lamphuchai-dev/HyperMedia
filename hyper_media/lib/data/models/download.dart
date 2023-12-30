// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

import 'package:hyper_media/app/types/app_type.dart';

part 'download.g.dart';

@Collection()
class Download {
  final Id? id;
  @enumerated
  final DownloadStatus status;
  final int bookId;
  final int totalChaptersDownloaded;
  final int totalChaptersToDownload;
  final String bookName;
  final String bookImage;
  final DateTime dateTime;
  const Download({
    this.id,
    required this.status,
    required this.bookId,
    required this.totalChaptersDownloaded,
    required this.totalChaptersToDownload,
    required this.bookName,
    required this.bookImage,
    required this.dateTime,
  });

  Download copyWith({
    Id? id,
    DownloadStatus? status,
    int? bookId,
    int? totalChaptersDownloaded,
    int? totalChaptersToDownload,
    String? bookName,
    String? bookImage,
    DateTime? dateTime,
  }) {
    return Download(
      id: id ?? this.id,
      status: status ?? this.status,
      bookId: bookId ?? this.bookId,
      totalChaptersDownloaded:
          totalChaptersDownloaded ?? this.totalChaptersDownloaded,
      totalChaptersToDownload:
          totalChaptersToDownload ?? this.totalChaptersToDownload,
      bookName: bookName ?? this.bookName,
      bookImage: bookImage ?? this.bookImage,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status.name,
      'bookId': bookId,
      'totalChaptersDownloaded': totalChaptersDownloaded,
      'totalChaptersToDownload': totalChaptersToDownload,
      'bookName': bookName,
      'bookImage': bookImage,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Download.fromMap(Map<String, dynamic> map) {
    return Download(
      id: map['id'],
      status: DownloadStatus.values.firstWhere(
        (element) => element.name == map['status'],
        orElse: () => DownloadStatus.waiting,
      ),
      bookId: map['bookId'] as int,
      totalChaptersDownloaded: map['totalChaptersDownloaded'] as int,
      totalChaptersToDownload: map['totalChaptersToDownload'] as int,
      bookName: map['bookName'] as String,
      bookImage: map['bookImage'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Download.fromJson(String source) =>
      Download.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Download(id: $id, status: $status, bookId: $bookId, totalChaptersDownloaded: $totalChaptersDownloaded, totalChaptersToDownload: $totalChaptersToDownload, bookName: $bookName, bookImage: $bookImage, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant Download other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.status == status &&
        other.bookId == bookId &&
        other.totalChaptersDownloaded == totalChaptersDownloaded &&
        other.totalChaptersToDownload == totalChaptersToDownload &&
        other.bookName == bookName &&
        other.bookImage == bookImage &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        bookId.hashCode ^
        totalChaptersDownloaded.hashCode ^
        totalChaptersToDownload.hashCode ^
        bookName.hashCode ^
        bookImage.hashCode ^
        dateTime.hashCode;
  }
}
