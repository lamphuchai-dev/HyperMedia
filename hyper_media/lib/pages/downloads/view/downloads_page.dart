part of 'downloads_view.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Downloads")),
        body: const CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
              sliver: Downloading(),
            ),
            SliverPadding(
              padding:
                  EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
              sliver: WaitDownload(),
            ),
            SliverPadding(
              padding:
                  EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
              sliver: DownloadCompleted(),
            ),
          ],
        ));
  }
}
