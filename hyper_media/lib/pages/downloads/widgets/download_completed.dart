part of '../view/downloads_view.dart';

class DownloadCompleted extends StatelessWidget {
  const DownloadCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return BlocSelector<DownloadsCubit, DownloadsState, List<Download>>(
      selector: (state) => state.downloaded,
      builder: (context, downloaded) {
        if (downloaded.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox(),
          );
        }
        return MultiSliver(
          children: <Widget>[
            BlocBuilder<DownloadsCubit, DownloadsState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                if (state.currentDownload != null ||
                    state.waitingDownload.isNotEmpty) {
                  return SliverPinnedHeader(
                    child: ColoredBox(
                      color: colorScheme.background,
                      child: const ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Tải hoàn thành"),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(
                  child: SizedBox(),
                );
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => DownloadItem(
                  download: downloaded[index],
                  onTapDelete: () {
                    context
                        .read<DownloadsCubit>()
                        .onTapDeleteById(downloaded[index].id!);
                  },
                  onTapItem: () {},
                ),
                childCount: downloaded.length,
              ),
            )
          ],
        );
      },
    );
  }
}
