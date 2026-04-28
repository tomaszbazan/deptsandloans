import 'package:deptsandloans/core/notifications/models/notification_payload.dart';

enum NotificationPermissionStatus { granted, denied, notDetermined }

abstract class NotificationService {
  Future<void> initialize();

  Future<NotificationPermissionStatus> requestPermissions();

  Future<NotificationPermissionStatus> checkPermissionStatus();

  Future<void> createNotificationChannel();

  Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledDate, NotificationPayload? payload});

  Future<void> cancelNotification(int id);

  Future<void> cancelAllNotifications();
}
