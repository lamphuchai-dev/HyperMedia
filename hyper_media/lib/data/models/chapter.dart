// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import 'package:hyper_media/app/types/app_type.dart';

part 'chapter.g.dart';

@Collection()
class Chapter {
  final Id? id;
  final int? bookId;
  final String name;
  final String url;
  final String host;
  final int index;
  final List<String>? contentComic;
  final String? contentNovel;
  @ignore
  final List<Map<String, dynamic>>? contentVideo;
  Chapter({
    this.id,
    this.bookId,
    required this.name,
    required this.url,
    required this.host,
    required this.index,
    this.contentComic,
    this.contentNovel,
    this.contentVideo,
  });

  Chapter copyWith({
    Id? id,
    int? bookId,
    String? name,
    String? url,
    String? host,
    int? index,
    List<String>? contentComic,
    String? contentNovel,
    List<Map<String, dynamic>>? contentVideo,
  }) {
    return Chapter(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      url: url ?? this.url,
      host: host ?? this.host,
      index: index ?? this.index,
      contentComic: contentComic ?? this.contentComic,
      contentNovel: contentNovel ?? this.contentNovel,
      contentVideo: contentVideo ?? this.contentVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookId': bookId,
      'name': name,
      'url': url,
      'host': host,
      'index': index,
      'contentComic': contentComic,
      'contentNovel': contentNovel,
      'contentVideo': contentVideo,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
        id: map['id'],
        bookId: map['bookId'] != null ? map['bookId'] as int : null,
        name: map['name'] ?? "",
        url: map['url'] ?? "",
        host: map['host'] ?? "",
        index: map['index'] ?? 0,
        contentVideo: map['contentVideo'] != null
            ? List<Map<String, dynamic>>.from(
                (map['contentVideo']),
              )
            : null,
        contentComic: map['contentComic'] != null
            ? List<String>.from(
                (map['contentComic']),
              )
            : null,
        contentNovel: map['contentNovel']);
  }

  Chapter addContentByExtensionType(
      {required ExtensionType type, required dynamic value}) {
    try {
      switch (type) {
        case ExtensionType.comic:
          if (value is List) {
            return copyWith(contentComic: List<String>.from(value));
          }
          throw "value is List<String>";
        case ExtensionType.movie:
          if (value is List) {
            return copyWith(
                contentVideo: List<Map<String, dynamic>>.from(value));
          }
          throw "value is List<Map<String, dynamic>>";
        case ExtensionType.novel:
          if (value is String) {
            return copyWith(contentNovel: value);
          }
          throw "value is String";
        default:
          return this;
      }
    } catch (error) {
      rethrow;
    }
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chapter(id: $id, bookId: $bookId, name: $name, url: $url, host: $host, index: $index, contentComic: $contentComic, contentNovel: $contentNovel, contentVideo: $contentVideo)';
  }

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.bookId == bookId &&
        other.name == name &&
        other.url == url &&
        other.host == host &&
        other.index == index &&
        listEquals(other.contentComic, contentComic) &&
        other.contentNovel == contentNovel &&
        listEquals(other.contentVideo, contentVideo);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bookId.hashCode ^
        name.hashCode ^
        url.hashCode ^
        host.hashCode ^
        index.hashCode ^
        contentComic.hashCode ^
        contentNovel.hashCode ^
        contentVideo.hashCode;
  }
}
