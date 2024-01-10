import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const downloadNotificationID = 4;
  static const downloadDetailedNotificationID = 5;
  static const downloadChannelName = 'Download book';
  static const downloadChannelID = 'hyper-media/download';
  static const downloadChannelNameDetailed = 'Downloaded book detail';
  static const downloadDetailedChannelID = 'hyper-media/downloadDetailed';
  static const cancelDownloadActionID = 'cancel_download';
  Future<void> setup() async {
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
    // Handle notification actions
    switch (notificationResponse.actionId) {
      case cancelDownloadActionID:
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
  ) async {
    final notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
        macOS: macOSNotificationDetails);

    // if (_permissionStatus == PermissionStatus.granted) {
    //   await _localNotificationsPlugin.show(
    //       id, title, body, notificationDetails);
    // }
    await _localNotificationsPlugin.show(id, title, body, notificationDetails);
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

  Future<void> closeNotification(int id) {
    return _localNotificationsPlugin.cancel(id);
  }
}
