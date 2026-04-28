import 'package:deptsandloans/core/notifications/models/notification_payload.dart';
import 'package:deptsandloans/core/notifications/notification_constants.dart';
import 'package:deptsandloans/core/notifications/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationsService({FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onNotificationTapped);

    await createNotificationChannel();
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      NotificationPayload.fromJsonString(response.payload!); // TODO: Implement it in TASK-0037
    }
  }

  @override
  Future<NotificationPermissionStatus> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) {
      return NotificationPermissionStatus.notDetermined;
    }

    final bool? granted = await androidImplementation.requestNotificationsPermission();

    if (granted == true) {
      return NotificationPermissionStatus.granted;
    } else if (granted == false) {
      return NotificationPermissionStatus.denied;
    }

    return NotificationPermissionStatus.notDetermined;
  }

  @override
  Future<NotificationPermissionStatus> checkPermissionStatus() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) {
      return NotificationPermissionStatus.notDetermined;
    }

    final bool? granted = await androidImplementation.areNotificationsEnabled();

    if (granted == true) {
      return NotificationPermissionStatus.granted;
    } else if (granted == false) {
      return NotificationPermissionStatus.denied;
    }

    return NotificationPermissionStatus.notDetermined;
  }

  @override
  Future<void> createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      description: NotificationConstants.channelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(androidChannel);
  }

  @override
  Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledDate, NotificationPayload? payload}) async {
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    final androidDetails = AndroidNotificationDetails(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      channelDescription: NotificationConstants.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload?.toJsonString(),
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
