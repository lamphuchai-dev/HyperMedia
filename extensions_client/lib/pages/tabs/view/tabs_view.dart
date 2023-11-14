import 'package:flutter/material.dart';
import '../cubit/tabs_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tabs_page.dart';

class TabsView extends StatelessWidget {
  const TabsView({super.key});
  static const String routeName = '/tabs_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabsCubit()..onInit(),
      child: const TabsPage(),
    );
  }
}
