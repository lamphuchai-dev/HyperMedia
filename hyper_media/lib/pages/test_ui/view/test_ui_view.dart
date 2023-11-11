import 'package:flutter/material.dart';
import '../cubit/test_ui_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'test_ui_page.dart';

class TestUiView extends StatelessWidget {
  const TestUiView({super.key});
  static const String routeName = '/test_ui_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestUiCubit()..onInit(),
      child: const TestUiPage(),
    );
  }
}
