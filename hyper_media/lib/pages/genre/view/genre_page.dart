import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/genre_cubit.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late GenreCubit _genreCubit;
  @override
  void initState() {
    _genreCubit = context.read<GenreCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(_genreCubit.titleGenre)),
      body: BooksGridWidget(
        onFetchListBook: (page) {
          return _genreCubit.onGetListBook(page);
        },
        onTap: (book) {
          Navigator.pushNamed(context, RoutesName.detail,
              arguments: book.bookUrl);
        },
      ),
    );
  }
}
