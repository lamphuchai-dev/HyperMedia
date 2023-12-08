// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

enum WatchComicType { vertical, horizontal, webtoon }

enum WatchBackground { light, dark }

enum WatchOrientation { auto, portrait, landscape }

class WatchComicSettings extends Equatable {
  final WatchComicType watchType;
  final WatchBackground background;
  final WatchOrientation orientation;
  final bool longPressImage;
  final bool onTapControl;
  const WatchComicSettings({
    required this.watchType,
    required this.background,
    required this.orientation,
    required this.longPressImage,
    required this.onTapControl,
  });

  factory WatchComicSettings.init() => const WatchComicSettings(
      watchType: WatchComicType.webtoon,
      background: WatchBackground.dark,
      orientation: WatchOrientation.portrait,
      longPressImage: true,
      onTapControl: true);

  WatchComicSettings copyWith({
    WatchComicType? watchType,
    WatchBackground? background,
    WatchOrientation? orientation,
    bool? longPressImage,
    bool? onTapControl,
  }) {
    return WatchComicSettings(
      watchType: watchType ?? this.watchType,
      background: background ?? this.background,
      orientation: orientation ?? this.orientation,
      longPressImage: longPressImage ?? this.longPressImage,
      onTapControl: onTapControl ?? this.onTapControl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'watchType': watchType.name,
      'background': background.name,
      'orientation': orientation.name,
      'longPressImage': longPressImage,
      'onTapControl': onTapControl,
    };
  }

  factory WatchComicSettings.fromMap(Map<String, dynamic> map) {
    return WatchComicSettings(
        watchType: WatchComicType.values.firstWhere(
            (element) => element.name == map['watchType'],
            orElse: () => WatchComicType.webtoon),
        background: WatchBackground.values.firstWhere(
            (element) => element.name == map['background'],
            orElse: () => WatchBackground.dark),
        orientation: WatchOrientation.values.firstWhere(
            (element) => element.name == map['orientation'],
            orElse: () => WatchOrientation.portrait),
        longPressImage: map['longPressImage'] ?? true,
        onTapControl: map['onTapControl'] ?? true);
  }

  String toJson() => json.encode(toMap());

  factory WatchComicSettings.fromJson(String source) =>
      WatchComicSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props =>
      [watchType, background, orientation, longPressImage, onTapControl];

  @override
  bool get stringify => true;
}
