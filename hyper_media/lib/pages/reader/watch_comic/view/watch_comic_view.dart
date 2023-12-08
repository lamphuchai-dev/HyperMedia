
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/download_service.dart';
import 'package:hyper_media/widgets/widget.dart';

import 'package:hyper_media/app/extensions/context_extension.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/reader/reader/cubit/reader_cubit.dart';

import '../cubit/watch_comic_cubit.dart';
import 'auto_scroll_widget.dart';

part 'watch_comic_page.dart';
part '../widgets/widgets.dart';
part '../widgets/item_image_comic.dart';
part '../widgets/settings_watch_comic.dart';
part '../widgets/menu_watch_comic.dart';
part '../widgets/chapters_bottom_sheet.dart';

part '../model/image_comic.dart';

class WatchComicView extends StatelessWidget {
  const WatchComicView({super.key});
  static const String routeName = '/watch_comic_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchComicCubit(
          database: getIt<DatabaseUtils>(),
          downloadService: getIt<DownloadService>(),
          readerCubit: context.read<ReaderCubit>())
        ..onInit(),
      child: const WatchComicPage(),
    );
  }
}
