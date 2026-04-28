# Implementation Plan: TASK-0039 - Implement Recurring Reminder

## Task Overview

**ID**: TASK-0039
**Description**: Schedule repeating notifications every X days at 19:00
**Status**: Not Started
**Category**: Reminders & Notifications

## Current State Analysis

### Existing Infrastructure

The codebase already has extensive reminder infrastructure in place from TASK-0038 (One-Time Reminders):

1. **Reminder Model** (`lib/data/models/reminder.dart`)
   - Supports both `ReminderType.oneTime` and `ReminderType.recurring`
   - Has `intervalDays` field (nullable) for recurring intervals
   - Tracks `nextReminderDate` for scheduling
   - Stores `notificationId` for cancellation

2. **Notification System**
   - `NotificationScheduler`: High-level orchestration
   - `NotificationService`: Abstract interface for scheduling
   - `LocalNotificationsService`: Implementation using `flutter_local_notifications`
   - `NotificationContentFormatter`: Locale-aware notification messages

3. **UI Components**
   - `ReminderConfigurationWidget`: Complete UI with radio buttons for recurring type
   - Interval days input field already implemented
   - Full validation in place

4. **Repository Layer**
   - `IsarReminderRepository` with methods:
     - `getActiveReminders()`: Finds reminders where `nextReminderDate <= now()`
     - `updateNextReminderDate()`: Updates next scheduled date
     - Full CRUD operations

### Current Gap

**The Issue**: Recurring reminders are saved to the database but **no notifications are scheduled**. The `TransactionFormViewModel._createReminder()` only calls `scheduleOneTimeReminder()` for one-time reminders, leaving recurring reminders dormant.

**Why**: Android doesn't support native recurring notifications at exact times. We need a rescheduling mechanism.

## Architecture Decision

### Chosen Approach: One-Shot Notifications with Rescheduling

Instead of trying to schedule multiple notifications upfront, we:
1. Schedule the **first notification** at `nextReminderDate`
2. When the notification fires, a **background processor** detects it
3. The processor **reschedules the next notification** (`nextReminderDate + intervalDays`)
4. The processor **updates the database** with the new `nextReminderDate`
5. Repeat indefinitely until transaction is completed

### Advantages
- Leverages existing notification infrastructure
- No additional dependencies required
- More maintainable than Android AlarmManager
- Works with existing database schema
- Handles edge cases gracefully (boot, timezone changes)

## Implementation Steps

### Phase 1: Extend NotificationScheduler

**File**: `lib/core/notifications/notification_scheduler.dart`

**Changes**:
```dart
Future<int> scheduleRecurringReminder({
  required Reminder reminder,
  required Transaction transaction,
  required String locale,
  required double remainingBalance,
}) async {
  // 1. Calculate scheduledDateTime from reminder.nextReminderDate at 19:00
  // 2. Generate notificationId using existing _generateNotificationId()
  // 3. Format notification content using NotificationContentFormatter
  // 4. Call _notificationService.scheduleNotification()
  // 5. Return notificationId
}
```

**Implementation Details**:
- Reuse `_calculateScheduledDateTime()` logic
- Reuse `_generateNotificationId()` logic
- Schedule single notification, not repeating
- Let background processor handle rescheduling

### Phase 2: Create Recurring Reminder Processor

**New File**: `lib/core/notifications/recurring_reminder_processor.dart`

**Purpose**: Process active recurring reminders and reschedule notifications.

**Core Logic**:
```dart
class RecurringReminderProcessor {
  final ReminderRepository _reminderRepository;
  final RepaymentRepository _repaymentRepository;
  final TransactionRepository _transactionRepository;
  final NotificationScheduler _notificationScheduler;

  Future<void> processActiveRecurringReminders() async {
    // 1. Get all active recurring reminders (nextReminderDate <= now, type == recurring)
    final activeReminders = await _reminderRepository.getActiveReminders();
    final recurringReminders = activeReminders.where((r) => r.isRecurring).toList();

    for (final reminder in recurringReminders) {
      // 2. Fetch transaction
      final transaction = await _transactionRepository.getById(reminder.transactionId);

      // 3. Check if transaction is completed (skip if completed)
      if (transaction.status == TransactionStatus.completed) {
        continue;
      }

      // 4. Calculate remaining balance
      final repayments = await _repaymentRepository.getRepaymentsByTransactionId(transaction.id);
      final totalRepaid = repayments.fold<int>(0, (sum, rep) => sum + rep.amount);
      final remainingBalance = (transaction.amount - totalRepaid) / 100.0;

      // 5. Calculate next reminder date
      final nextDate = reminder.nextReminderDate.add(Duration(days: reminder.intervalDays!));

      // 6. Schedule next notification
      final notificationId = await _notificationScheduler.scheduleRecurringReminder(
        reminder: reminder,
        transaction: transaction,
        locale: _getLocale(),
        remainingBalance: remainingBalance,
      );

      // 7. Update reminder in database
      reminder.nextReminderDate = nextDate;
      reminder.notificationId = notificationId;
      await _reminderRepository.updateReminder(reminder);
    }
  }

  String _getLocale() {
    // Return 'pl' or 'en' based on device locale
  }
}
```

**Key Considerations**:
- Handle timezone using `timezone` package
- Process all active reminders on app startup
- Skip completed transactions
- Update both `nextReminderDate` and `notificationId`

### Phase 3: Create Background Reminder Service

**New File**: `lib/services/background_reminder_service.dart`

**Purpose**: Initialize and trigger the recurring reminder processor.

**Implementation**:
```dart
class BackgroundReminderService {
  final RecurringReminderProcessor _processor;

  Future<void> initialize() async {
    // Process active reminders on app startup
    await _processor.processActiveRecurringReminders();
  }

  Future<void> onDeviceBootCompleted() async {
    // Reschedule all pending reminders after device restart
    await _processor.processActiveRecurringReminders();
  }
}
```

**Integration Point**: Call from `main.dart` after initializing Isar and notification service.

### Phase 4: Update TransactionFormViewModel

**File**: `lib/presentation/screens/transaction_form/transaction_form_view_model.dart`

**Method**: `_createReminder(int transactionId)`

**Changes**:
```dart
// AFTER creating the reminder object and saving to DB:

if (_reminderType == ReminderType.oneTime) {
  // Existing code (unchanged)
  final notificationId = await _notificationScheduler.scheduleOneTimeReminder(
    reminder: reminder,
    transaction: transaction,
    locale: locale,
    remainingBalance: remainingBalance,
  );
  reminder.notificationId = notificationId;
  await _reminderRepository.updateReminder(reminder);
} else if (_reminderType == ReminderType.recurring) {
  // NEW: Schedule first recurring notification
  final transaction = await _repository.getById(transactionId);
  final repayments = await _repaymentRepository.getRepaymentsByTransactionId(transactionId);
  final totalRepaid = repayments.fold<int>(0, (sum, rep) => sum + rep.amount);
  final remainingBalance = (transaction.amount - totalRepaid) / 100.0;
  final locale = _getLocale();

  final notificationId = await _notificationScheduler.scheduleRecurringReminder(
    reminder: reminder,
    transaction: transaction,
    locale: locale,
    remainingBalance: remainingBalance,
  );

  reminder.notificationId = notificationId;
  await _reminderRepository.updateReminder(reminder);
}
```

### Phase 5: Hook Background Service into App Lifecycle

**File**: `lib/main.dart`

**Changes**:
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ... existing initialization (Isar, notifications, timezone)

  // NEW: Initialize background reminder service
  final backgroundReminderService = BackgroundReminderService(
    processor: RecurringReminderProcessor(
      reminderRepository: reminderRepository,
      repaymentRepository: repaymentRepository,
      transactionRepository: transactionRepository,
      notificationScheduler: notificationScheduler,
    ),
  );

  await backgroundReminderService.initialize();

  runApp(MyApp());
}
```

### Phase 6: Ensure Reminder Cancellation Works

**File**: `lib/data/repositories/isar_transaction_repository.dart`

**Method**: Verify `_scheduleNotifications()` cancels all reminder notifications when transaction is completed.

**Current Code** (should already work):
```dart
for (final reminder in reminders) {
  if (reminder.notificationId != null) {
    await _notificationScheduler.cancelReminder(reminder.notificationId!);
  }
}
```

**Action**: No changes needed, verify this works for both one-time and recurring.

## Edge Cases & Validation

### 1. Device Restart
**Solution**: `BackgroundReminderService.onDeviceBootCompleted()` reschedules all active reminders.

**Implementation**: Add boot completed receiver in `android/app/src/main/AndroidManifest.xml`:
```xml
<receiver android:name=".BootCompletedReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

### 2. Missed Reminders (App Not Opened)
**Solution**: When app opens after prolonged absence, `processActiveRecurringReminders()` finds all overdue reminders and reschedules immediately.

**Behavior**: If `nextReminderDate` is in the past, schedule for "today at 19:00" or "tomorrow at 19:00" depending on current time.

### 3. Transaction Completed Mid-Cycle
**Solution**: `IsarTransactionRepository._scheduleNotifications()` already cancels all notifications when `status = completed`.

### 4. Reminder Interval Validation
**Validation**: In `ReminderConfigurationWidget`, enforce `intervalDays` between 1 and 365 days.

```dart
if (intervalDays < 1 || intervalDays > 365) {
  return 'Interval must be between 1 and 365 days';
}
```

### 5. Timezone Changes & Daylight Saving Time
**Solution**: Use `timezone` package with device's local timezone. Always schedule at "19:00 local time" relative to device.

### 6. Notification Permission Denied
**Solution**: Existing `NotificationService.requestPermissions()` handles this. If denied, notifications won't fire but app remains functional.

## Testing Strategy

### Unit Tests

**File**: `test/core/notifications/notification_scheduler_test.dart`

**New Tests**:
```dart
group('scheduleRecurringReminder', () {
  test('schedules notification at nextReminderDate at 19:00', () async {
    // Create recurring reminder
    // Call scheduleRecurringReminder()
    // Verify notification scheduled at correct DateTime
  });

  test('generates unique notification ID for recurring reminder', () async {
    // Verify notificationId = reminder.id * 1000 + transaction.id
  });

  test('formats notification content correctly for recurring', () async {
    // Verify title and body match expected format
  });
});
```

**File**: `test/core/notifications/recurring_reminder_processor_test.dart` (NEW)

**Tests**:
```dart
group('RecurringReminderProcessor', () {
  test('reschedules active recurring reminders', () async {
    // Setup: Reminder with nextReminderDate = yesterday
    // Process
    // Verify: nextReminderDate updated to yesterday + intervalDays
    // Verify: New notification scheduled
  });

  test('skips completed transactions', () async {
    // Setup: Transaction with status = completed
    // Process
    // Verify: No notification scheduled
  });

  test('handles multiple active reminders', () async {
    // Setup: 3 recurring reminders
    // Process
    // Verify: All 3 rescheduled
  });
});
```

### Widget Tests

**File**: `test/presentation/widgets/reminder_configuration_widget_test.dart`

**Verify**:
- Recurring interval input accepts numeric values (1-365)
- Validation error shown for invalid intervals (0, 366, negative)
- Callback triggered with correct `intervalDays` value

### Integration Tests

**File**: `integration_test/recurring_reminder_flow_test.dart` (NEW)

**Flow**:
1. Create transaction with recurring reminder (7 days interval)
2. Verify reminder saved to database with correct `nextReminderDate`
3. Verify first notification scheduled
4. Mock notification delivery (advance time by 7 days)
5. Trigger background processor
6. Verify `nextReminderDate` advanced by 7 days
7. Verify new notification scheduled
8. Mark transaction as completed
9. Verify notification cancelled

### Golden Tests

**File**: `test/presentation/widgets/reminder_configuration_widget_golden_test.dart`

**Add**:
- Golden snapshot of recurring reminder configuration UI
- Show interval days input field with value "7"

## Files to Modify/Create

### New Files
1. `lib/core/notifications/recurring_reminder_processor.dart`
2. `lib/services/background_reminder_service.dart`
3. `test/core/notifications/recurring_reminder_processor_test.dart`
4. `integration_test/recurring_reminder_flow_test.dart`

### Modified Files
1. `lib/core/notifications/notification_scheduler.dart`
   - Add `scheduleRecurringReminder()` method
2. `lib/presentation/screens/transaction_form/transaction_form_view_model.dart`
   - Update `_createReminder()` to handle recurring type
3. `lib/main.dart`
   - Initialize `BackgroundReminderService`
4. `test/core/notifications/notification_scheduler_test.dart`
   - Add tests for recurring reminders
5. `lib/presentation/widgets/reminder_configuration_widget.dart`
   - Add interval validation (1-365 days)

## Success Criteria

- [ ] User can create recurring reminder with interval days (1-365)
- [ ] First notification scheduled at calculated `nextReminderDate` at 19:00
- [ ] Background processor reschedules next notification after delivery
- [ ] Each notification shows current remaining balance
- [ ] Reminders continue until transaction marked as completed
- [ ] Reminders can be cancelled via transaction completion
- [ ] Notifications survive device restart
- [ ] All unit tests pass
- [ ] All widget tests pass
- [ ] Integration test validates end-to-end flow
- [ ] Golden test captures UI snapshot
- [ ] `flutter analyze` reports no issues
- [ ] Code formatted with `dart format .`

## Dependencies

**No new dependencies required**. All functionality uses:
- `flutter_local_notifications` (already added)
- `timezone` (already added)
- `isar` (already added)

## Rollback Plan

If issues arise:
1. Remove `scheduleRecurringReminder()` calls from `TransactionFormViewModel`
2. Disable `BackgroundReminderService` initialization in `main.dart`
3. Recurring reminders will save to database but not trigger notifications
4. One-time reminders continue working normally

## Notes

- Notification content uses existing `NotificationContentFormatter`
- Locale detection reuses existing logic from `TransactionFormViewModel`
- Database schema requires no changes
- UI already supports recurring type selection
- Repository layer already has all needed methods

## Estimated Effort

- Core implementation: 4-6 hours
- Testing: 3-4 hours
- Edge cases & manual testing: 2-3 hours
- **Total**: 9-13 hours
