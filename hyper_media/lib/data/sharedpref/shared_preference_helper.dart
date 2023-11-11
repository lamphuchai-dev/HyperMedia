import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // isSignIn

  bool get isSignIn {
    return _sharedPreference.getBool(Preferences.isSignIn) ?? false;
  }

  Future<void> changeIsSignIn(bool isSignIn) {
    return _sharedPreference.setBool(Preferences.isSignIn, isSignIn);
  }

  // Theme:------------------------------------------------------
  String? get themMode {
    return _sharedPreference.getString(Preferences.themeMode);
  }

  Future<void> changeThemMode(String value) {
    return _sharedPreference.setString(Preferences.themeMode, value);
  }

  // Language:---------------------------------------------------
  String? get currentLanguage {
    return _sharedPreference.getString(Preferences.currentLanguage);
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.setString(Preferences.currentLanguage, language);
  }

  // Fcm token

  String? get tokenFCM {
    return _sharedPreference.getString(Preferences.tokenFCM);
  }

  Future<bool> setTokenFCM(String tokenFCM) {
    return _sharedPreference.setString(Preferences.tokenFCM, tokenFCM);
  }
}
