// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'reader.g.dart';

@Collection()
class Reader {
  final Id? id;
  final String nameChapter;
  final double offset;
  final String url;
  final DateTime time;
  Reader({
    this.id,
    required this.nameChapter,
    required this.offset,
    required this.url,
    required this.time,
  });

  Reader copyWith({
    Id? id,
    String? nameChapter,
    double? offset,
    String? url,
    DateTime? time,
  }) {
    return Reader(
      id: id ?? this.id,
      nameChapter: nameChapter ?? this.nameChapter,
      offset: offset ?? this.offset,
      url: url ?? this.url,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameChapter': nameChapter,
      'offset': offset,
      'url': url,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Reader.fromMap(Map<String, dynamic> map) {
    return Reader(
      id: map['id'],
      nameChapter: map['nameChapter'] ?? "",
      offset: map['offset'] ?? 0.0,
      url: map['url'] ?? "",
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Reader.fromJson(String source) =>
      Reader.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reader(id: $id, nameChapter: $nameChapter, offset: $offset, url: $url, time: $time)';
  }

  @override
  bool operator ==(covariant Reader other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nameChapter == nameChapter &&
        other.offset == offset &&
        other.url == url &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nameChapter.hashCode ^
        offset.hashCode ^
        url.hashCode ^
        time.hashCode;
  }
}
