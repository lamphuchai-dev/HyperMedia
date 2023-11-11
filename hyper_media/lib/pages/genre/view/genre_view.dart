import 'package:flutter/material.dart';
import 'package:hyper_media/app/di/components/service_locator.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:js_runtime/js_runtime.dart';
import '../cubit/genre_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'genre_page.dart';

class GenreView extends StatelessWidget {
  const GenreView({super.key, required this.arg});
  static const String routeName = '/genre_view';

  final GenreBookArg arg;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenreCubit(
          jsRuntime: getIt<JsRuntime>(),
          extension: arg.extension,
          genre: arg.genre)
        ..onInit(),
      child: const GenrePage(),
    );
  }
}

class GenreBookArg {
  final Extension extension;
  final Genre genre;
  GenreBookArg({
    required this.extension,
    required this.genre,
  });
}
