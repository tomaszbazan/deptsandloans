# Implementation Plan: TASK-0036 - Setup Push Notifications

## Task Description
Configure Android push notifications permissions and local notification channel for the Debts and Loans Register app.

## Current State Analysis
- Project uses Isar database for local data storage
- Reminder model exists with support for one-time and recurring reminders
- Reminder repository (IsarReminderRepository) is implemented
- No notification infrastructure is currently in place
- Android target platform is configured
- No notification permissions declared in AndroidManifest.xml

## Implementation Steps

### 1. Add Required Dependencies
- Add `flutter_local_notifications` package to pubspec.yaml
- This package provides cross-platform local notification support
- It handles notification channels, permissions, and scheduling
- Run `flutter pub add flutter_local_notifications` to add the dependency

### 2. Update Android Configuration

#### 2.1 Update AndroidManifest.xml
- Add notification permissions for Android 13+ (API level 33+):
  - `POST_NOTIFICATIONS` permission for Android 13+
  - `RECEIVE_BOOT_COMPLETED` for notification persistence after device restart
  - `SCHEDULE_EXACT_ALARM` for precise 19:00 notifications
  - `USE_EXACT_ALARM` as fallback for older Android versions
- Add receiver for handling boot completed events
- Add receiver for handling notification actions

#### 2.2 Update build.gradle
- Verify minimum SDK version supports notifications (API 21+)
- Ensure compile SDK is at least API 33 for new permission model
- Add any required ProGuard rules if needed

### 3. Create Notification Service Layer

#### 3.1 Create NotificationService Interface
- Define abstract interface for notification operations
- Methods to include:
  - `initialize()` - Initialize notification system
  - `requestPermissions()` - Request runtime permissions (Android 13+)
  - `checkPermissionStatus()` - Check if permissions granted
  - `createNotificationChannel()` - Create Android notification channel
  - `scheduleNotification()` - Schedule a notification
  - `cancelNotification()` - Cancel scheduled notification
  - `cancelAllNotifications()` - Cancel all notifications for a transaction

#### 3.2 Implement FlutterLocalNotificationsService
- Implement the NotificationService interface using flutter_local_notifications
- Configure notification channel:
  - Channel ID: `debt_loan_reminders`
  - Channel name: Localized based on device locale
  - Channel description: Localized description
  - Importance: High (to show as heads-up notification)
  - Sound: Default notification sound
  - Vibration: Enabled
  - Show badge: Enabled
- Handle Android 13+ permission requests
- Implement notification scheduling at exact times (19:00)
- Support notification payload for deep linking (optional for future)

### 4. Create Notification Configuration

#### 4.1 Define Notification Constants
- Create `notification_constants.dart` file with:
  - Channel ID and name constants
  - Default notification time (19:00)
  - Notification icons and resources
  - Priority and importance levels

#### 4.2 Create Notification Payload Model
- Define structured payload for notifications:
  - Transaction ID (for opening specific transaction)
  - Transaction type (debt/loan)
  - Transaction name
  - Remaining amount
  - Currency
- Implement JSON serialization for payload

### 5. Integrate with Existing Reminder System

#### 5.1 Update Reminder Repository
- Add dependency on NotificationService
- When reminder is created, schedule corresponding notification
- When reminder is updated, reschedule notification
- When reminder is deleted, cancel notification
- Ensure transaction completion cancels all reminders

#### 5.2 Create Notification Content Formatter
- Format notification title and body based on transaction data
- Support localization (PL/EN)
- Include transaction name, remaining balance, and currency
- Example: "Przypomnienie: Zwróć Jan Kowalski - pozostało 500 PLN"

### 6. Handle Notification Permissions

#### 6.1 Create Permission Request Flow
- Check permission status on app startup
- Request permissions during first reminder setup
- Show rationale dialog explaining why notifications are needed
- Handle permission denial gracefully
- Provide option to open app settings if permission permanently denied

#### 6.2 Update App Initialization
- Initialize notification service in main.dart
- Request permissions on first launch (if needed)
- Create notification channel during initialization
- Handle permission callbacks

### 7. Add Localization Support

#### 7.1 Update Translation Files
- Add notification-related strings to app_en.arb:
  - Permission rationale
  - Notification channel name and description
  - Notification title and body templates
  - Error messages
- Add Polish translations to app_pl.arb
- Ensure notification content is formatted based on device locale

### 8. Handle Edge Cases

#### 8.1 Android Version Compatibility
- Handle Android 13+ permission model
- Fallback for older Android versions (auto-granted)
- Handle exact alarm scheduling restrictions
- Test on various Android versions (API 21 - 34+)

#### 8.2 App State Handling
- Handle notifications when app is:
  - Foreground
  - Background
  - Terminated
- Configure notification tap actions
- Handle device restart (boot completed)

#### 8.3 Error Handling
- Handle permission denial
- Handle scheduling failures
- Log errors appropriately
- Show user-friendly error messages

### 9. Testing Strategy

#### 9.1 Unit Tests
- Test NotificationService methods
- Test payload serialization/deserialization
- Test notification scheduling logic
- Mock flutter_local_notifications plugin

#### 9.2 Integration Tests
- Test permission request flow
- Test notification channel creation
- Test reminder creation triggers notification scheduling
- Test reminder deletion cancels notifications

#### 9.3 Manual Testing Checklist
- Test on Android 13+ device (permission request)
- Test on older Android device (auto-granted)
- Test notification delivery at scheduled time
- Test notification appears with correct content
- Test notification tap opens app
- Test notification after device restart
- Test notification cancellation
- Test both Polish and English locales

### 10. Create Golden Tests
- Add golden test for permission rationale dialog
- Test both light and dark themes
- Ensure visual consistency

## Files to Create

### Core Notification Files
- `lib/core/notifications/notification_service.dart` - Abstract interface
- `lib/core/notifications/flutter_local_notifications_service.dart` - Implementation
- `lib/core/notifications/notification_constants.dart` - Constants and configuration
- `lib/core/notifications/models/notification_payload.dart` - Payload model
- `lib/core/notifications/notification_content_formatter.dart` - Content formatting

### Updated Files
- `android/app/src/main/AndroidManifest.xml` - Add permissions and receivers
- `android/app/build.gradle` - Verify SDK versions
- `lib/main.dart` - Initialize notification service
- `lib/data/repositories/isar_reminder_repository.dart` - Integrate notifications
- `pubspec.yaml` - Add flutter_local_notifications dependency

### Localization Files
- `lib/l10n/app_en.arb` - English strings
- `lib/l10n/app_pl.arb` - Polish strings

### Test Files
- `test/core/notifications/notification_service_test.dart`
- `test/core/notifications/notification_content_formatter_test.dart`
- `test/core/notifications/models/notification_payload_test.dart`
- `test/integration/notification_permission_flow_test.dart`
- `test/goldens/notification_permission_dialog_test.dart`

## Technical Considerations

### Android Notification Channels
- Required for Android 8.0+ (API 26+)
- Cannot be modified after creation (only deleted and recreated)
- User can customize channel settings in system settings
- Choose appropriate importance level for reminder notifications

### Exact Alarm Scheduling
- Android 12+ requires special permission for exact alarms
- Use `flutter_local_notifications` plugin's exact alarm APIs
- Handle cases where exact alarm permission is denied
- Fallback to inexact alarms if needed (may deliver within ~15 min window)

### Battery Optimization
- Android may restrict background work and notifications
- Notifications may be delayed on battery saver mode
- Consider requesting battery optimization exemption (if critical)
- Inform users about potential delivery delays

### Notification Icons
- Notification requires small icon (status bar)
- Small icon should be white transparent PNG with alpha channel
- Place in `android/app/src/main/res/drawable` folders
- Use default launcher icon initially, create custom later if needed

### Time Zone Handling
- Store reminder times in UTC in database
- Convert to local time zone for scheduling
- Handle daylight saving time changes
- Use Dart's DateTime with timezone package if complex handling needed

## Dependencies on Other Tasks
- **TASK-0037**: Will use this notification infrastructure for UI controls
- **TASK-0038**: Will implement one-time reminder using this setup
- **TASK-0039**: Will implement recurring reminder using this setup
- **TASK-0040**: Will use notification cancellation methods
- **TASK-0041**: Will use notification content formatter

## Acceptance Criteria
- [ ] flutter_local_notifications package added and configured
- [ ] Android permissions declared in AndroidManifest.xml
- [ ] Notification channel created with appropriate settings
- [ ] NotificationService interface and implementation created
- [ ] Permission request flow implemented
- [ ] Notification service initialized in main.dart
- [ ] Localization support for notification strings (PL/EN)
- [ ] Unit tests for notification service pass
- [ ] Integration tests for permission flow pass
- [ ] Golden tests for permission dialogs pass
- [ ] Manual testing completed on Android 13+ and older devices
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter test` passes all tests
- [ ] Code formatted with `dart format .`

## Estimated Complexity
Medium - Requires Android-specific configuration, permission handling, and integration with existing reminder system. The foundation for all subsequent reminder tasks.

## Security Considerations
- Notification content may contain sensitive financial information
- Consider adding option to hide amounts in notifications
- Ensure notification payloads don't expose sensitive data to other apps
- Handle permission denial gracefully without compromising app functionality

## Performance Considerations
- Initialize notification service asynchronously to avoid blocking app startup
- Cache permission status to avoid repeated system checks
- Use background isolate for notification scheduling if needed
- Minimize notification plugin calls to reduce overhead

## Future Enhancements (Out of Scope)
- Custom notification sound selection
- Notification action buttons (e.g., "Mark as Paid", "Snooze")
- Rich notifications with images/charts
- iOS support (if expanding to iOS platform)
- Notification history/logs
