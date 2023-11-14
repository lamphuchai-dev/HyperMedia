import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/bloc/app_cubit/app_cubit_cubit.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/sharedpref/shared_preference_helper.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'app/route/routes.dart';
import 'app/theme/themes.dart';
import 'flavors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'pages/test_ui/test_ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppCubitCubit(sharedPreferenceHelper: getIt<SharedPreferenceHelper>())
            ..onInit(),
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
          return MaterialApp(
            title: FlavorApp.name,
            themeMode: state.themeMode,
            theme: Themes.light,
            darkTheme: Themes.dark,
            debugShowCheckedModeBanner: false,
            // onGenerateRoute: Routes.onGenerateRoute,
            // initialRoute: Routes.initialRoute,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) => _flavorBanner(
              child: child,
              show: kDebugMode,
            ),
            home: TestUiView(),
            // scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          );
        },
      ),
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
