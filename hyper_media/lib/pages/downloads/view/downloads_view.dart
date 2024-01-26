import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/services/download_manager.dart';
import 'package:hyper_media/widgets/widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../data/models/models.dart';
import '../cubit/downloads_cubit.dart';

part 'downloads_page.dart';
part '../widgets/widgets.dart';
part '../widgets/download_completed.dart';
part '../widgets/downloading.dart';
part '../widgets/download_wait.dart';
part '../widgets/download_item.dart';


class DownloadsView extends StatelessWidget {
  const DownloadsView({super.key});
  static const String routeName = '/downloads_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DownloadsCubit(downloadService: getIt<DownloadManager>())..onInit(),
      child: const DownloadsPage(),
    );
  }
}
