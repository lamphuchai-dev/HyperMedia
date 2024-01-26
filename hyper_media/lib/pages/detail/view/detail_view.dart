import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/services/download_manager.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:readmore/readmore.dart';

import 'package:hyper_media/app/bloc/app_cubit/app_cubit_cubit.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/context_extension.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/pages/genre/genre.dart';
import 'package:hyper_media/pages/reader/reader/reader.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/widgets/widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../cubit/detail_cubit.dart';
part 'detail_page.dart';

part '../widgets/detail_error_view.dart';
part '../widgets/book_detail.dart';
part '../widgets/chapter_search_delegate.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.bookUrl});
  static const String routeName = '/detail_view';
  final String bookUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailCubit(
          bookUrl: bookUrl,
          databaseService: getIt<DatabaseUtils>(),
          appCubitCubit: context.read<AppCubitCubit>(),
          jsRuntime: getIt<JsRuntime>(),
          downloadService: getIt<DownloadManager>()),
      child: const DetailPage(),
    );
  }
}
