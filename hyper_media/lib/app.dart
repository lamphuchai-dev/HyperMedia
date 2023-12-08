import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/bloc/app_cubit/app_cubit_cubit.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/sharedpref/shared_preference_helper.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:macos_ui/macos_ui.dart';
import 'app/route/routes.dart';
import 'app/theme/themes.dart';
import 'flavors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'pages/test_ui/test_ui.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubitCubit(
            sharedPreferenceHelper: getIt<SharedPreferenceHelper>(),
            jsRuntime: getIt<JsRuntime>(),
            database: getIt<DatabaseUtils>())
          ..onInit(context),
        child: BlocConsumer<AppCubitCubit, AppCubitState>(
            listenWhen: (previous, current) =>
                previous.themeMode != current.themeMode,
            listener: (context, state) {
              final backgroundColor = context.colorScheme.background;
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor: backgroundColor,
                ),
              );
            },
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode,
            builder: (context, state) {
              if (Platform.isAndroid || Platform.isIOS) {
                return MaterialApp(
                  title: FlavorApp.name,
                  navigatorKey: navigatorKey,
                  themeMode: state.themeMode,
                  theme: Themes.light,
                  darkTheme: Themes.dark,
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: Routes.onGenerateRoute,
                  initialRoute: Routes.initialRoute,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  builder: (context, child) => _flavorBanner(
                      child: child, show: kDebugMode, context: context),
                  // home: const TestUiView(),
                );
              } else {
                return MacosApp(
                  navigatorKey: navigatorKey,
                  title: FlavorApp.name,
                  theme: MacosThemeData.light(),
                  darkTheme: MacosThemeData.dark(),
                  themeMode: state.themeMode,
                  debugShowCheckedModeBanner: false,
                  // onGenerateRoute: Routes.onGenerateRoute,
                  // initialRoute: Routes.initialRoute,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  builder: (context, child) => Theme(
                    data: MacosTheme.of(context).brightness.isDark
                        ? Themes.dark
                        : Themes.light,
                    child: _flavorBanner(
                        child: child, show: kDebugMode, context: context),
                  ),
                  home: Theme(
                    data: MacosTheme.of(context).brightness.isDark
                        ? Themes.dark
                        : Themes.light,
                    child: _flavorBanner(
                        child: const HomeMacos(),
                        show: kDebugMode,
                        context: context),
                  ),
                );
              }
            }));
  }

  Widget _flavorBanner(
      {Widget? child, bool show = true, required BuildContext context}) {
    return show
        ? Banner(
            location: BannerLocation.topStart,
            message: FlavorApp.name,
            color: Colors.green.withOpacity(0.6),
            textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                letterSpacing: 1.0),
            child: Overlay(
              initialEntries: [
                if (child != null) ...[
                  OverlayEntry(
                    builder: (context) => child,
                  ),
                ],
              ],
            ),
          )
        : Container(child: child);
  }
}

class HomeMacos extends StatefulWidget {
  const HomeMacos({super.key});

  @override
  State<HomeMacos> createState() => _HomeMacosState();
}

class _HomeMacosState extends State<HomeMacos> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: _pageIndex,
            onChanged: (index) {
              setState(() {
                _pageIndex = index;
              });
            },
            items: const [
              SidebarItem(
                leading: MacosIcon(CupertinoIcons.home),
                label: Text('Home'),
              ),
              SidebarItem(
                leading: MacosIcon(CupertinoIcons.search),
                label: Text('Explore'),
              ),
            ],
          );
        },
      ),
      child: IndexedStack(index: _pageIndex, children: [
        LibView(
          onTap: () {
            setState(() {
              _pageIndex = 1;
            });
          },
        ),
        const ExtView()
      ]),
    );
  }
}

class LibView extends StatelessWidget {
  const LibView({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: ElevatedButton(
            onPressed: () {
              onTap();
              navigatorKey.currentState?.pushNamed(RoutesName.detail,
                  arguments:
                      "https://www.nettruyenus.com/truyen-tranh/saijaku-teima-wa-gomi-hiroi-no-tabi-o-hajimemashita-277830");
            },
            child: const Text("TEST")),
      ),
    );
  }
}

class ExtView extends StatelessWidget {
  const ExtView({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: Routes.initialRoute,
    );
  }
}
