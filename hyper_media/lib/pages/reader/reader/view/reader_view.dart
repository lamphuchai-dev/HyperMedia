import 'package:flutter/material.dart';
import 'package:hyper_media/data/models/bookmark.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/data/models/reader.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:js_runtime/js_runtime.dart';
import '../cubit/reader_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reader_page.dart';

class ReaderView extends StatelessWidget {
  const ReaderView({super.key, this.readerArgs, this.bookmark});
  static const String routeName = '/reader_book_view';
  final ReaderArgs? readerArgs;
  final Bookmark? bookmark;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ReaderCubit(
            jsRuntime: getIt<JsRuntime>(),
            databaseUtils: getIt<DatabaseUtils>(),
            book: bookmark != null ? bookmark!.book.value! : readerArgs!.book,
            chapters: bookmark != null
                ? bookmark!.chapters.toList()
                : readerArgs!.chapters)
          ..onInit(
              bookmark != null ? bookmark!.reader.value! : readerArgs!.reader),
        child: const ReaderPage());
  }
}

class ReaderArgs {
  Book book;
  Reader reader;
  List<Chapter> chapters;
  ReaderArgs(
      {required this.book, required this.reader, required this.chapters});
}
