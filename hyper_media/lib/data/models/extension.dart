// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

import 'package:hyper_media/app/types/app_type.dart';

part 'extension.g.dart';

@Collection()
class Extension {
  Id? id;
  final Metadata metadata;
  final Script script;
  final DateTime updateAt;
  Extension(
      {this.id,
      required this.metadata,
      required this.script,
      required this.updateAt});

  Extension copyWith(
      {Id? id, Metadata? metadata, Script? script, DateTime? updateAt}) {
    return Extension(
        id: id ?? this.id,
        metadata: metadata ?? this.metadata,
        script: script ?? this.script,
        updateAt: updateAt ?? this.updateAt);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'metadata': metadata.toMap(),
      'script': script.toMap(),
    };
  }

  factory Extension.fromMap(Map<String, dynamic> map) {
    return Extension(
        id: map["id"],
        metadata: Metadata.fromMap(map['metadata'] as Map<String, dynamic>),
        script: Script.fromMap(map['script'] as Map<String, dynamic>),
        updateAt: map["updateAt"] ?? DateTime.now());
  }

  String toJson() => json.encode(toMap());

  factory Extension.fromJson(String source) =>
      Extension.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Extension(metadata: $metadata, script: $script)';

  @override
  bool operator ==(covariant Extension other) {
    if (identical(this, other)) return true;

    return other.metadata == metadata && other.script == script;
  }

  @override
  int get hashCode => metadata.hashCode ^ script.hashCode;
}

extension ExtExtension on Extension {
  String get source => metadata.source!;
  String get getTabsScript => script.tabs!;
  String get getHomeScript => script.home!;
  String get getDetailScript => script.detail!;
  String get getChaptersScript => script.chapters!;
  String get getChapterScript => script.chapter!;
  String? get getGenreScript => script.genre;
  String? get getSearchScript => script.search;
}

@embedded
class Script {
  String? tabs;
  String? home;
  String? detail;
  String? chapters;
  String? chapter;
  String? search;
  String? genre;
  Script({
    this.tabs,
    this.home,
    this.detail,
    this.chapters,
    this.chapter,
    this.search,
    this.genre,
  });

  Script copyWith({
    String? tabs,
    String? home,
    String? detail,
    String? chapters,
    String? chapter,
    String? search,
    String? genre,
  }) {
    return Script(
      tabs: tabs ?? this.tabs,
      home: home ?? this.home,
      detail: detail ?? this.detail,
      chapters: chapters ?? this.chapters,
      chapter: chapter ?? this.chapter,
      search: search ?? this.search,
      genre: genre ?? this.genre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tabs': tabs,
      'home': home,
      'detail': detail,
      'chapters': chapters,
      'chapter': chapter,
      'search': search,
      'genre': genre,
    };
  }

  factory Script.fromMap(Map<String, dynamic> map) {
    return Script(
      tabs: map['tabs'] != null ? map['tabs'] as String : null,
      home: map['home'] != null ? map['home'] as String : null,
      detail: map['detail'] != null ? map['detail'] as String : null,
      chapters: map['chapters'] != null ? map['chapters'] as String : null,
      chapter: map['chapter'] != null ? map['chapter'] as String : null,
      search: map['search'] != null ? map['search'] as String : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Script.fromJson(String source) =>
      Script.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Script(tabs: $tabs, home: $home, detail: $detail, chapters: $chapters, chapter: $chapter, search: $search, genre: $genre)';
  }

  @override
  bool operator ==(covariant Script other) {
    if (identical(this, other)) return true;

    return other.tabs == tabs &&
        other.home == home &&
        other.detail == detail &&
        other.chapters == chapters &&
        other.chapter == chapter &&
        other.search == search &&
        other.genre == genre;
  }

  @override
  int get hashCode {
    return tabs.hashCode ^
        home.hashCode ^
        detail.hashCode ^
        chapters.hashCode ^
        chapter.hashCode ^
        search.hashCode ^
        genre.hashCode;
  }
}

@embedded
class Metadata {
  String? name;
  String? author;
  int? version;
  String? source;
  String? regexp;
  String? description;
  String? locale;
  String? language;
  @Enumerated(EnumType.name)
  ExtensionType? type;
  String? path;
  String? icon;
  String? tag;
  Metadata(
      {this.name,
      this.author,
      this.version,
      this.source,
      this.regexp,
      this.description,
      this.locale,
      this.language,
      this.type,
      this.path,
      this.icon,
      this.tag});

  Metadata copyWith({
    String? name,
    String? author,
    String? slug,
    int? version,
    String? source,
    String? regexp,
    String? description,
    String? locale,
    String? language,
    ExtensionType? type,
    String? path,
    String? icon,
    String? tag,
  }) {
    return Metadata(
        name: name ?? this.name,
        author: author ?? this.author,
        version: version ?? this.version,
        source: source ?? this.source,
        regexp: regexp ?? this.regexp,
        description: description ?? this.description,
        locale: locale ?? this.locale,
        language: language ?? this.language,
        type: type ?? this.type,
        path: path ?? this.path,
        icon: icon ?? this.icon,
        tag: tag ?? this.tag);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'author': author,
      'version': version,
      'source': source,
      'regexp': regexp,
      'description': description,
      'locale': locale,
      'language': language,
      'type': type?.name,
      'path': path,
      'icon': icon,
      'tag': tag,
    };
  }

  factory Metadata.fromMap(Map<String, dynamic> map) {
    return Metadata(
      name: map['name']??"",
      author: map['author']??"",
      version: map['version'] as int,
      source: map['source']??"",
      regexp: map['regexp']??"",
      description: map['description']??"",
      locale: map['locale']??"",
      language: map['language']??"",
      type: ExtensionType.values.firstWhere(
        (type) => type.name == map["type"],
        orElse: () => ExtensionType.novel,
      ),
      path: map['path'] ?? "",
      icon: map['icon'] ?? "",
      tag: map['tag'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Metadata.fromJson(String source) =>
      Metadata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Metadata other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.author == author &&
        other.version == version &&
        other.source == source &&
        other.regexp == regexp &&
        other.description == description &&
        other.locale == locale &&
        other.language == language &&
        other.type == type &&
        other.path == path &&
        other.icon == icon &&
        other.tag == tag;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        author.hashCode ^
        version.hashCode ^
        source.hashCode ^
        regexp.hashCode ^
        description.hashCode ^
        locale.hashCode ^
        language.hashCode ^
        type.hashCode ^
        path.hashCode ^
        icon.hashCode ^
        tag.hashCode;
  }

  @override
  String toString() {
    return 'Metadata(name: $name, author: $author, version: $version, source: $source, regexp: $regexp, description: $description, locale: $locale, language: $language, type: $type, path: $path, icon: $icon, tag: $tag)';
  }
}
