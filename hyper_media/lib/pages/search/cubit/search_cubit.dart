import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:js_runtime/js_runtime.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required Extension extension, required JsRuntime jsRuntime})
      : _extension = extension,
        _jsRuntime = jsRuntime,
        super(SearchState(status: StatusType.init, books: []));

  final Extension _extension;
  final JsRuntime _jsRuntime;
  late TextEditingController textEditingController;
  String? _message;
  void onInit() {
    textEditingController = TextEditingController();
  }

  void onSearch() async {
    try {
      _message = null;
      emit(state.copyWith(status: StatusType.loading));

      final result = await _jsRuntime.getSearch<List<dynamic>>(
          keyWord: textEditingController.text,
          url: _extension.metadata.source!,
          source: _extension.getSearchScript!);

      emit(state.copyWith(
          status: StatusType.loaded,
          books: result.map<Book>((e) => Book.fromMap(e)).toList()));
    } on JsRuntimeException catch (error) {
      _message = error.message;
      emit(state.copyWith(status: StatusType.error));
    } catch (error) {
      emit(state.copyWith(status: StatusType.error));
    }
  }

  Future<List<Book>> onLoadMoreSearch(int page) async {
    List<Book> books = [];
    try {
      final result = await _jsRuntime.getSearch<List<dynamic>>(
          keyWord: textEditingController.text,
          url: _extension.metadata.source!,
          source: _extension.getSearchScript!,
          page: page);
      books = result.map<Book>((e) => Book.fromMap(e)).toList();
    } catch (error) {
      //
    }
    return books;
  }
}
