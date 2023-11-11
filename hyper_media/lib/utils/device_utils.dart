import 'package:wakelock/wakelock.dart';

class DeviceUtils {
  static Future<void> initWakelock() async {
    final isEnable = await Wakelock.enabled;
    if (isEnable) {
      disableWakelock();
    }
  }

  static Future<void> enableWakelock() {
    return Wakelock.enable();
  }

  static Future<void> disableWakelock() {
    return Wakelock.disable();
  }
}
