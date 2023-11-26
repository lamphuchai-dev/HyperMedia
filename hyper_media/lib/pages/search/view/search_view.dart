import 'package:flutter/material.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:js_runtime/js_runtime.dart';
import '../cubit/search_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_page.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key,required this.extension});
  static const String routeName = '/search_view';
  final Extension extension;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(extension: extension,jsRuntime: getIt<JsRuntime>())..onInit(),
      child: const SearchPage(),
    );
  }
}
