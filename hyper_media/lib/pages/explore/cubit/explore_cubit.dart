import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/logger.dart';
import 'package:js_runtime/js_runtime.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required DatabaseUtils database, required JsRuntime jsRuntime})
      : _database = database,
        _jsRuntime = jsRuntime,
        super(ExploreInitial()) {
    _extensionsStreamSubscription =
        _database.extensionsChange.listen((_) async {
      final state = this.state;
      if (state is ExploreExtensionNull) {
        final ext = await _database.getExtensionFirst;
        if (ext != null) {
          emit(ExploreExtensionLoaded(
              extension: ext, tabs: const [], status: StatusType.loading));
        }
      } else if (state is ExploreExtensionLoaded) {
        final ext = await _database.getExtensionFirst;
        if (ext == null) {
          emit(ExploreExtensionNull());
        }
      }
    });
  }
  final DatabaseUtils _database;
  final JsRuntime _jsRuntime;
  final _logger = Logger("ExploreCubit");

  late StreamSubscription _extensionsStreamSubscription;

  void onInit() async {
    try {
      emit(ExploreExtensionLoading());
      final extension = await _database.getExtensionFirst;
      if (extension == null) {
        emit(ExploreExtensionNull());
      } else {
        emit(ExploreExtensionLoaded(
            extension: extension, tabs: const [], status: StatusType.loading));
        getTabsByExtension();
      }
    } catch (error) {
      emit(const ExploreExtensionError("Loading extension error"));
    }
  }

  Future<List<Extension>> get getExtensions => _database.getExtensions;

  void getTabsByExtension() async {
    final state = this.state;
    if (state is! ExploreExtensionLoaded) return;

    try {
      emit(state.copyWith(status: StatusType.loading));

      final result = await _jsRuntime.getTabs(state.extension.getTabsScript);
      final tabs = result
          .map(
            (e) => ItemTabExplore.fromMap(e),
          )
          .toList();

      emit(state.copyWith(status: StatusType.loaded, tabs: tabs));
    } catch (error) {
      emit(state.copyWith(status: StatusType.error));
    }
  }

  Future<List<Book>> onGetListBook(String url, int page) async {
    final state = this.state;
    if (state is! ExploreExtensionLoaded) return [];

    try {
      url = "${state.extension.source}$url";
      final result = await _jsRuntime.getList(
        url: url,
        page: page,
        source: state.extension.getHomeScript,
      );

      return result.map((e) => Book.fromMap(e)).toList();
    } catch (error) {
      _logger.error(error, name: "onGetListBook");
    }
    return [];
  }

  Future<List<Genre>> onGetListGenre() async {
    final state = this.state;
    if (state is! ExploreExtensionLoaded) return [];

    try {
      final result = await _jsRuntime.getGenre(
          url: state.extension.source, source: state.extension.getGenreScript!);
      return [];
    } catch (error) {
      _logger.error(error, name: "onGetListGenre");
    }
    return [];
  }

  onChangeExtension(Extension extension) async {
    // _jsRuntime.clearBrowser();
    emit(ExploreExtensionLoaded(
        extension: extension, tabs: const [], status: StatusType.loading));
    await Future.delayed(const Duration(milliseconds: 50));
    getTabsByExtension();
    _database.updateExtension(extension.copyWith(updateAt: DateTime.now()));
  }

  @override
  Future<void> close() {
    _extensionsStreamSubscription.cancel();
    return super.close();
  }
}
