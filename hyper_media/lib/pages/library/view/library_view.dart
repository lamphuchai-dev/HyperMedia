import 'package:flutter/material.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import '../cubit/library_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'library_page.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});
  static const String routeName = '/library_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LibraryCubit(database: getIt<DatabaseUtils>())..onInit(),
      child: const LibraryPage(),
    );
  }
}
