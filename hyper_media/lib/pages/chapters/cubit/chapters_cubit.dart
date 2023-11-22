import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/logger.dart';
import 'package:js_runtime/js_runtime.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit(
      {required this.book,
      required this.extensionModel,
      required JsRuntime jsRuntime})
      : _jsRuntime = jsRuntime,
        super(const ChaptersState(
            chapters: [],
            statusType: StatusType.init,
            sortType: SortChapterType.newChapter));
  final _logger = Logger("ChaptersCubit");
  final Book book;
  final JsRuntime _jsRuntime;

  final Extension extensionModel;

  void onInit() async {
    emit(state.copyWith(statusType: StatusType.loading));
    try {
      final result = await _jsRuntime.getChapters<List<dynamic>>(
          url: book.bookUrl, source: extensionModel.getChaptersScript);
      List<Chapter> chapters = [];
      for (var i = 0; i < result.length; i++) {
        final map = result[i];
        if (map is Map<String, dynamic>) {
          if (book.id != null) {
            chapters
                .add(Chapter.fromMap({...map, "index": i, "bookId": book.id}));
          } else {
            chapters.add(Chapter.fromMap({...map, "index": i}));
          }
        }
      }
      emit(state.copyWith(
          chapters: chapters,
          sortType: SortChapterType.lastChapter,
          statusType: StatusType.loaded));
    } on JsRuntimeException catch (error) {
      _logger.log(error.message);
    } catch (error) {
      if (isClosed) return;
      emit(state.copyWith(statusType: StatusType.error));
      _logger.error(error, name: "onInit");
    }
  }

  void sortChapterType(SortChapterType type) {
    final chapters = sort(state.chapters, type);
    emit(state.copyWith(chapters: chapters, sortType: type));
  }

  List<Chapter> sort(List<Chapter> list, SortChapterType type) {
    if (type == SortChapterType.newChapter) {
      list.sort((a, b) => b.index.compareTo(a.index));
    } else {
      list.sort((a, b) => a.index.compareTo(b.index));
    }
    return list;
  }
}
