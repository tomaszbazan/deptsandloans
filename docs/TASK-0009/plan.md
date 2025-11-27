# TASK-0009: Create Repayment Model - Implementation Plan

## Objective
Define Repayment database entity with Isar to track partial and full repayments for transactions.

## Requirements
Based on the backlog and existing Transaction model implementation:
- **id**: Unique identifier (Isar auto-increment)
- **transactionId**: Reference to parent Transaction
- **amount**: Repayment amount in cents (int, matching Transaction.amount type)
- **when**: DateTime when repayment was made
- **createdAt**: DateTime when record was created

## Implementation Steps

### 1. Create Repayment Model Class
- Location: `lib/domain/models/repayment.dart`
- Define `@collection` annotated class for Isar
- Fields:
  - `Id id = Isar.autoIncrement` - Auto-generated unique identifier
  - `int transactionId` - Foreign key to Transaction
  - `int amount` - Repayment amount in cents (non-negative)
  - `DateTime when` - When the repayment occurred
  - `DateTime createdAt` - Timestamp of record creation

### 2. Add Validation
- Ensure `amount` is non-negative (≥ 0)
- Ensure `transactionId` references a valid transaction
- Set `createdAt` automatically if not provided
- Ensure `when` is not greater than now

### 3. Add Indexes
- Index on `transactionId` for efficient querying of repayments by transaction
- Consider compound index on `(transactionId, when)` for chronological queries

### 4. Generate Isar Code
- Add `part 'repayment.g.dart';` directive
- Run: `dart run build_runner build --delete-conflicting-outputs`

### 5. Update DatabaseService
- Location: `lib/core/database/database_service.dart`
- Add `Repayment` schema to Isar instance initialization
- Import the Repayment model

### 6. Write Unit Tests
- Location: `test/domain/models/repayment_test.dart`
- Test cases:
  - Model instantiation with valid data
  - Validation of non-negative amounts
  - DateTime handling for `when` and `createdAt`
  - Isar serialization/deserialization
  - Index queries by transactionId

### 7. Verify Implementation
- Run `flutter analyze` to check for issues
- Run `flutter test` to verify all tests pass
- Check that code generation completed successfully

## Dependencies
- ✅ `isar_community` package (already configured)
- ✅ `isar_flutter_libs` (already configured)
- ✅ `build_runner` (dev dependency, already configured)
- ✅ `isar_generator` (dev dependency, already configured)

## Success Criteria
- [ ] Repayment model class created with all required fields
- [ ] Proper Isar annotations and indexes applied
- [ ] Code generation completed without errors
- [ ] DatabaseService updated with Repayment schema
- [ ] Unit tests written and passing
- [ ] `flutter analyze` shows no issues
- [ ] `flutter test` passes all tests

## Notes
- Follow the pattern established in `Transaction` model (TASK-0008)
- Amount stored as `int` (cents) to avoid floating-point precision issues
- Consider relationship with Transaction model for future repository implementation
- The `when` field allows backdating repayments if needed
