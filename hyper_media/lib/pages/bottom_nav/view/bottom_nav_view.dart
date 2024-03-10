import 'package:flutter/material.dart';
import '../cubit/bottom_nav_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_page.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({super.key});
  static const String routeName = '/bottom_nav_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit()..onInit(),
      child: const BottomNavPage(),
    );
  }
}
