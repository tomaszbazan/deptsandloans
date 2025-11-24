# TASK-0008: Create Transaction Model - Implementation Plan

## Task Description
Define Transaction entity with fields: id, type (debt/loan), name, amount, currency, description, dueDate, status

## Prerequisites
- Flutter project initialized ✓
- Local database configured (sqflite/hive/isar) ✓
- json_serializable and json_annotation packages

## Implementation Steps

### 1. Add Required Dependencies
- Verify `json_annotation` is in dependencies
- Verify `json_serializable` and `build_runner` are in dev_dependencies
- Run `flutter pub get` if packages need to be added

### 2. Create Transaction Model File
**Location:** `lib/domain/models/transaction.dart`

**Fields to implement:**
- `String id` - Unique identifier (UUID)
- `TransactionType type` - Enum: debt or loan
- `String name` - Transaction party name (required, non-empty)
- `double amount` - Initial amount (required, positive)
- `Currency currency` - Enum: PLN, EUR, USD, GBP
- `String? description` - Optional description (max 200 characters)
- `DateTime? dueDate` - Optional due date
- `TransactionStatus status` - Enum: active or completed
- `DateTime createdAt` - Creation timestamp
- `DateTime updatedAt` - Last update timestamp

### 3. Create Supporting Enums

**TransactionType enum** (`lib/domain/models/transaction_type.dart`):
```dart
enum TransactionType {
  debt,  // Money I owe to others
  loan   // Money others owe to me
}
```

**Currency enum** (`lib/domain/models/currency.dart`):
```dart
enum Currency {
  pln,
  eur,
  usd,
  gbp
}
```

**TransactionStatus enum** (`lib/domain/models/transaction_status.dart`):
```dart
enum TransactionStatus {
  active,
  completed
}
```

### 4. Implement Transaction Model Class

**Key features:**
- Immutable class with `@JsonSerializable` annotation
- Use `fieldRename: FieldRename.snake` for JSON serialization
- Include `fromJson` factory constructor
- Include `toJson` method
- Implement `copyWith` method for immutability
- Add validation in constructor if needed

**Example structure:**
```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class Transaction {
  final String id;
  final TransactionType type;
  final String name;
  final double amount;
  final Currency currency;
  final String? description;
  final DateTime? dueDate;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  // fromJson factory
  // toJson method
  // copyWith method
}
```

### 5. Generate JSON Serialization Code
Run build_runner to generate the `*.g.dart` file:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Create Helper Methods

Consider adding to the Transaction class:
- `bool get isOverdue` - Check if transaction is overdue
- `bool get isActive` - Check if transaction is active
- `bool get isCompleted` - Check if transaction is completed

### 7. Validation

Add validation logic:
- Name must not be empty
- Amount must be positive
- Description max 200 characters (if provided)

### 8. Testing

Create test file: `test/domain/models/transaction_test.dart`

**Test cases:**
- Model creation with all fields
- Model creation with minimal fields (only required)
- JSON serialization (toJson)
- JSON deserialization (fromJson)
- copyWith method functionality
- Validation rules (name, amount, description length)
- Helper methods (isOverdue, isActive, isCompleted)
- Enum conversions

### 9. Documentation

Add dartdoc comments to:
- Class definition
- All public fields
- Factory constructors
- Methods

## File Structure
```
lib/
  domain/
    models/
      transaction.dart
      transaction.g.dart (generated)
      transaction_type.dart
      currency.dart
      transaction_status.dart

test/
  domain/
    models/
      transaction_test.dart
```

## Dependencies to Add (if missing)
```yaml
dependencies:
  json_annotation: ^4.9.0

dev_dependencies:
  json_serializable: ^6.8.0
  build_runner: ^2.4.0
```

## Verification Steps
1. Run `flutter analyze` - no errors
2. Run `flutter test` - all tests pass
3. Verify JSON serialization works correctly
4. Verify all enum values serialize/deserialize properly
5. Verify validation rules work as expected

## Success Criteria
- Transaction model created with all required fields
- Enums defined for type, currency, and status
- JSON serialization working (toJson/fromJson)
- copyWith method implemented
- Validation logic in place
- Unit tests written and passing
- No analyzer warnings
- Code follows Dart style guidelines

## Related Tasks
- TASK-0009: Create Repayment Model (depends on Transaction model)
- TASK-0010: Create Reminder Model (depends on Transaction model)
- TASK-0011: Implement Transaction Repository (uses Transaction model)

## Notes
- This is a foundational model for the entire application
- Consider immutability best practices throughout
- Ensure proper null safety usage
- Use const constructors where possible
