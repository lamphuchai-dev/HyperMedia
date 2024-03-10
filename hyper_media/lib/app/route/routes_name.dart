import 'package:hyper_media/pages/backup_restore/backup_restore.dart';
import 'package:hyper_media/pages/bottom_nav/bottom_nav.dart';
import 'package:hyper_media/pages/chapters/chapters.dart';
import 'package:hyper_media/pages/detail/detail.dart';
import 'package:hyper_media/pages/downloads/downloads.dart';
import 'package:hyper_media/pages/extensions/extensions.dart';
import 'package:hyper_media/pages/genre/genre.dart';
import 'package:hyper_media/pages/reader/reader/reader.dart';
import 'package:hyper_media/pages/search/search.dart';
import 'package:hyper_media/pages/web_view/web_view.dart';

class RoutesName {
  RoutesName._();
  static const bottomNav = BottomNavView.routeName;
  static const detail = DetailView.routeName;
  static const chaptersBook = ChaptersView.routeName;
  static const extensions = ExtensionsView.routeName;
  static const genre = GenreView.routeName;
  static const webView = WebViewView.routeName;
  static const reader = ReaderView.routeName;
  static const search = SearchView.routeName;
  static const downloads = DownloadsView.routeName;
  static const backupAndRestore = BackupRestoreView.routeName;
}
