// import 'dart:ui' as ui;

import 'dart:ui' as ui;
// import 'package:easy_localization/easy_localization.dart' hide TextDirection;

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/system_utils.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../../reader/cubit/reader_cubit.dart';
import '../cubit/watch_novel_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
part 'watch_novel_page.dart';
part '../widgets/settings_watch_novel.dart';
part '../widgets/menu_watch_novel.dart';
part "../widgets/chapters_drawer.dart";

class WatchNovelView extends StatelessWidget {
  const WatchNovelView({super.key});
  static const String routeName = '/watch_novel_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchNovelCubit(
          readerBookCubit: context.read<ReaderCubit>(),
          database: getIt<DatabaseUtils>())
        ..onInit(),
      child: const WatchNovelPage(),
    );
  }
}
