import 'package:dio_client/index.dart';
import 'package:get_it/get_it.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/data/sharedpref/shared_preference_helper.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/directory_utils.dart';
import 'package:hyper_media/utils/download_service.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/local_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));

  final databaseService = DatabaseUtils();
  await databaseService.ensureInitialized();
  final dioClient = DioClient();
  final jsRuntime = JsRuntime(dioClient: dioClient);
  await jsRuntime.initRuntime(
      pathSource: AppAssets.jsScriptExtension,
      dirCookie: await DirectoryUtils.getDirectory);
  getIt.registerSingleton(databaseService);
  getIt.registerSingleton(dioClient);
  getIt.registerSingleton(jsRuntime);
  getIt.registerLazySingleton(() => DownloadService(
      dioClient: dioClient, database: databaseService, jsRuntime: jsRuntime));
}
