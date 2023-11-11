import 'package:flutter/material.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:js_runtime/js_runtime.dart';
import '../cubit/reader_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reader_page.dart';

class ReaderView extends StatelessWidget {
  const ReaderView({super.key, required this.readerArgs});
  static const String routeName = '/reader_view';
  final ReaderArgs readerArgs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReaderCubit(
          jsRuntime: getIt<JsRuntime>(),
          databaseUtils: getIt<DatabaseUtils>(),
          book: readerArgs.book)
        ..onInit(
            chapters: readerArgs.chapters,
            initReadChapter: readerArgs.readChapter),
      child: const ReaderPage(),
    );
  }
}

class ReaderArgs {
  Book book;
  int readChapter;
  List<Chapter> chapters;
  ReaderArgs(
      {required this.book, this.readChapter = 0, required this.chapters});
}
