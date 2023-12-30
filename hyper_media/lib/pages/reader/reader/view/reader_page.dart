part of './reader_view.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late ReaderCubit _readerCubit;
  @override
  void initState() {
    _readerCubit = context.read<ReaderCubit>();
    _readerCubit.onInitFToat(context);
    SystemUtils.setEnabledSystemUIModeReadBookPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocSelector<ReaderCubit, ReaderState, ExtensionStatus>(
        selector: (state) {
          return state.extensionStatus;
        },
        builder: (context, extensionStatus) {
          return switch (extensionStatus) {
            ExtensionStatus.init => const LoadingWidget(),
            ExtensionStatus.unknown => ExtensionUnknown(
                book: _readerCubit.book,
              ),
            ExtensionStatus.ready => ReaderBook(readerCubit: _readerCubit),
            ExtensionStatus.error => const Center(
                child: Text("error extension"),
              ),
          };
        },
      ),
    );
  }
}

class ExtensionUnknown extends StatelessWidget {
  const ExtensionUnknown({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(book.name),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Extension chưa được cài đặt hoặc web đã đổi host",
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Gaps.hGap8,
              Text(book.bookUrl)
            ],
          ),
        ),
      ),
    );
  }
}

class ReaderBook extends StatelessWidget {
  const ReaderBook({super.key, required this.readerCubit});
  final ReaderCubit readerCubit;

  @override
  Widget build(BuildContext context) {
    return switch (readerCubit.getExtensionType) {
      ExtensionType.comic => const WatchComicView(),
      ExtensionType.novel => const WatchNovelView(),
      ExtensionType.movie => const WatchMovieView(),
    };
  }
}
