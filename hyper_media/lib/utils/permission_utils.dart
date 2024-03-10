import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> _checkAndRequestPermission(Permission permission) async {
    bool result = false;

    var statusPermission = await permission.status;

    if (statusPermission != PermissionStatus.granted) {
      statusPermission = await permission.request();
    }

    if (statusPermission == PermissionStatus.granted) {
      result = true;
    }

    return result;
  }

  static Future<bool> get storagePermission =>
      _checkAndRequestPermission(Permission.storage);
}
