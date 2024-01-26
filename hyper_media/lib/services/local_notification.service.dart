import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hyper_media/app.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/pages/reader/reader/reader.dart';
import 'package:hyper_media/utils/database_service.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const downloadNotificationID = -1;
  static const downloadDetailedNotificationID = -2;
  static const downloadChannelName = 'Download book';
  static const downloadChannelID = 'hyper-media/download';

  static const downloadDoneChannelName = 'Download Done';
  static const downloadDoneChannelID = 'hyper-media/downloadDone';
  static const downloadChannelNameDetailed = 'Downloaded book detail';
  static const downloadDetailedChannelID = 'hyper-media/downloadDetailed';
  static const cancelDownloadActionID = 'cancel_download';

  DatabaseUtils? _databaseUtils;

  Future<void> setup(DatabaseUtils databaseUtils) async {
    _databaseUtils = databaseUtils;
    const androidSetting = AndroidInitializationSettings("ic_launcher");
    const iosSetting = DarwinInitializationSettings();

    _localNotificationsPlugin.initialize(
        const InitializationSettings(
          android: androidSetting,
          iOS: iosSetting,
          macOS: iosSetting,
        ),
        onDidReceiveNotificationResponse:
            _onDidReceiveForegroundNotificationResponse);
  }

  void _onDidReceiveForegroundNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    if (notificationResponse.payload != null) {
      try {
        final mapPlayLoad = jsonDecode(notificationResponse.payload!);
        if (mapPlayLoad["bookId"] != null) {
          _databaseUtils!.onGetBookById(mapPlayLoad["bookId"]).then((book) {
            final context = navigatorKey.currentContext;
            if (context != null && book != null) {
              Navigator.pushNamed(context, RoutesName.reader,
                  arguments: ReaderArgs(book: book, chapters: []));
            }
          });
        }
      } catch (err) {
        //
      }
    }
    switch (notificationResponse.actionId) {
      case cancelDownloadActionID:
        break;
      default:
    }

    switch (notificationResponse.id) {
      case downloadNotificationID:
        final context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.pushNamed(context, RoutesName.downloads);
        }
        break;
      default:
    }
  }

  Future<void> _showOrUpdateNotification(
      int id,
      String title,
      String body,
      AndroidNotificationDetails androidNotificationDetails,
      DarwinNotificationDetails iosNotificationDetails,
      DarwinNotificationDetails macOSNotificationDetails,
      {String? payload}) async {
    final notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
        macOS: macOSNotificationDetails);

    // if (_permissionStatus == PermissionStatus.granted) {
    //   await _localNotificationsPlugin.show(
    //       id, title, body, notificationDetails);
    // }
    await _localNotificationsPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }

  Future<void> showOrUpdateDownloadStatus(
    String title,
    String body, {
    bool? isDetailed,
    bool? presentBanner,
    bool? showActions,
    int? maxProgress,
    int? progress,
  }) {
    var notificationId = downloadNotificationID;
    var androidChannelID = downloadChannelID;
    var androidChannelName = downloadChannelName;
    // Separate Notification for Info/Alerts and Progress
    if (isDetailed != null && isDetailed) {
      notificationId = downloadDetailedNotificationID;
      androidChannelID = downloadDetailedChannelID;
      androidChannelName = downloadChannelNameDetailed;
    }
    // Progress notification
    final androidNotificationDetails = (maxProgress != null && progress != null)
        ? AndroidNotificationDetails(
            androidChannelID,
            androidChannelName,
            ticker: title,
            showProgress: true,
            onlyAlertOnce: true,
            maxProgress: maxProgress,
            progress: progress,
            indeterminate: false,
            playSound: false,
            priority: Priority.low,
            importance: Importance.low,
            ongoing: true,
            actions: (showActions ?? false)
                ? <AndroidNotificationAction>[
                    const AndroidNotificationAction(
                      cancelDownloadActionID,
                      'Cancel',
                      showsUserInterface: true,
                    ),
                  ]
                : null,
          )
        // Non-progress notification
        : AndroidNotificationDetails(
            androidChannelID,
            androidChannelName,
            playSound: false,
          );

    final iosNotificationDetails = DarwinNotificationDetails(
      presentBadge: true,
      presentList: true,
      presentBanner: presentBanner,
    );

    final macOSNotificationDetails = DarwinNotificationDetails(
      presentBadge: true,
      presentList: true,
      presentBanner: presentBanner,
    );

    return _showOrUpdateNotification(
        notificationId,
        title,
        body,
        androidNotificationDetails,
        iosNotificationDetails,
        macOSNotificationDetails);
  }

  Future<void> showDownloadDone(int bookId, String title, String body) {
    var notificationId = bookId;
    var androidChannelID = downloadDoneChannelID;
    var androidChannelName = downloadDoneChannelName;
    final androidNotificationDetails = AndroidNotificationDetails(
      androidChannelID,
      androidChannelName,
      playSound: false,
    );

    const iosNotificationDetails = DarwinNotificationDetails(
      presentBadge: true,
      presentList: true,
    );

    const macOSNotificationDetails = DarwinNotificationDetails(
      presentBadge: true,
      presentList: true,
    );

    return _showOrUpdateNotification(
        notificationId,
        title,
        body,
        androidNotificationDetails,
        iosNotificationDetails,
        macOSNotificationDetails,
        payload: jsonEncode({"bookId": bookId}));
  }

  Future<void> closeNotification(int id) {
    return _localNotificationsPlugin.cancel(id);
  }

  Future<void> closeDownloadNotification() {
    return _localNotificationsPlugin.cancel(downloadNotificationID);
  }
}
