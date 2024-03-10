import 'package:hyper_media/utils/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalModule {
  static Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  static Future<DatabaseUtils> provideDatabase() async {
    final databaseService = DatabaseUtils();
    await databaseService.ensureInitialized();
    print("object");
    return databaseService;
  }
}
