import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/settings_cubit.dart';

part 'settings_page.dart';
part '../widgets/widgets.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String routeName = '/settings_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..onInit(),
      child: const SettingsPage(),
    );
  }
}
