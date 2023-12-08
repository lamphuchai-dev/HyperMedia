// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../view/detail_view.dart';

class DetailErrorView extends StatelessWidget {
  const DetailErrorView({
    Key? key,
    required this.onTapRetry,
    required this.message,
    required this.bookUrl,
    required this.onTapBrowser
  }) : super(key: key);
  final VoidCallback onTapRetry;
  final VoidCallback onTapBrowser;

  final String message;
  final String bookUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Text(
            bookUrl,
            style: context.appTextTheme.titleSmall,
          ),
          actions: [
            IconButton(onPressed: onTapBrowser, icon: const Icon(Icons.public))
          ]),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                style: context.appTextTheme.bodyMedium,
              ),
              Gaps.hGap16,
              ElevatedButton(
                  onPressed: onTapRetry, child: Text("common.retry".tr()))
            ]),
      ),
    );
  }
}
