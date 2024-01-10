import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/services/download_manager.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/download_service.dart';
import 'package:hyper_media/utils/logger.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(
      {required DatabaseUtils database,
      required DownloadManager downloadService})
      : _database = database,
        _downloadService = downloadService,
        super(const LibraryState(books: [], status: StatusType.init)) {
    _bookmarkStreamSubscription = database.books.listen((_) {
      onInit();
    });
  }

  final DownloadManager _downloadService;

  final _logger = Logger("LibraryCubit");

  late StreamSubscription _bookmarkStreamSubscription;

  final DatabaseUtils _database;
  void onInit() async {
    try {
      emit(state.copyWith(status: StatusType.loading));
      List<Book> books = await _database.getBooks();
      emit(state.copyWith(status: StatusType.loaded, books: books));
    } catch (error) {
      _logger.error(error, name: "onInit");
      emit(state.copyWith(status: StatusType.error));
    }
  }

  void delete(Book book) async {
    _database.onDeleteBook(book.id!);

    // final bookmark = getBookmarkByBook(book);
    // _database.deleteBookmarkById(
    //     id: bookmark.id!,
    //     bookId: bookmark.book.value?.id,
    //     readerId: bookmark.reader.value?.id,
    //     chapterIds: bookmark.chapters.map((e) => e.id!).toList());
  }

  void onDownload(Book book) async {
    _downloadService.addDownload(book);
  }

  @override
  Future<void> close() {
    _bookmarkStreamSubscription.cancel();
    return super.close();
  }
}
