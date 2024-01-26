part of '../view/downloads_view.dart';

class Downloading extends StatelessWidget {
  const Downloading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DownloadsCubit, DownloadsState, Download?>(
      selector: (state) => state.currentDownload,
      builder: (context, currentDownload) {
        if (currentDownload == null) {
          return const SliverToBoxAdapter(
            child: SizedBox(),
          );
        }

        return SliverToBoxAdapter(
          child: Column(
            children: [
              const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Đang tải"),
              ),
              DownloadItem(
                download: currentDownload,
                onTapDelete: () {
                  context.read<DownloadsCubit>().closeCurrentDownload();
                },
                onTapItem: () {},
              )
            ],
          ),
        );
      },
    );
  }
}
