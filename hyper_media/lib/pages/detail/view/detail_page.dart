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
    return BlocSelector<DetailCubit, DetailState, DetailState>(
      selector: (state) => state,
      builder: (context, state) {
        return switch (state) {
          DetailLoaded() => DetailLoadedView(
              book: state.book,
            ),
          DetailError() => DetailErrorView(
              bookUrl: _detailCubit.bookUrl,
              message: state.message,
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
