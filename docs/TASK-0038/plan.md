0# Implementation Plan: TASK-0038 - Implement One-Time Reminder

## Task Description
Implement one-time reminder functionality that schedules a single push notification at 19:00 on a specified date.

## Prerequisites
- TASK-0036: Push notifications are already configured ✓
- TASK-0037: Reminder configuration UI is already implemented ✓
- Local notification channel is set up ✓

## Technical Approach

### 1. Dependencies
Already available from TASK-0036:
- `flutter_local_notifications` - for local push notifications
- Timezone support via `timezone` package

### 2. Core Components

#### 2.1 Notification Scheduler Service
Create a service to handle one-time notification scheduling:
- Calculate exact DateTime for 19:00 on the specified date
- Schedule notification using `flutter_local_notifications`
- Store scheduled notification ID in the Reminder model
- Handle timezone conversions properly

#### 2.2 Database Integration
Extend the existing Reminder repository:
- Store notification ID when scheduling
- Query reminders by transaction ID
- Support cancellation of scheduled notifications

#### 2.3 Notification Content
Format notification payload:
- Title: Transaction name
- Body: Amount and remaining balance
- Payload: Transaction ID for navigation

### 3. Implementation Steps

#### Step 1: Create Notification Scheduler Service
Location: `lib/core/services/notification_scheduler.dart`
- Method: `scheduleOneTimeReminder(Reminder reminder, Transaction transaction)`
- Calculate target DateTime at 19:00
- Use `zonedSchedule` from flutter_local_notifications
- Return scheduled notification ID

#### Step 2: Update Reminder Repository
Location: `lib/data/repositories/reminder_repository.dart`
- Add method to save notification ID with reminder
- Add method to retrieve notification ID
- Integrate with scheduler service

#### Step 3: Integrate with Transaction Form
Location: Transaction form screen (already has UI from TASK-0037)
- Connect "one-time" reminder option to scheduler
- Save reminder with notification ID to database
- Handle scheduling errors with user feedback

#### Step 4: Add Cancellation Support
- Implement cancellation in scheduler service
- Call cancellation when reminder is deleted
- Call cancellation when transaction is marked complete

### 4. File Structure
```
lib/
├── core/
│   └── services/
│       └── notification_scheduler.dart (NEW)
├── data/
│   └── repositories/
│       └── reminder_repository.dart (UPDATE)
└── features/
    └── transactions/
        └── presentation/
            └── screens/
                └── transaction_form_screen.dart (UPDATE)
```

### 5. Testing Strategy

#### Unit Tests
- Test DateTime calculation for 19:00 scheduling
- Test timezone handling
- Test notification ID storage and retrieval

#### Widget Tests
- Verify UI interaction with scheduler
- Test error handling display

#### Integration Tests
- Schedule a one-time reminder
- Verify notification ID is stored
- Verify notification can be cancelled
- Test with different dates (today, tomorrow, future)

### 6. Edge Cases to Handle
1. Selected date is in the past
2. Selected time is today but after 19:00
3. App is uninstalled/reinstalled (notifications are lost)
4. Timezone changes
5. Permission denied for notifications
6. Scheduler service fails

### 7. Success Criteria
- ✓ User can schedule one-time reminder from transaction form
- ✓ Notification fires at exactly 19:00 on specified date
- ✓ Notification displays transaction name, amount, and balance
- ✓ Notification is cancelled when transaction is completed
- ✓ Notification ID is persisted in database
- ✓ Error handling provides user feedback
- ✓ All tests pass

## Dependencies on Other Tasks
- Requires TASK-0041 for notification content formatting (can be implemented inline if needed)
- Blocks TASK-0040 (automatic cancellation on completion)

## Estimated Complexity
Medium - Requires integration of existing notification infrastructure with reminder system, proper DateTime handling, and robust error management.
