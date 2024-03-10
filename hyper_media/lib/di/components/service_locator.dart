import 'package:dio_client/index.dart';
import 'package:get_it/get_it.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/services/download_manager.dart';
import 'package:hyper_media/services/local_notification.service.dart';
import 'package:hyper_media/data/sharedpref/shared_preference_helper.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/directory_utils.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/local_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  getIt.registerSingletonAsync<DatabaseUtils>(
      () => LocalModule.provideDatabase());
  await getIt.getAsync<DatabaseUtils>();
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  // getIt.registerSingletonWithDependencies(() => null)

  final dioClient = DioClient();
  final jsRuntime = JsRuntime(dioClient: dioClient);
  await jsRuntime.initRuntime(
      pathSource: AppAssets.jsScriptExtension,
      dirCookie: "${await DirectoryUtils.getDirDatabase}/cookies");

  // final localNotificationService = LocalNotificationService();
  // localNotificationService.setup(getIt<DatabaseUtils>());
  // getIt.registerFactory(() => localNotificationService);

  // getIt.registerSingletonAsync<LocalNotificationService>(() {

  //   return
  // });

  getIt.registerSingletonAsync<LocalNotificationService>(() async {
    final localNotificationService = LocalNotificationService();
    await localNotificationService.setup(getIt<DatabaseUtils>());
    return localNotificationService;
  });

  // getIt.registerSingleton(databaseService);
  getIt.registerSingleton(dioClient);
  getIt.registerSingleton(jsRuntime);
  // final dow = DownloadManager(
  //     dioClient: dioClient,
  //     database: getIt<DatabaseUtils>(),
  //     jsRuntime: jsRuntime,
  //     localNotificationService: localNotificationService);
  getIt.registerSingletonWithDependencies(
      () => DownloadManager(
          dioClient: dioClient,
          database: getIt<DatabaseUtils>(),
          jsRuntime: jsRuntime,
          localNotificationService: getIt<LocalNotificationService>()),
      dependsOn: [LocalNotificationService]);
}


// locator.registerSingletonAsync<LocationService>(() async {
//     final locationService = LocationService();
//     await locationService.init();
//     return locationService;
//   });
// locator.registerSingletonWithDependencies<HomeViewModel>(() {
//     return HomeViewModel();
//   }, dependsOn: [LocationService]);
//  }