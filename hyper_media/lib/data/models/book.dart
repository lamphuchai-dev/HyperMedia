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
  final bool isDownload;
  final ReadBook? readBook;

  @ignore
  final List<Genre> genres;

  const Book(
      {this.id,
      required this.name,
      required this.isDownload,
      required this.link,
      required this.host,
      required this.author,
      required this.bookStatus,
      required this.description,
      required this.cover,
      required this.totalChapters,
      this.readBook,
      this.genres = const [],
      this.updateAt});

  Book copyWith(
      {Id? id,
      String? name,
      String? link,
      String? author,
      String? description,
      String? cover,
      String? host,
      String? bookStatus,
      int? totalChapters,
      BookType? type,
      bool? isDownload,
      int? currentReadChapter,
      DateTime? updateAt,
      List<Genre>? genres,
      ReadBook? readBook,
      List<Book>? recommended}) {
    return Book(
        id: id ?? this.id,
        name: name ?? this.name,
        link: link ?? this.link,
        host: host ?? this.host,
        isDownload: isDownload ?? this.isDownload,
        author: author ?? this.author,
        bookStatus: bookStatus ?? this.bookStatus,
        description: description ?? this.description,
        cover: cover ?? this.cover,
        totalChapters: totalChapters ?? this.totalChapters,
        genres: genres ?? this.genres,
        updateAt: updateAt ?? this.updateAt,
        readBook: readBook ?? this.readBook);
  }

  Book deleteBookmark() {
    return Book(
      id: null,
      name: name,
      isDownload: isDownload,
      link: link,
      host: host,
      author: author,
      bookStatus: bookStatus,
      description: description,
      cover: cover,
      totalChapters: totalChapters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'link': link,
      'author': author,
      'description': description,
      'cover': cover,
      'totalChapters': totalChapters,
      "genres": genres.map(
        (e) => e.toMap(),
      ),
      'readBook': readBook?.toMap(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      name: map['name'] ?? "",
      link: map['link'] ?? "",
      host: map["host"] ?? "",
      author: map['author'] ?? "",
      description: map['description'] ?? "",
      cover: map['cover'] ?? "",
      totalChapters: map['totalChapters'] ?? 0,
      bookStatus: map["bookStatus"] ?? "",
      isDownload: map["isDownload"] ?? false,
      genres: map["genres"] != null
          ? List<Genre>.from(
              (map['genres']).map<Genre>(
                (x) => Genre.fromMap(x),
              ),
            )
          : [],
      updateAt: map["updateAt"],
      readBook:
          map["readBook"] != null ? ReadBook.fromMap(map["readBook"]) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(id: $id, name: $name, link: $link, host: $host, author: $author, description: $description, cover: $cover, bookStatus: $bookStatus, totalChapters: $totalChapters, updateAt: $updateAt, isDownload: $isDownload, readBook: $readBook, genres: $genres)';
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
        other.isDownload == isDownload &&
        other.readBook == readBook &&
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
        isDownload.hashCode ^
        readBook.hashCode ^
        genres.hashCode;
  }
}

extension BookExtension on Book {
  String get getPercentRead {
    final result = ((readBook?.index ?? 1) / totalChapters) * 100;
    return result.toStringAsFixed(2);
  }

  String get bookUrl => host + link;

  String getHostByUrl(String url) {
    final uri = Uri.parse(link);
    return "${uri.scheme}://${uri.host}";
  }
}

@embedded
class ReadBook {
  final int? index;
  final String? titleChapter;
  final String? nameExtension;
  final double? offsetLast;
  ReadBook({
    this.index,
    this.titleChapter,
    this.nameExtension,
    this.offsetLast,
  });

  ReadBook copyWith({
    int? index,
    String? titleChapter,
    String? nameExtension,
    double? offsetLast,
  }) {
    return ReadBook(
      index: index ?? this.index,
      titleChapter: titleChapter ?? this.titleChapter,
      nameExtension: nameExtension ?? this.nameExtension,
      offsetLast: offsetLast ?? this.offsetLast,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'titleChapter': titleChapter,
      'nameExtension': nameExtension,
      'offsetLast': offsetLast,
    };
  }

  factory ReadBook.fromMap(Map<String, dynamic> map) {
    return ReadBook(
      index: map['index'] != null ? map['index'] as int : null,
      titleChapter:
          map['titleChapter'] != null ? map['titleChapter'] as String : null,
      nameExtension:
          map['nameExtension'] != null ? map['nameExtension'] as String : null,
      offsetLast:
          map['offsetLast'] != null ? map['offsetLast'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadBook.fromJson(String source) =>
      ReadBook.fromMap(json.decode(source) as Map<String, dynamic>);
}
