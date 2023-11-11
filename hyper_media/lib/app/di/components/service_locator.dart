import 'package:dio_client/index.dart';
import 'package:get_it/get_it.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/utils/database_service.dart';
import 'package:hyper_media/utils/directory_utils.dart';
import 'package:js_runtime/js_runtime.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final databaseService = DatabaseUtils();
  await databaseService.ensureInitialized();
  final jsRuntime = JsRuntime();
  await jsRuntime.initRuntime(
      pathSource: AppAssets.jsScriptExtension,
      dirCookie: await DirectoryUtils.getDirectory);
  getIt.registerSingleton(databaseService);
  getIt.registerSingleton(DioClient());
  getIt.registerSingleton(jsRuntime);
}
