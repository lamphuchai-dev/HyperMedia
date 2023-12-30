part of './detail_view.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DetailCubit _detailCubit;
  @override
  void initState() {
    _detailCubit = context.read<DetailCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detailCubit.onInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DetailCubit, DetailState, StateRes<Book>>(
      selector: (state) => state.bookState,
      builder: (context, bookRes) {
        return switch (bookRes.status) {
          StatusType.loaded => const BookDetail(),
          StatusType.error => DetailErrorView(
              bookUrl: _detailCubit.bookUrl,
              message: bookRes.message ?? "",
              onTapRetry: () {
                _detailCubit.onInit();
              },
              onTapBrowser: () {
                _detailCubit.openBrowser();
              },
            ),
          _ => Scaffold(appBar: AppBar(), body: const LoadingWidget())
        };
      },
    );
  }
}
