// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';

import '../../reader/cubit/reader_cubit.dart';

part 'watch_movie_state.dart';

class WatchMovieCubit extends Cubit<WatchMovieState> {
  WatchMovieCubit({required ReaderCubit readerBookCubit})
      : _readerCubit = readerBookCubit,
        super(WatchMovieState(
            servers: [],
            watchChapter:
                readerBookCubit.chapters[readerBookCubit.watchInitial],
            status: StatusType.init));
  final ReaderCubit _readerCubit;

  void onInit() {
    getDetailChapter(state.watchChapter);
  }

  void getDetailChapter(Chapter chapter) async {
    try {
      if (chapter.contentComic != null && chapter.contentComic!.isNotEmpty) {
        emit(state.copyWith(watchChapter: chapter, status: StatusType.loaded));
      } else {
        emit(state.copyWith(watchChapter: chapter, status: StatusType.loading));
        chapter = await _readerCubit.getContentsChapter(chapter);
        List<MovieServer> servers = [];

        if (chapter.contentVideo != null) {
          for (int i = 0; i < chapter.contentVideo!.length; i++) {
            Map<String, dynamic> item = chapter.contentVideo![i];
            if (item["name"] == null) {
              item["name"] = "SV ${i + 1}";
            }
            servers.add(MovieServer.fromMap(item));
          }
        }
        emit(state.copyWith(
            watchChapter: chapter,
            servers: servers,
            status: StatusType.loaded));
      }
    } catch (error) {
      emit(state.copyWith(watchChapter: chapter, status: StatusType.error));
    }
  }
}

class MovieServer extends Equatable {
  final String name;
  final String data;
  final String type;
  final String regex;
  const MovieServer({
    required this.name,
    required this.data,
    required this.type,
    required this.regex,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'data': data,
      'type': type,
      'regex': regex,
    };
  }

  factory MovieServer.fromMap(Map<String, dynamic> map) {
    return MovieServer(
      name: map['name'] ?? "",
      data: map['data'] ?? "",
      type: map['type'] ?? "",
      regex: map['regex'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieServer.fromJson(String source) =>
      MovieServer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [name, data, type, regex];
}
