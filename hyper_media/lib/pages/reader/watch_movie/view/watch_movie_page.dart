

part of 'watch_movie_view.dart';

class WatchMoviePage extends StatefulWidget {
  const WatchMoviePage({super.key});

  @override
  State<WatchMoviePage> createState() => _WatchMoviePageState();
}

class _WatchMoviePageState extends State<WatchMoviePage> {
  late WatchMovieCubit _watchMovieCubit;
  late ScrollController _scrollController;
  @override
  void initState() {
    _watchMovieCubit = context.read<WatchMovieCubit>();
    _scrollController = ScrollController();
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
                  showDialog(
                    context: context,
                    builder: (context) => ServersDialog(
                      servers: _watchMovieCubit.servers,
                      current: server,
                      onChange: _watchMovieCubit.onChangeServer,
                    ),
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
          IconButton(
              onPressed: () {
                _watchMovieCubit
                    .getDetailChapter(_watchMovieCubit.state.watchChapter);
              },
              icon: const Icon(Icons.refresh_rounded)),
          Gaps.wGap4,
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ColoredBox(
                color: Colors.black,
                child: BlocBuilder<WatchMovieCubit, WatchMovieState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return switch (state.status) {
                      StatusType.loading => const LoadingWidget(),
                      StatusType.loaded => BlocSelector<WatchMovieCubit,
                            WatchMovieState, MovieServer?>(
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
              ),
            ),
            Gaps.hGap12,
            EpisodesWidget(
              onTapChapter: (chapter) {
                _scrollController.jumpTo(0);
                _watchMovieCubit.onChangeChapter(chapter);
              },
            )
          ],
        ),
      ),
    );
  }
}
