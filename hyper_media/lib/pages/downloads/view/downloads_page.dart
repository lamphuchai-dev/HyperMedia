part of 'downloads_view.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  late DownloadsCubit _downloadsCubit;
  @override
  void initState() {
    _downloadsCubit = context.read<DownloadsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Downloads")),
        body: Column(
          children: [
            BlocSelector<DownloadsCubit, DownloadsState, Download?>(
              selector: (state) {
                return state.currentDownload;
              },
              builder: (context, currentDownload) {
                if (currentDownload == null) {
                  return const SizedBox();
                }
                return ListTile(
                  title: Text(currentDownload.bookName),
                  subtitle: Text(
                      "${currentDownload.totalChaptersToDownload}/${currentDownload.totalChaptersDownloaded}"),
                  trailing: IconButton(
                    onPressed: () {
                      _downloadsCubit.closeDownload();
                    },
                    icon: const Icon(Icons.close),
                  ),
                );
              },
            ),
            Expanded(
                child: Column(
              children: [],
            ))
            // BlocSelector<DownloadsCubit, DownloadsState, List<Download>>(
            //   selector: (state) {
            //     return state.waitingDownload;
            //   },
            //   builder: (context, downloads) {
            //     if (downloads.isEmpty) {
            //       return const SizedBox();
            //     }
            //     return Column(
            //       children: [
            //         const Text("Đang chờ"),
            //         ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: downloads.length,
            //           itemBuilder: (context, index) {
            //             final download = downloads[index];
            //             return ListTile(
            //               title: Text(download.bookName),
            //               subtitle: Text(
            //                   "${download.totalChaptersDownloaded}/${download.totalChaptersToDownload}"),
            //             );
            //           },
            //         )
            //       ],
            //     );
            //   },
            // ),
            // BlocSelector<DownloadsCubit, DownloadsState, List<Download>>(
            //   selector: (state) {
            //     return state.downloaded;
            //   },
            //   builder: (context, downloads) {
            //     if (downloads.isEmpty) {
            //       return const SizedBox();
            //     }
            //     return Column(
            //       children: [
            //         const Text("Hoàn thành"),
            //         ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: downloads.length,
            //           itemBuilder: (context, index) {
            //             final download = downloads[index];
            //             return ListTile(
            //               title: Text(download.bookName),
            //               subtitle: Text(
            //                   "${download.totalChaptersDownloaded}/${download.totalChaptersToDownload}"),
            //             );
            //           },
            //         )
            //       ],
            //     );
            //   },
            // )
          ],
        ));
  }
}

class DownloadItem extends StatelessWidget {
  const DownloadItem({super.key, required this.download});
  final Download download;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
