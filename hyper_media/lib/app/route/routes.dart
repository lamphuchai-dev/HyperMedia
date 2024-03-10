import 'package:flutter/material.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/backup_restore/backup_restore.dart';
import 'package:hyper_media/pages/bottom_nav/bottom_nav.dart';
import 'package:hyper_media/pages/chapters/chapters.dart';
import 'package:hyper_media/pages/detail/detail.dart';
import 'package:hyper_media/pages/explore/view/explore_view.dart';
import 'package:hyper_media/pages/genre/genre.dart';
import 'package:hyper_media/pages/web_view/view/web_view_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hyper_media/pages/extensions/extensions.dart';
import 'package:hyper_media/pages/reader/reader/reader.dart';
import 'package:hyper_media/pages/search/search.dart';
import 'package:hyper_media/pages/downloads/downloads.dart';

import 'routes_name.dart';

class Routes {
  static const initialRoute = "/";
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case initialRoute:
        return PageTransition(
            child: const BottomNavView(), type: PageTransitionType.rightToLeft);

      case ExploreView.routeName:
        return PageTransition(
            child: const ExploreView(), type: PageTransitionType.fade);

      case RoutesName.detail:
        assert(args != null && args is String, "args must be String");
        return PageTransition(
            child: DetailView(
              bookUrl: args as String,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.chaptersBook:
        assert(args != null && args is ChaptersBookArgs, "args must be Book");
        return PageTransition(
            child: ChaptersView(
              args: args as ChaptersBookArgs,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.extensions:
        return PageTransition(
            child: const ExtensionsView(),
            type: PageTransitionType.rightToLeft);

      case RoutesName.downloads:
        return PageTransition(
            child: const DownloadsView(), type: PageTransitionType.rightToLeft);

      case RoutesName.genre:
        assert(args != null && args is GenreBookArg, "args must be Book");
        return PageTransition(
            // settings: settings,
            child: GenreView(
              arg: args as GenreBookArg,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.reader:
        assert(args != null && (args is ReaderArgs || args is Bookmark),
            "args must be ReaderArgs || Bookmark");
        return PageTransition(
            child: ReaderView(
              readerArgs: args as ReaderArgs,
            ),
            type: PageTransitionType.fade);

      case RoutesName.webView:
        assert(args != null && args is String, "args must be String");
        return PageTransition(
            // settings: settings,
            child: WebViewView(
              url: args as String,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.search:
        assert(args != null && args is Extension, "args must be Extension");
        return PageTransition(
            child: SearchView(
              extension: args as Extension,
            ),
            type: PageTransitionType.fade);
      case RoutesName.backupAndRestore:
        return PageTransition(
            child: const BackupRestoreView(),
            type: PageTransitionType.rightToLeft);
      default:
        return _errRoute();
    }
  }

  static Route<dynamic> _errRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              appBar: AppBar(title: const Text("No route")),
              body: const Center(
                child: Text("no route"),
              ),
            ));
  }
}
