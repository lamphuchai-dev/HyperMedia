import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUtils {
  static ensureInitialized() {
    setSystemUIOverlayStyle();
    setPreferredOrientations();
  }

  static setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }

  static Future<void> setPreferredOrientations() {
    return SystemChrome.setPreferredOrientations([]);
  }

  static Future<void> setRotationDevice() {
    return SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  static void setSystemNavigationBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: color,
      ),
    );
  }

  static void setEnabledSystemUIModeReadBookPage() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    setSystemNavigationBarColor(Colors.black12);
  }

  static void setEnabledSystemUIModeDefault() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }
}
