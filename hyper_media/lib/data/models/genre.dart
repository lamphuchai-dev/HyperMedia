// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class Genre {
  final String? title;
  final String? url;
  Genre({
    this.title,
    this.url,
  });

  Genre copyWith({
    String? title,
    String? url,
  }) {
    return Genre(
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
    };
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      title: map['title'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Genre.fromJson(String source) =>
      Genre.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Genre(title: $title, url: $url)';

  @override
  bool operator ==(covariant Genre other) {
    if (identical(this, other)) return true;

    return other.title == title && other.url == url;
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}
