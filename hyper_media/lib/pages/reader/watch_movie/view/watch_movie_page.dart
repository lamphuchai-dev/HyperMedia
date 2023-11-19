import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/reader/reader/cubit/reader_cubit.dart';
import 'package:hyper_media/pages/reader/watch_movie/widgets/widgets.dart';
import 'package:hyper_media/widgets/loading_widget.dart';
import '../cubit/watch_movie_cubit.dart';

class WatchMoviePage extends StatefulWidget {
  const WatchMoviePage({super.key});

  @override
  State<WatchMoviePage> createState() => _WatchMoviePageState();
}

class _WatchMoviePageState extends State<WatchMoviePage> {
  late WatchMovieCubit _watchMovieCubit;
  @override
  void initState() {
    _watchMovieCubit = context.read<WatchMovieCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: BlocSelector<WatchMovieCubit, WatchMovieState, Chapter>(
          selector: (state) => state.watchChapter,
          builder: (context, chapter) => Text(chapter.name),
        ),
        actions: [
          BlocSelector<WatchMovieCubit, WatchMovieState, MovieServer?>(
            selector: (state) {
              return state.server;
            },
            builder: (context, server) {
              if (server == null) return const SizedBox();
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SelectServerBottomSheet(
                        servers: _watchMovieCubit.servers,
                        current: server,
                        onChange: _watchMovieCubit.onChangeServer,
                      );
                    },
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  constraints: BoxConstraints(maxWidth: context.width * 0.4),
                  decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.primary),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    server.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
          Gaps.wGap4,
          BlocSelector<WatchMovieCubit, WatchMovieState, Chapter>(
            selector: (state) {
              return state.watchChapter;
            },
            builder: (context, chapter) {
              return IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      elevation: 0,
                      enableDrag: false,
                      clipBehavior: Clip.hardEdge,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ChaptersBottomSheet(
                        readerCubit: context.read<ReaderCubit>(),
                        currentIndex: chapter.index,
                        onTapChapter: _watchMovieCubit.onChangeChapter,
                      ),
                    );
                  },
                  icon: const Icon(Icons.list_rounded));
            },
          ),
          Gaps.wGap4,
        ],
      ),
      body: BlocBuilder<WatchMovieCubit, WatchMovieState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return switch (state.status) {
            StatusType.loading => const LoadingWidget(),
            StatusType.loaded =>
              BlocSelector<WatchMovieCubit, WatchMovieState, MovieServer?>(
                selector: (state) {
                  return state.server;
                },
                builder: (context, server) {
                  if (server == null) {
                    return const Center(
                      child: Text("Có lỗi khi lấy nội dung"),
                    );
                  }
                  return switch (server.type) {
                    "video" => WatchMovieByVideo(server: server),
                    "iframe" => WatchMovieByIframe(server: server),
                    "m3u8" => WatchMovieByM3u8(server: server),
                    _ => const Center(
                        child: Text("Trình phát chưa được hỗ trợ"),
                      ),
                  };
                },
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
