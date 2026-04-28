# TASK-0010: Create Reminder Model

## Goal
Define Reminder database entity with fields: id, transactionId, type (one-time/recurring), intervalDays, nextReminderDate, createdAt

## Analysis
Based on the existing codebase:
- Transaction and Repayment models are already implemented using Isar database
- Models are located in `lib/data/models/` directory
- Code generation is used with `isar_community` package
- Models follow a pattern with:
  - Isar collection annotation
  - Id field with auto-increment
  - JSON serialization support
  - Named constructors and factory methods

## Implementation Steps

### 1. Create Reminder Model Class
**File:** `lib/data/models/reminder.dart`

Define the `Reminder` class with:
- `@collection` annotation for Isar
- `Id id = Isar.autoIncrement` - auto-generated ID
- `int transactionId` - foreign key reference to Transaction
- `@enumerated` `ReminderType type` - enum for one-time/recurring
- `int? intervalDays` - nullable, only for recurring reminders
- `DateTime nextReminderDate` - when the next reminder should fire
- `DateTime createdAt` - timestamp of reminder creation

### 2. Create ReminderType Enum
**File:** `lib/data/models/reminder_type.dart`

Define enum with values:
- `oneTime` - single notification
- `recurring` - repeating notification

### 3. Add JSON Serialization
- Implement `toJson()` method
- Implement `fromJson()` factory constructor
- Use appropriate JSON field mappings

### 4. Generate Isar Schema
Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Create Unit Tests
**File:** `test/data/models/reminder_test.dart`

Test cases:
- Model instantiation with all required fields
- One-time reminder (intervalDays should be null)
- Recurring reminder (intervalDays should be set)
- JSON serialization (toJson)
- JSON deserialization (fromJson)
- Date handling for nextReminderDate and createdAt
- Validation that recurring reminders have intervalDays > 0

## Dependencies
- `isar_community` (already installed)
- `isar_flutter_libs` (already installed)
- `json_annotation` (already installed)
- `build_runner` (dev dependency, already installed)
- `isar_generator` (dev dependency, already installed)

## Files to Create/Modify
- **Create:** `lib/data/models/reminder.dart`
- **Create:** `lib/data/models/reminder_type.dart`
- **Create:** `lib/data/models/reminder.g.dart` (generated)
- **Create:** `test/data/models/reminder_test.dart`
- **Modify:** `lib/core/database/database_service.dart` - add Reminder schema to Isar instance

## Validation
- Run `flutter analyze` - should pass with no errors
- Run `flutter test` - all tests should pass
- Verify code generation produces `.g.dart` file
- Check that Reminder model follows same patterns as Transaction and Repayment

## Edge Cases to Consider
- One-time reminders must have null intervalDays
- Recurring reminders must have intervalDays > 0
- nextReminderDate must be in the future (validation in repository layer)
- Proper DateTime serialization to/from JSON

## References
- Existing Transaction model: `lib/data/models/transaction.dart`
- Existing Repayment model: `lib/data/models/repayment.dart`
- Database service: `lib/core/database/database_service.dart`
