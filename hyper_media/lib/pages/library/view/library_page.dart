import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/reader/reader/reader.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/library_cubit.dart';
import '../widgets/widgets.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late LibraryCubit _libraryCubit;
  @override
  void initState() {
    _libraryCubit = context.read<LibraryCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Library")),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return switch (state.status) {
            StatusType.loading => const LoadingWidget(),
            StatusType.loaded => BooksGridWidget(
                useFetch: false,
                useRefresh: false,
                listenBooks: true,
                initialBooks: _libraryCubit.books,
                onTap: (book) {
                  Navigator.pushNamed(context, RoutesName.reader,
                      arguments: _libraryCubit.getBookmarkByBook(book));
                },
                onLongTap: _openBottomSheet,
              ),
            _ => const SizedBox()
          };
        },
      ),
    );
  }

  void _openBottomSheet(Book book) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BookBottomSheet(
              book: book,
              libraryCubit: _libraryCubit,
            ));
  }
}
