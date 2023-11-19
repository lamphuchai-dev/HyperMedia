import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:js_runtime/js_runtime.dart';

part 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  GenreCubit({
    required JsRuntime jsRuntime,
    required Extension extension,
    required Genre genre,
  })  : _jsRuntime = jsRuntime,
        _extension = extension,
        _genre = genre,
        super(GenreInitial());
  final JsRuntime _jsRuntime;
  final Extension _extension;
  final Genre _genre;
  void onInit() {}

  Future<List<Book>> onGetListBook(int page) async {
    try {
      final result = await _jsRuntime.getList(
          url: _genre.url!, page: page, source: _extension.getHomeScript);
      if (result is SuccessJsRuntime) {
        return result.data.map<Book>((e) => Book.fromMap(e)).toList();
      }
      return [];
    } catch (error) {
      //
    }
    return [];
  }

  String get titleGenre => _genre.title!;
}
