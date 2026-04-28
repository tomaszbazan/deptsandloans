# TASK-0011: Implement Transaction Repository

## Overview
Create a repository layer for CRUD operations on transactions with local database (Isar). This repository will serve as an abstraction layer between the domain logic and data persistence.

## Prerequisites
- Transaction model is already implemented with Isar integration (TASK-0008 ✓)
- Isar database is configured (TASK-0003 ✓)

## Implementation Steps

### 1. Define Repository Interface
Create an abstract interface that defines the contract for transaction operations:
- `Future<void> create(Transaction transaction)` - Add new transaction
- `Future<List<Transaction>> getByType(TransactionType type)` - Get transactions by type (debt/loan)
- `Future<void> update(Transaction transaction)` - Update existing transaction
- `Future<void> delete(int id)` - Delete transaction by ID

### 2. Implement Isar-based Repository
Create concrete implementation using Isar database:
- Inject Isar instance via constructor
- Implement all CRUD operations using Isar API
- Handle proper error handling and edge cases
- Ensure transactions are properly sorted (by due date for queries that need it)

### 3. Repository Structure
```
lib/
  data/
    repositories/
      transaction_repository.dart         # Abstract interface
      transaction_repository_impl.dart    # Isar implementation
```

### 4. Key Implementation Details

#### Create Operation
- Validate transaction data
- Use `isar.transactions.put()` to save
- Wrap in `isar.writeTxn()` for atomic operation

#### Read Operations
- Use `isar.transactions.where()` for type-based queries
- Return transactions filtered by type (debt/loan)
- Implement proper indexing on frequently queried fields (type, status, dueDate)

#### Update Operation
- Verify transaction exists before updating
- Preserve immutable fields (e.g., initial amount)
- Use `isar.transactions.put()` with existing ID

#### Delete Operation
- Check for related data (repayments, reminders) - to be handled in later tasks
- Use `isar.transactions.delete()` within write transaction

### 5. Error Handling
- Define custom repository exceptions:
  - `TransactionNotFoundException`
  - `TransactionRepositoryException`
- Wrap Isar errors in domain-specific exceptions
- Log errors appropriately

### 6. Testing Strategy

#### Integration Tests
- Use real Isar database instances for testing
- Create temporary test database for each test case
- Test each CRUD operation independently with actual database operations
- Test error scenarios (not found, validation errors)
- Properly clean up test databases after each test

#### Test Coverage Goals
- All public methods tested
- Edge cases covered (null values, empty results)
- Error handling verified
- Both success and error scenarios tested

**Note:** Initially implemented with mocks using `mocktail`, but later converted to use real Isar database for more reliable integration testing, following the same pattern as repayment repository tests.

## Dependencies
- `isar` - Already added (database)
- `isar_flutter_libs` - Already added (native libraries)
- `mocktail` - Already added (for testing)

## Files to Create
1. `lib/data/repositories/transaction_repository.dart` - Abstract interface
2. `lib/data/repositories/transaction_repository_impl.dart` - Implementation
3. `lib/data/repositories/exceptions/repository_exceptions.dart` - Custom exceptions
4. `test/data/repositories/transaction_repository_test.dart` - Unit tests

## Acceptance Criteria
- [ ] Abstract repository interface defined with all required methods
- [ ] Concrete Isar implementation completed
- [ ] All CRUD operations working correctly
- [ ] Custom exceptions defined and used
- [ ] Unit tests written with >90% coverage
- [ ] All tests passing (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Code follows project conventions (SOLID principles, proper naming)

## Future Considerations
- This repository will be extended in later tasks to:
  - Handle cascade operations with repayments (TASK-0012)
  - Handle cascade operations with reminders (TASK-0013)
  - Implement complex queries for sorting and filtering (TASK-0022, TASK-0023)
  - Calculate balances based on repayments (TASK-0028)

## Estimated Complexity
Medium - Straightforward CRUD implementation with Isar, but requires careful attention to:
- Proper async/await handling
- Error handling patterns
- Test coverage
