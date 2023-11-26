import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/logger.dart';

import '../../../data/models/bookmark.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit({required DatabaseUtils database})
      : _database = database,
        super(const LibraryState(bookmarks: [], status: StatusType.init)) {
    _bookmarkStreamSubscription = database.bookmark.listen((_) {
      onInit();
    });
    _readerStreamSubscription = database.reader.listen((_) {
      onInit();
    });
  }

  final _logger = Logger("LibraryCubit");

  late StreamSubscription _bookmarkStreamSubscription;
  late StreamSubscription _readerStreamSubscription;

  final DatabaseUtils _database;
  void onInit() async {
    try {
      emit(state.copyWith(status: StatusType.loading));
      List<Bookmark> bookmarks = await _database.getBookmarks;
      bookmarks = bookmarks.sorted(
          (a, b) => b.reader.value!.time.compareTo(a.reader.value!.time));
      emit(state.copyWith(status: StatusType.loaded, bookmarks: bookmarks));
    } catch (error) {
      _logger.error(error, name: "onInit");
      emit(state.copyWith(status: StatusType.error));
    }
  }

  List<Book> get books => state.bookmarks.map((e) => e.book.value!).toList();

  Bookmark getBookmarkByBook(Book book) {
    return state.bookmarks
        .firstWhereOrNull((element) => element.book.value!.id == book.id)!;
  }

  void delete(Book book) {
    final bookmark = getBookmarkByBook(book);
    _database.deleteBookmarkById(
        id: bookmark.id!,
        bookId: bookmark.book.value?.id,
        readerId: bookmark.reader.value?.id,
        chapterIds: bookmark.chapters.map((e) => e.id!).toList());
  }

  @override
  Future<void> close() {
    _bookmarkStreamSubscription.cancel();
    _readerStreamSubscription.cancel();
    return super.close();
  }
}
