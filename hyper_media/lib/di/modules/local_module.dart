import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalModule {
  static Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }
}
