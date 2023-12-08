import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/di/components/service_locator.dart';
import 'package:hyper_media/pages/explore/cubit/explore_cubit.dart';
import 'package:hyper_media/pages/genre/genre.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/widgets/widget.dart';

part 'explore_page.dart';

part '../widgets/explore_load_error.dart';
part '../widgets/explore_extension_null.dart';
part '../widgets/extension_ready.dart';
part '../widgets/select_extension_bottom_sheet.dart';
part '../widgets/extension_genre_tab.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});
  static const String routeName = '/explore_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(
          database: getIt<DatabaseUtils>(), jsRuntime: getIt<JsRuntime>())
        ..onInit(),
      child: const ExplorePage(),
    );
  }
}
