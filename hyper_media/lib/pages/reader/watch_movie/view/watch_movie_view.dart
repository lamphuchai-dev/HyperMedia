import 'package:flutter/material.dart';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/utils/system_utils.dart';
import 'package:hyper_media/widgets/widget.dart';

import '../../reader/cubit/reader_cubit.dart';
import '../cubit/watch_movie_cubit.dart';

part './watch_movie_page.dart';
part '../widgets/episodes_widget.dart';
part '../widgets/servers_dialog.dart';
part '../widgets/watch_movie_iframe.dart';
part '../widgets/watch_movie_m3u8.dart';
part '../widgets/watch_movie_video.dart';

class WatchMovieView extends StatelessWidget {
  const WatchMovieView({super.key});
  static const String routeName = '/watch_movie_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WatchMovieCubit(readerBookCubit: context.read<ReaderCubit>())
            ..onInit(),
      child: const WatchMoviePage(),
    );
  }
}
