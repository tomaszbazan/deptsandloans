# TASK-0009: Create Repayment Model - Implementation Plan

## Task Overview

**Objective:** Define Repayment entity with fields: id, transactionId, amount, date, timestamp

**Category:** Data Layer & Models

**Dependencies:** TASK-0008 (Transaction Model) - ✅ Completed

## Current State Analysis

Based on the codebase exploration:

- Transaction model exists at `lib/domain/models/transaction.dart`
- Using `json_serializable` with `fieldRename: FieldRename.snake`
- Models are located in `lib/domain/models/` directory
- Project uses Isar Community for local database storage
- Code generation is configured with `build_runner`

## Requirements

The Repayment model must include:

1. **id** - Unique identifier for the repayment record
2. **transactionId** - Reference to the parent Transaction
3. **amount** - The amount being repaid
4. **when** - The date when the repayment was made
5. **createdAt** - Additional timestamp field for record tracking

## Implementation Steps

### 1. Create Repayment Model File

**File:** `lib/domain/models/repayment.dart`

**Rationale:**
- Follow existing project structure (models in `lib/domain/models/`)
- Maintain consistency with Transaction model architecture
- Use Isar annotations for database persistence
- Use JSON serialization for potential data export/import

**Key Decisions:**
- Use `String` for id (consistent with Transaction model)
- Use `String` for transactionId to reference Transaction.id
- Use `int` for amount (monetary values)
- Use `DateTime` for both date and timestamp
- Distinguish between `when` (user-facing repayment date) and `createdAt` (record creation time)

### 2. Add Isar Annotations

**Requirements:**
- `@collection` - Mark class as Isar collection
- `@Index()` on transactionId - Enable efficient querying by transaction
- Proper field type mappings for Isar

**Rationale:**
- Isar is the chosen database solution (per TASK-0003)
- Indexing transactionId enables fast lookups of all repayments for a transaction
- Essential for calculating remaining balance and displaying repayment history

### 3. Add JSON Serialization

**Requirements:**
- `@JsonSerializable(fieldRename: FieldRename.snake)` annotation
- Generate `fromJson` and `toJson` methods
- Create `part 'repayment.g.dart';` directive

**Rationale:**
- Maintain consistency with Transaction model pattern
- Enable potential future features (export/import, API sync)
- snake_case conversion for JSON compatibility

### 4. Add Validation Logic

**Validation Rules:**
- amount > 0 (repayments must be positive)
- when must not be in the future (cannot repay in future)
- createdAt should be auto-generated on creation

**Implementation:**
- Use assertions in constructor (consistent with Transaction model)
- Provide factory constructor for creating new repayments with auto-timestamp

### 5. Add Helper Methods

**Suggested Methods:**
- `copyWith()` - For immutability pattern
- Factory constructor for creating new repayments with auto-generated timestamp
- Equality comparison (if needed for testing)

### 6. Run Code Generation

**Commands:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Purpose:**
- Generate `repayment.g.dart` for JSON serialization
- Generate Isar collection code

### 7. Verification Steps

**Testing:**
1. Verify model compiles without errors
2. Run `flutter analyze` to check for issues
3. Ensure code generation completes successfully
4. Validate all fields are properly serialized/deserialized
5. Test validation rules with edge cases

## File Structure

```
lib/domain/models/
├── currency.dart
├── repayment.dart          # NEW FILE
├── repayment.g.dart        # GENERATED
├── transaction.dart
├── transaction.g.dart
├── transaction_status.dart
└── transaction_type.dart
```

## Data Model Relationships

```
Transaction (1) ───< (many) Repayment
     │                         │
     └─── id ───────────────── transactionId
```

## Example Usage (Future)

```dart
// Create a repayment
final repayment = Repayment.create(
  transactionId: transaction.id,
  amount: 100.00,
  date: DateTime.now(),
);

// Query repayments for a transaction
final repayments = await isarDB.repayments
  .where()
  .transactionIdEqualTo(transactionId)
  .findAll();

// Calculate total repaid
final totalRepaid = repayments
  .fold<double>(0, (sum, r) => sum + r.amount);
```

## Considerations

### Database Schema

The Repayment model will create an Isar collection with:
- Primary key: id (String, auto-generated UUID)
- Index: transactionId (for efficient queries)
- Fields: amount, date, timestamp

### JSON Schema

When serialized, the model will produce:
```json
{
  "id": "uuid-string",
  "transaction_id": "parent-transaction-uuid",
  "amount": 100.00,
  "date": "2025-11-25T10:00:00.000Z",
  "timestamp": "2025-11-25T10:05:23.123Z"
}
```

### Data Integrity

- Repayments should only reference existing transactions
- When a transaction is deleted, associated repayments should be deleted (cascade)
- This will be handled in the Repository layer (TASK-0012)

## Next Tasks

After completing this task, the following become unblocked:
- **TASK-0012:** Implement Repayment Repository
- **TASK-0026:** Create Repayment Form
- **TASK-0028:** Calculate Remaining Balance

## Testing Strategy

### Unit Tests (to be created later in TASK-0052)

1. Model instantiation
2. Validation rules (positive amount, date not in future)
3. JSON serialization/deserialization
4. copyWith functionality
5. Edge cases (max/min values, null handling)

### Integration Tests (to be created later in TASK-0055)

1. Save repayment to database
2. Query repayments by transaction
3. Calculate remaining balance
4. Update transaction status when fully repaid

## Definition of Done

- [ ] `repayment.dart` created in `lib/domain/models/`
- [ ] Model includes all required fields: id, transactionId, amount, date, timestamp
- [ ] Isar annotations properly configured
- [ ] JSON serialization configured with snake_case
- [ ] Validation logic implemented
- [ ] copyWith method implemented
- [ ] Code generation runs successfully
- [ ] `flutter analyze` passes with no errors
- [ ] Model compiles and integrates with existing codebase

## Estimated Complexity

**Low-Medium** - Straightforward model creation following established patterns from Transaction model.

## Notes

- This model is foundational for the repayment tracking feature
- The distinction between `when` (user-specified repayment date) and `createdAt` (record creation) is important for audit trails
- Index on transactionId is critical for performance when displaying repayment history
