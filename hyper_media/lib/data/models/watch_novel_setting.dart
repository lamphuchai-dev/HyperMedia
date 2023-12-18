// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum WatchNovelType { vertical, horizontal }

class WatchNovelSetting extends Equatable {
  final ThemeWatchNovel themeWatchNovel;
  final double fontSize;
  final double textScaleFactor;
  final WatchNovelType watchType;
  const WatchNovelSetting({
    required this.themeWatchNovel,
    required this.fontSize,
    required this.textScaleFactor,
    required this.watchType,
  });

  factory WatchNovelSetting.init() {
    return const WatchNovelSetting(
        themeWatchNovel: ThemeWatchNovel(
            background: Color(0xffffffff), text: Color(0xff000000)),
        fontSize: 16,
        textScaleFactor: 1,
        watchType: WatchNovelType.vertical);
  }

  static List<ThemeWatchNovel> listMap() {
    return [
      const ThemeWatchNovel(
          background: Color(0xff000000), text: Color(0xffffffc0)),
      const ThemeWatchNovel(
          background: Color(0xffffffff), text: Color(0xff000000)),
      const ThemeWatchNovel(
          background: Color(0xfffafafa), text: Color(0xff333333)),
      const ThemeWatchNovel(
          background: Color(0xff303030), text: Color(0xffbbbbbb)),
      const ThemeWatchNovel(
          background: Color(0xff101010), text: Color(0xffcccccc)),
      const ThemeWatchNovel(
          background: Color(0xff000000), text: Color(0xffffffff)),
      const ThemeWatchNovel(
          background: Color(0xffffff00), text: Color(0xff000000)),
      const ThemeWatchNovel(
          background: Color(0xffff00ff), text: Color(0xff000000)),
      const ThemeWatchNovel(
          background: Color(0xff00ffff), text: Color(0xff000000)),
      const ThemeWatchNovel(
          background: Color(0xff0000ff), text: Color(0xffffffff)),
      const ThemeWatchNovel(
          background: Color(0xffff0000), text: Color(0xffffffff)),
      const ThemeWatchNovel(
          background: Color(0xff00ff00), text: Color(0xff000000)),
      const ThemeWatchNovel(
          background: Color(0xff993333), text: Color(0xffffffc0)),
      const ThemeWatchNovel(
          background: Color(0xff339933), text: Color(0xffffffc0)),
      const ThemeWatchNovel(
          background: Color(0xff333399), text: Color(0xffffffc0)),
      const ThemeWatchNovel(
          background: Color(0xff333333), text: Color(0xffffff00)),
      const ThemeWatchNovel(
          background: Color(0xff999900), text: Color(0xff000000)),
      const ThemeWatchNovel(
          background: Color(0xff990099), text: Color(0xff000000)),
      const ThemeWatchNovel(
          background: Color(0xff009999), text: Color(0xff000000))
    ];
  }

  WatchNovelSetting copyWith({
    ThemeWatchNovel? themeWatchNovel,
    double? fontSize,
    double? textScaleFactor,
    WatchNovelType? watchType,
  }) {
    return WatchNovelSetting(
      themeWatchNovel: themeWatchNovel ?? this.themeWatchNovel,
      fontSize: fontSize ?? this.fontSize,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      watchType: watchType ?? this.watchType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeWatchNovel': themeWatchNovel.toMap(),
      'fontSize': fontSize,
      'textScaleFactor': textScaleFactor,
      'watchType': watchType.name,
    };
  }

  factory WatchNovelSetting.fromMap(Map<String, dynamic> map) {
    return WatchNovelSetting(
      themeWatchNovel:
          ThemeWatchNovel.fromMap(Map.from(map['themeWatchNovel'])),
      fontSize: map['fontSize'] as double,
      textScaleFactor: map['textScaleFactor'] as double,
      watchType: WatchNovelType.values.firstWhere(
        (e) => e.name == map['watchType'],
        orElse: () => WatchNovelType.vertical,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchNovelSetting.fromJson(String source) =>
      WatchNovelSetting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [themeWatchNovel, fontSize, textScaleFactor, watchType];
}
//brightness
// background
// textColor,
// fontSize
// textScaleFactor
// watchType

class ThemeWatchNovel extends Equatable {
  final Color background;
  final Color text;
  const ThemeWatchNovel({
    required this.background,
    required this.text,
  });

  ThemeWatchNovel copyWith({
    Color? background,
    Color? text,
  }) {
    return ThemeWatchNovel(
      background: background ?? this.background,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'background': background.value,
      'text': text.value,
    };
  }

  factory ThemeWatchNovel.fromMap(Map<String, dynamic> map) {
    return ThemeWatchNovel(
      background: Color(map['background'] as int),
      text: Color(map['text'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeWatchNovel.fromJson(String source) =>
      ThemeWatchNovel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [background, text];
}
