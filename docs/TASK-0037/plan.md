# Implementation Plan: TASK-0037 - Implement Reminder Configuration UI

## Task Description
Add UI controls in transaction form for setting one-time or recurring reminders

## Prerequisites
- TASK-0036 (Setup Push Notifications) is completed
- Transaction form screen exists and is functional
- Reminder model and repository are implemented (TASK-0010, TASK-0013)

## Analysis

### Current State
Based on the backlog:
- Push notifications are set up (TASK-0036 completed)
- Transaction model, Repayment model, and Reminder model exist (TASK-0008, TASK-0009, TASK-0010 completed)
- Transaction repositories are implemented (TASK-0011, TASK-0012, TASK-0013 completed)
- Transaction form screen exists (TASK-0014 completed)

### Requirements
The reminder configuration UI should allow users to:
1. Choose whether to set a reminder or not
2. Select reminder type: one-time or recurring
3. For one-time reminders: select a specific date
4. For recurring reminders: specify interval in days
5. All reminders trigger at 19:00 (as per TASK-0038, TASK-0039)

## Implementation Steps

### Step 1: Update Reminder Model (if needed)
**File**: `lib/data/models/reminder.dart` or equivalent

Review the existing Reminder model to ensure it has:
- `id`: Unique identifier
- `transactionId`: Foreign key to transaction
- `type`: Enum or string for one-time/recurring
- `intervalDays`: Number of days for recurring reminders (nullable for one-time)
- `nextReminderDate`: DateTime for the next scheduled reminder
- `createdAt`: Timestamp

### Step 2: Create Reminder Type Enum
**File**: `lib/core/enums/reminder_type.dart` (new file)

```dart
enum ReminderType {
  oneTime,
  recurring,
}
```

### Step 3: Add Reminder State to Transaction Form
**File**: Update the transaction form widget (likely `lib/presentation/screens/transaction_form_screen.dart` or similar)

Add state variables:
- `bool _enableReminder = false`
- `ReminderType? _reminderType`
- `DateTime? _oneTimeReminderDate`
- `int? _recurringIntervalDays`

### Step 4: Create Reminder Configuration Widget
**File**: `lib/presentation/widgets/reminder_configuration_widget.dart` (new file)

Create a reusable widget that includes:
- Switch/Checkbox to enable/disable reminders
- Radio buttons or dropdown to select reminder type (one-time/recurring)
- Date picker for one-time reminders
- Number input for recurring interval days
- Conditional rendering based on selected type

### Step 5: Integrate Widget into Transaction Form
**File**: Transaction form screen

Add the ReminderConfigurationWidget to the form:
- Position it after the due date field
- Pass callback functions to handle state changes
- Ensure proper form validation

### Step 6: Update Form Validation
**File**: Transaction form screen

Add validation rules:
- If reminder is enabled, reminder type must be selected
- For one-time reminders, date must be selected and in the future
- For recurring reminders, interval must be > 0 and reasonable (e.g., 1-365 days)

### Step 7: Update Save Transaction Logic
**File**: Transaction form screen and repository layer

When saving a transaction:
- If reminder is enabled, create and save a Reminder record
- Link the reminder to the transaction via `transactionId`
- Calculate `nextReminderDate` based on type:
  - One-time: use selected date at 19:00
  - Recurring: use current date + interval days at 19:00

### Step 8: Handle Edit Transaction Scenario
**File**: Transaction form screen

When editing an existing transaction:
- Load existing reminder data if present
- Pre-populate the reminder configuration UI
- Allow updating or removing reminders
- Handle deletion of old reminder if type changes or reminder is disabled

### Step 9: Add Localization Strings
**Files**: `lib/l10n/app_en.arb` and `lib/l10n/app_pl.arb`

Add translation keys for:
- "Enable reminder"
- "Reminder type"
- "One-time reminder"
- "Recurring reminder"
- "Reminder date"
- "Repeat every X days"
- "Days"
- Validation error messages

### Step 10: Create Widget Tests
**File**: `test/presentation/widgets/reminder_configuration_widget_test.dart` (new file)

Test:
- Widget renders correctly
- Switch toggles reminder on/off
- Reminder type selection works
- Date picker opens and sets date
- Interval input accepts valid values
- Validation messages appear for invalid inputs

### Step 11: Create Golden Tests
**File**: `test/presentation/widgets/reminder_configuration_widget_golden_test.dart` (new file)

Create golden tests for:
- Reminder disabled state
- One-time reminder selected
- Recurring reminder selected
- Error states

### Step 12: Integration Testing
**File**: `test/integration/transaction_with_reminder_test.dart` (new file)

Test end-to-end flow:
- Create transaction with one-time reminder
- Create transaction with recurring reminder
- Edit transaction to add reminder
- Edit transaction to remove reminder
- Verify reminder is saved to database

## Files to Create
1. `lib/core/enums/reminder_type.dart`
2. `lib/presentation/widgets/reminder_configuration_widget.dart`
3. `test/presentation/widgets/reminder_configuration_widget_test.dart`
4. `test/presentation/widgets/reminder_configuration_widget_golden_test.dart`
5. `test/integration/transaction_with_reminder_test.dart`

## Files to Modify
1. Transaction form screen (exact path TBD - needs codebase exploration)
2. Transaction repository (to handle reminder creation/update)
3. `lib/l10n/app_en.arb`
4. `lib/l10n/app_pl.arb`

## Testing Strategy
1. Unit tests for reminder type enum
2. Widget tests for ReminderConfigurationWidget
3. Golden tests for visual regression
4. Integration tests for full transaction + reminder flow
5. Manual testing on Android device

## Validation Criteria
- [ ] User can enable/disable reminders on transaction form
- [ ] User can select one-time or recurring reminder type
- [ ] Date picker appears for one-time reminders
- [ ] Interval input appears for recurring reminders
- [ ] Form validation prevents invalid reminder configurations
- [ ] Reminder is saved to database when transaction is created
- [ ] Existing reminders are loaded when editing transaction
- [ ] All UI strings are localized in Polish and English
- [ ] All tests pass (`flutter test`)
- [ ] No analysis errors (`flutter analyze`)
- [ ] Code is formatted (`dart format .`)
- [ ] Golden tests pass for all reminder states

## Dependencies
No new dependencies required. Existing dependencies should cover:
- Date picker: Material DatePicker
- Form validation: Flutter form validation
- State management: Existing solution (ValueNotifier/ChangeNotifier)
- Database: Existing local database (sqflite/hive/isar)

## Notes
- This task focuses only on the UI for reminder configuration
- Actual notification scheduling will be implemented in TASK-0038 and TASK-0039
- Notification cancellation on completion will be handled in TASK-0040
- Reminder time is hardcoded to 19:00 as per requirements

## Estimated Complexity
Medium - requires UI work, form validation, database integration, and comprehensive testing
