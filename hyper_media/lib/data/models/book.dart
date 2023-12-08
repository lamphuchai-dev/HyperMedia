// // ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import 'package:hyper_media/data/models/models.dart';

part 'book.g.dart';

enum BookType { novel, comic, video }

// flutter clean && flutter pub get && flutter pub run build_runner build
@Collection()
class Book {
  final Id? id;
  @Index()
  final String name;
  final String link;
  final String host;
  final String author;
  final String description;
  final String cover;
  final String bookStatus;
  final int totalChapters;
  final DateTime? updateAt;
  final String? latestChapterTitle;
  // Thời điểm kiếm tra chương gần đây nhất
  final DateTime? lastCheckTime;
  // Tiêu đề của chương đang xem
  final String? currentTitleChapter;
  // index của chương đang xem
  final int? currentIndex;

  @ignore
  final List<Genre> genres;
  Book({
    this.id,
    required this.name,
    required this.link,
    required this.host,
    required this.author,
    required this.description,
    required this.cover,
    required this.bookStatus,
    required this.totalChapters,
    this.updateAt,
    this.latestChapterTitle,
    this.lastCheckTime,
    this.currentTitleChapter,
    this.currentIndex,
    this.genres = const [],
  });

  Book copyWith({
    Id? id,
    String? name,
    String? link,
    String? host,
    String? author,
    String? description,
    String? cover,
    String? bookStatus,
    int? totalChapters,
    DateTime? updateAt,
    String? latestChapterTitle,
    DateTime? lastCheckTime,
    String? currentTitleChapter,
    int? currentIndex,
    List<Genre>? genres,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      link: link ?? this.link,
      host: host ?? this.host,
      author: author ?? this.author,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      bookStatus: bookStatus ?? this.bookStatus,
      totalChapters: totalChapters ?? this.totalChapters,
      updateAt: updateAt ?? this.updateAt,
      latestChapterTitle: latestChapterTitle ?? this.latestChapterTitle,
      lastCheckTime: lastCheckTime ?? this.lastCheckTime,
      currentTitleChapter: currentTitleChapter ?? this.currentTitleChapter,
      currentIndex: currentIndex ?? this.currentIndex,
      genres: genres ?? this.genres,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'link': link,
      'host': host,
      'author': author,
      'description': description,
      'cover': cover,
      'bookStatus': bookStatus,
      'totalChapters': totalChapters,
      'updateAt': updateAt?.millisecondsSinceEpoch,
      'latestChapterTitle': latestChapterTitle,
      'lastCheckTime': lastCheckTime?.millisecondsSinceEpoch,
      'currentTitleChapter': currentTitleChapter,
      'currentIndex': currentIndex,
      'genres': genres.map((x) => x.toMap()).toList(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      name: map['name'] ?? "",
      link: map['link'] ?? "",
      host: map['host'] ?? "",
      author: map['author'] ?? "",
      description: map['description'] ?? "",
      cover: map['cover'] ?? "",
      bookStatus: map['bookStatus'] ?? "",
      totalChapters: map['totalChapters'] ?? 0,
      updateAt: map['updateAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateAt'] as int)
          : null,
      latestChapterTitle: map['latestChapterTitle'] != null
          ? map['latestChapterTitle'] as String
          : null,
      lastCheckTime: map['lastCheckTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastCheckTime'] as int)
          : null,
      currentTitleChapter: map['currentTitleChapter'] != null
          ? map['currentTitleChapter'] as String
          : null,
      currentIndex: map['currentIndex'] ?? 0,
      genres: map["genres"] != null
          ? List<Genre>.from(
              (map['genres']).map<Genre>(
                (x) => Genre.fromMap(x),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(id: $id, name: $name, link: $link, host: $host, author: $author, description: $description, cover: $cover, bookStatus: $bookStatus, totalChapters: $totalChapters, updateAt: $updateAt, latestChapterTitle: $latestChapterTitle, lastCheckTime: $lastCheckTime, currentTitleChapter: $currentTitleChapter, currentIndex: $currentIndex, genres: $genres)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.link == link &&
        other.host == host &&
        other.author == author &&
        other.description == description &&
        other.cover == cover &&
        other.bookStatus == bookStatus &&
        other.totalChapters == totalChapters &&
        other.updateAt == updateAt &&
        other.latestChapterTitle == latestChapterTitle &&
        other.lastCheckTime == lastCheckTime &&
        other.currentTitleChapter == currentTitleChapter &&
        other.currentIndex == currentIndex &&
        listEquals(other.genres, genres);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        link.hashCode ^
        host.hashCode ^
        author.hashCode ^
        description.hashCode ^
        cover.hashCode ^
        bookStatus.hashCode ^
        totalChapters.hashCode ^
        updateAt.hashCode ^
        latestChapterTitle.hashCode ^
        lastCheckTime.hashCode ^
        currentTitleChapter.hashCode ^
        currentIndex.hashCode ^
        genres.hashCode;
  }
}

extension BookExtension on Book {
  // String get getPercentRead {
  //   final result = ((readBook?.index ?? 1) / totalChapters) * 100;
  //   return result.toStringAsFixed(2);
  // }

  String get bookUrl => host + link;

  String getHostByUrl(String url) {
    final uri = Uri.parse(link);
    return "${uri.scheme}://${uri.host}";
  }
}
