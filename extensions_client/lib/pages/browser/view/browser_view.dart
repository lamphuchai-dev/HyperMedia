import 'package:flutter/material.dart';
import '../cubit/browser_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'browser_page.dart';

class BrowserView extends StatelessWidget {
  const BrowserView({super.key});
  static const String routeName = '/browser_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrowserCubit()..onInit(),
      child: const BrowserPage(),
    );
  }
}
