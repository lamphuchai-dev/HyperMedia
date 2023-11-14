import 'package:extensions_client/pages/browser/view/browser_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/home.dart';
import '../cubit/tabs_cubit.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  late TabsCubit _tabsCubit;
  @override
  void initState() {
    _tabsCubit = context.read<TabsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocSelector<TabsCubit, TabsState, int>(
      selector: (state) {
        return state.index;
      },
      builder: (context, index) {
        return Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: _tabsCubit.onChangeIndex,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home_rounded), label: Text("HOME")),
                NavigationRailDestination(
                    icon: Icon(Icons.browse_gallery), label: Text("Browse"))
              ],
            ),
            Expanded(
                child: IndexedStack(
              index: index,
              children: const [HomeView(), BrowserView()],
            ))
          ],
        );
      },
    ));
  }
}
