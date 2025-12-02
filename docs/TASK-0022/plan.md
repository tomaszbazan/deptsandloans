# TASK-0022: Implement Transaction Sorting

## Objective
Sort active transactions by due date (ascending), placing transactions without due date at the bottom.

## Current State Analysis
- Transaction model exists with optional `dueDate` field
- Transaction repository implements CRUD operations
- Main screen displays transactions in two tabs: "My Debts" and "My Loans"
- Transaction list widgets are already implemented

## Implementation Plan

### 1. Analyze Current Transaction List Implementation
- [ ] Read the transaction list widget to understand current data flow
- [ ] Identify where transactions are fetched and displayed
- [ ] Check if any sorting logic already exists

### 2. Update Repository Layer
- [ ] Add sorting logic to transaction repository queries
- [ ] Implement comparator that:
  - Sorts transactions with due dates in ascending order (earliest first)
  - Places transactions without due dates at the end
  - Handles null safety properly

### 3. Implement Sorting Logic
- [ ] Create a comparison function

### 4. Update Database Queries
- [ ] Modify transaction repository methods to apply sorting
- [ ] Focus on methods that return lists of active transactions
- [ ] Ensure sorting is applied before returning results

### 5. Testing Strategy
- [ ] Write unit tests for the sorting logic:
  - Test transactions with all having due dates
  - Test transactions with none having due dates
  - Test mixed scenario (some with, some without)
  - Test edge cases (same due dates, past dates, future dates)
- [ ] Write widget tests to verify correct order in UI
- [ ] Test both "My Debts" and "My Loans" tabs

### 6. Verification
- [ ] Run `flutter analyze` to ensure no issues
- [ ] Run `flutter test` to verify all tests pass
- [ ] Run `dart format .` to format code
- [ ] Manually test the UI to confirm sorting works as expected

## Expected Changes

### Files to Modify
1. `lib/data/repositories/transaction_repository.dart` - Add sorting logic
2. `test/data/repositories/transaction_repository_test.dart` - Add sorting tests
3. Potentially widget test files if sorting affects UI layer

### Files to Review
1. `lib/domain/models/transaction.dart` - Verify dueDate field structure
2. `lib/presentation/widgets/transaction_list_widget.dart` - Understand display logic
3. `lib/presentation/screens/main_screen.dart` - Verify data flow

## Acceptance Criteria
- [ ] Active transactions are sorted by due date in ascending order
- [ ] Transactions without due dates appear at the bottom of the list
- [ ] Sorting works correctly for both debts and loans
- [ ] All existing tests continue to pass
- [ ] New tests cover the sorting functionality
- [ ] Code passes `flutter analyze` with no issues
- [ ] Code is properly formatted with `dart format`

## Notes
- This task only affects active transactions, not archived/completed ones
- The sorting should be consistent across both tabs (My Debts and My Loans)
- Consider performance implications if the transaction list grows large
- Maintain immutability principles when sorting
