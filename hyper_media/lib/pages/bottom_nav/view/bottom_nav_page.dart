import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/pages/explore/explore.dart';
import 'package:hyper_media/pages/library/library.dart';
import 'package:hyper_media/pages/settings/settings.dart';
import 'package:hyper_media/widgets/platform_widget.dart';
import 'package:macos_ui/macos_ui.dart';
import '../../../app/bloc/app_cubit/app_cubit_cubit.dart';
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
    final tabs = [
      const LibraryView(),
      const ExploreView(),
      const SettingsView()
    ];
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      buildWhen: (previous, current) =>
          previous.indexSelected != current.indexSelected,
      builder: (context, state) {
        return PlatformWidget(
            mobileWidget: Scaffold(
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
                    NavigationDestination(
                      selectedIcon: const Icon(Icons.settings_rounded),
                      icon: const Icon(Icons.settings_outlined),
                      label: "settings.title".tr(),
                    ),
                  ],
                ),
              ),
            ),
            macosWidget: Scaffold(
              body: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight),
                  child: NavigationRail(
                    onDestinationSelected: _bottomNavCubit.onChangeIndex,
                    selectedIndex: state.indexSelected,
                    backgroundColor: context.colorScheme.background,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.library_books_rounded),
                        icon: const Icon(Icons.library_books_outlined),
                        label: Text('library.title'.tr()),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.widgets_rounded),
                        icon: const Icon(Icons.widgets_outlined),
                        label: Text("explore.title".tr()),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.settings_rounded),
                        icon: const Icon(Icons.settings_outlined),
                        label: Text("settings.title".tr()),
                      ),
                    ],
                  ),
                ),
                Gaps.wGap16,
                Expanded(
                    child: IndexedStack(
                        index: state.indexSelected, children: tabs))
              ]),
            ));
      },
    );
  }
}
