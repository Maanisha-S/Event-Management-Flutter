import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true);

      const InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

      bool? initialized = await notificationsPlugin.initialize(initializationSettings);
      print("Notification Plugin Initialized: $initialized");
    } catch (e) {
      print("Error initializing notification plugin: $e");
    }
  }


  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    required DateTime scheduledNotificationDateTime,
  }) async {
    try {

      final tz.TZDateTime tzScheduledDateTime = tz.TZDateTime.from(
        scheduledNotificationDateTime,

        tz.getLocation('Asia/Kolkata'),
      );


      final tz.TZDateTime tzNow = tz.TZDateTime.now(
          tz.getLocation('Asia/Kolkata'));

      print('User-selected time (local): $scheduledNotificationDateTime');
      print('Scheduled time in IST: $tzScheduledDateTime');
      print('Current time in IST: $tzNow');

      if (tzScheduledDateTime.isBefore(tzNow)) {
        print("Scheduled time is in the past. Notification will not be shown.");
        return;
      }

      await notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDateTime,
          _notificationDetails(),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
      print("Notification scheduled");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }
}


