# Implementation Plan: TASK-0013 - Implement Reminder Repository

## Task Description
Create repository layer for managing reminders with local Isar database integration.

## Current State Analysis
- ✅ Reminder model exists (`lib/data/models/reminder.dart`)
- ✅ Isar database is configured
- ✅ Similar repositories implemented (Transaction, Repayment) as reference patterns
- ❌ Reminder repository does not exist yet

## Implementation Steps

### 1. Create Reminder Repository Interface
**File:** `lib/data/repositories/reminder_repository.dart`

Define abstract interface with core operations:

**Required by backlog:**
- `createReminder(Reminder reminder)` - Create new reminder (TASK-0037, TASK-0038, TASK-0039)
- `getRemindersByTransactionId(int transactionId)` - Get all reminders for a transaction (TASK-0037 UI display)
- `deleteRemindersByTransactionId(int transactionId)` - Delete all reminders for a transaction (TASK-0040)
- `getActiveReminders()` - Get all active reminders for notification processing (TASK-0038, TASK-0039)
- `updateNextReminderDate(int id, DateTime nextDate)` - Update next reminder date for recurring reminders (TASK-0039)

### 2. Implement Isar Repository
**File:** `lib/data/repositories/isar_reminder_repository.dart`

Create concrete implementation:
- Constructor accepting `Isar` instance via dependency injection
- Implement all interface methods using Isar queries
- Handle null safety properly
- Use transactions for write operations
- Add proper error handling

### 3. Write Repository Tests
**File:** `test/data/repositories/isar_reminder_repository_test.dart`

Test suite covering:
- **Setup**: Open temporary Isar instance, initialize repository
- **Create operations**: Test reminder creation, verify stored data
- **Read operations**:
  - Get by ID (found/not found cases)
  - Get by transaction ID (empty/multiple results)
  - Get active reminders filtering
- **Update operations**:
  - Full reminder update
  - Next reminder date update for recurring reminders
- **Delete operations**:
  - Single reminder deletion
  - Bulk deletion by transaction ID
- **Edge cases**: Invalid IDs, null handling, concurrent operations
- **Teardown**: Close and delete test database

### 4. Integration Considerations
- Repository will be used by reminder notification service (future task)
- Must support both one-time and recurring reminder workflows
- Next reminder date updates are critical for recurring reminders
- Deletion by transaction ID needed when transactions are completed/deleted

## Technical Patterns to Follow
Based on existing codebase patterns:
- Use abstract class for repository interface
- Concrete implementation accepts Isar via constructor
- Use Isar transactions for write operations
- Return nullable types for single-item queries
- Return lists (can be empty) for multi-item queries
- Follow naming convention: `isar_[entity]_repository.dart`
- Test files use real Isar database (not mocks)
- Use `setUpAll`/`tearDownAll` for database lifecycle in tests

## Dependencies
- `isar` - Already configured
- `isar_flutter_libs` - Already configured
- `test` - For unit tests

## Acceptance Criteria
- ✅ Abstract repository interface defined
- ✅ Isar implementation complete with all CRUD operations
- ✅ All repository methods tested with real Isar database
- ✅ Tests achieve >95% code coverage
- ✅ Code passes `flutter analyze` with no issues
- ✅ All tests pass with `flutter test`

## Estimated Complexity
**Medium** - Straightforward repository implementation following established patterns, but requires careful handling of recurring reminder date updates.

## References
- Existing implementations:
  - `lib/data/repositories/transaction_repository.dart`
  - `lib/data/repositories/repayment_repository.dart`
  - `test/data/repositories/isar_transaction_repository_test.dart`
  - `test/data/repositories/isar_repayment_repository_test.dart`
- Reminder model: `lib/data/models/reminder.dart`
