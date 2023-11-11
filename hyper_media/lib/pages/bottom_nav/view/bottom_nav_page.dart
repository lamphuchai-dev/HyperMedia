import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/pages/explore/explore.dart';
import 'package:hyper_media/pages/library/library.dart';
import '../cubit/bottom_nav_cubit.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late BottomNavCubit _bottomNavCubit;
  @override
  void initState() {
    _bottomNavCubit = context.read<BottomNavCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [const LibraryView(), const ExploreView()];
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      buildWhen: (previous, current) =>
          previous.indexSelected != current.indexSelected,
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(index: state.indexSelected, children: tabs),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: context.colorScheme.surface))),
            child: NavigationBar(
              elevation: 0,
              onDestinationSelected: _bottomNavCubit.onChangeIndex,
              selectedIndex: state.indexSelected,
              backgroundColor: context.colorScheme.background,
              destinations: <NavigationDestination>[
                NavigationDestination(
                  selectedIcon: const Icon(Icons.library_books_rounded),
                  icon: const Icon(Icons.library_books_outlined),
                  label: 'library.title'.tr(),
                ),
                NavigationDestination(
                  selectedIcon: const Icon(Icons.widgets_rounded),
                  icon: const Icon(Icons.widgets_outlined),
                  label: "explore.title".tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
