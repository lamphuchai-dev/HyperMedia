// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hyper_media/data/models/models.dart';
import 'package:isar/isar.dart';

part 'bookmark_tmp.g.dart';

@collection
class BookmarkTest {
  final Id? id;
  final String name;
  final String link;
  final String host;
  final String author;
  final String description;
  final String cover;
  final int totalChapter;
  final String latestChapterTitle;
  // Thời điểm kiếm tra chương gần đây nhất
  final DateTime lastCheckTime;
  // Tiêu đề của chương đang xem
  final String currentTitleChapter;
  // index của chương đang xem
  final int currentIndex;
  BookmarkTest({
    this.id,
    required this.name,
    required this.link,
    required this.host,
    required this.author,
    required this.description,
    required this.cover,
    required this.totalChapter,
    required this.latestChapterTitle,
    required this.lastCheckTime,
    required this.currentTitleChapter,
    required this.currentIndex,
  });

  BookmarkTest copyWith({
    Id? id,
    String? name,
    String? link,
    String? host,
    String? author,
    String? description,
    String? cover,
    int? totalChapter,
    String? latestChapterTitle,
    DateTime? lastCheckTime,
    String? currentTitleChapter,
    int? currentIndex,
  }) {
    return BookmarkTest(
      id: id ?? this.id,
      name: name ?? this.name,
      link: link ?? this.link,
      host: host ?? this.host,
      author: author ?? this.author,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      totalChapter: totalChapter ?? this.totalChapter,
      latestChapterTitle: latestChapterTitle ?? this.latestChapterTitle,
      lastCheckTime: lastCheckTime ?? this.lastCheckTime,
      currentTitleChapter: currentTitleChapter ?? this.currentTitleChapter,
      currentIndex: currentIndex ?? this.currentIndex,
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
      'totalChapter': totalChapter,
      'latestChapterTitle': latestChapterTitle,
      'lastCheckTime': lastCheckTime.millisecondsSinceEpoch,
      'currentTitleChapter': currentTitleChapter,
      'currentIndex': currentIndex,
    };
  }

  factory BookmarkTest.fromMap(Map<String, dynamic> map) {
    return BookmarkTest(
      id: map['id'],
      name: map['name'] ?? "",
      link: map['link'] ?? "",
      host: map['host'] ?? "",
      author: map['author'] ?? "",
      description: map['description'] ?? "",
      cover: map['cover'] ?? "",
      totalChapter: map['totalChapter'] ?? 0,
      latestChapterTitle: map['latestChapterTitle'] ?? "",
      lastCheckTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastCheckTime'] as int),
      currentTitleChapter: map['currentTitleChapter'] ?? "",
      currentIndex: map['currentIndex'] ?? 0,
    );
  }

  Book toBook() => Book(
      name: name,
      link: link,
      host: host,
      author: author,
      description: description,
      cover: cover,
      totalChapters: totalChapter,
      bookStatus: "");

  factory BookmarkTest.fromBook(
      {required Book book,
      required String latestChapterTitle,
      required String currentTitleChapter,
      int currentIndex = 0}) {
    return BookmarkTest(
        name: book.name,
        link: book.link,
        host: book.host,
        author: book.author,
        description: book.description,
        cover: book.cover,
        totalChapter: book.totalChapters,
        latestChapterTitle: latestChapterTitle,
        lastCheckTime: DateTime.now(),
        currentTitleChapter: currentTitleChapter,
        currentIndex: currentIndex);
  }

  String toJson() => json.encode(toMap());

  factory BookmarkTest.fromJson(String source) =>
      BookmarkTest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookmarkTest(id: $id, name: $name, link: $link, host: $host, author: $author, description: $description, cover: $cover, totalChapter: $totalChapter, latestChapterTitle: $latestChapterTitle, lastCheckTime: $lastCheckTime, currentTitleChapter: $currentTitleChapter, currentIndex: $currentIndex)';
  }

  @override
  bool operator ==(covariant BookmarkTest other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.link == link &&
        other.host == host &&
        other.author == author &&
        other.description == description &&
        other.cover == cover &&
        other.totalChapter == totalChapter &&
        other.latestChapterTitle == latestChapterTitle &&
        other.lastCheckTime == lastCheckTime &&
        other.currentTitleChapter == currentTitleChapter &&
        other.currentIndex == currentIndex;
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
        totalChapter.hashCode ^
        latestChapterTitle.hashCode ^
        lastCheckTime.hashCode ^
        currentTitleChapter.hashCode ^
        currentIndex.hashCode;
  }
}
