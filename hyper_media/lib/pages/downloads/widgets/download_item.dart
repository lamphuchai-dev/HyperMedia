part of '../view/downloads_view.dart';

class DownloadItem extends StatelessWidget {
  const DownloadItem(
      {super.key,
      required this.download,
      required this.onTapDelete,
      required this.onTapItem});
  final Download download;
  final VoidCallback onTapItem;
  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            onTap: onTapItem,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: IconExtension(
                        icon: download.bookImage,
                      ),
                    ),
                  ),
                  Gaps.wGap8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: Text(
                          download.bookName,
                          style: textTheme.labelSmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                        _buildDownloadStatus(textTheme.bodySmall!)
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        onTapDelete();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 22,
                      ))
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildDownloadStatus(TextStyle textStyle) {
    return switch (download.status) {
      DownloadStatus.downloading => Text(
          "Đang tải (${download.totalChaptersDownloaded}/${download.totalChaptersToDownload})",
          style: textStyle),
      DownloadStatus.downloaded => Text(
          "Hoàn thành (${download.totalChaptersDownloaded}/${download.totalChaptersToDownload})",
          style: textStyle),
      DownloadStatus.waiting => Text(
          "Đang chờ",
          style: textStyle,
        ),
      DownloadStatus.downloadedCancel => Text(
          "Đã hủy",
          style: textStyle,
        ),
      DownloadStatus.downloadErr => Text(
          "Lỗi tải xuống",
          style: textStyle,
        ),
    };
  }
}
