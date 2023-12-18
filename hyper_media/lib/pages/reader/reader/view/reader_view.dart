import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';

import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/pages/reader/watch_comic/watch_comic.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/system_utils.dart';
import 'package:hyper_media/widgets/widget.dart';

import '../../watch_movie/watch_movie.dart';
import '../../watch_novel/watch_novel.dart';
import '../cubit/reader_cubit.dart';


part 'reader_page.dart';

class ReaderView extends StatelessWidget {
  const ReaderView({super.key, required this.readerArgs});
  static const String routeName = '/reader_book_view';
  final ReaderArgs readerArgs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ReaderCubit(
            jsRuntime: getIt<JsRuntime>(),
            databaseUtils: getIt<DatabaseUtils>(),
            book: readerArgs.book,
            chapters: readerArgs.chapters)
          ..onInit(),
        child: const ReaderPage());
  }
}

class ReaderArgs {
  Book book;
  List<Chapter> chapters;
  ReaderArgs({required this.book, required this.chapters});
}
