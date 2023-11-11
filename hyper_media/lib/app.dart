import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/pages/test_ui/view/test_ui_view.dart';
import 'app/route/routes.dart';
import 'app/theme/themes.dart';
import 'flavors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlavorApp.name,
      themeMode: ThemeMode.system,
      theme: Themes.light,
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: Routes.initialRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) => _flavorBanner(
        child: child,
        show: kDebugMode,
      ),
      // home: TestUiView(),
      // scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
    );
  }

  Widget _flavorBanner({
    Widget? child,
    bool show = true,
  }) =>
      show
          ? Banner(
              location: BannerLocation.topStart,
              message: FlavorApp.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  letterSpacing: 1.0),
              child: child,
            )
          : Container(child: child);
}
