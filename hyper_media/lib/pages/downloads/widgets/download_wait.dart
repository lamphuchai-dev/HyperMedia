part of '../view/downloads_view.dart';

class WaitDownload extends StatelessWidget {
  const WaitDownload({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DownloadsCubit, DownloadsState, List<Download>>(
      selector: (state) => state.waitingDownload,
      builder: (context, waitingDownload) {
        if (waitingDownload.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox(),
          );
        }

        return MultiSliver(
          children: <Widget>[
            const SliverToBoxAdapter(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Đang chờ"),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => DownloadItem(
                  download: waitingDownload[index],
                  onTapDelete: () {
                    context
                        .read<DownloadsCubit>()
                        .onCancelDownload(waitingDownload[index]);
                  },
                  onTapItem: () {},
                ),
                childCount: waitingDownload.length,
              ),
            )
          ],
        );
      },
    );
  }
}
