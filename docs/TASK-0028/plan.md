# Implementation Plan: TASK-0028 - Calculate Remaining Balance

## Task Description
Implement logic to calculate current balance based on initial amount and repayments.

## Current State Analysis
- Transaction model exists with `amount` field (initial amount)
- Repayment model exists with `amount` field and `transactionId` reference
- Repayment repository provides CRUD operations for repayments
- Transaction details screen exists and needs to display remaining balance

## Implementation Steps

### 1. Add Balance Calculation Method to Transaction Repository
**File:** `lib/data/repositories/transaction_repository.dart`

Add a method to calculate remaining balance:
```dart
Future<double> calculateRemainingBalance(int transactionId)
```

Logic:
- Get transaction by ID to retrieve initial amount
- Query all repayments for the transaction
- Sum all repayment amounts
- Return: initial amount - total repayments

### 2. Add Balance Field to Transaction Display Model
**File:** Consider creating a view model or extending transaction data

Options:
- Add computed property to Transaction model
- Create a TransactionWithBalance view model
- Calculate on-the-fly in UI layer

Recommendation: Calculate in repository/service layer and pass to UI.

### 3. Update Transaction Details Screen
**File:** `lib/presentation/screens/transaction_details_screen.dart`

- Fetch remaining balance when screen loads
- Display remaining balance prominently
- Update balance display after recording new repayment
- Ensure balance is formatted with proper currency

### 4. Update Transaction List Widget
**File:** `lib/presentation/widgets/transaction_list_widget.dart`

- Fetch and display remaining balance for each transaction in the list
- Show both initial amount and remaining balance
- Consider performance: batch calculate balances for all visible transactions

### 5. Add Balance to Transaction Query Methods
Enhance repository methods to optionally include balance:
- `getAllTransactions()` - include balance for list display
- `getTransactionById()` - include balance for details screen

## Technical Considerations

### Performance
- Cache balance calculations if needed
- Consider adding a `remainingBalance` field to database and updating it on repayment CRUD
- For MVP, calculating on-demand is acceptable

### Data Integrity
- Handle edge cases:
  - No repayments yet (balance = initial amount)
  - Repayments exceed initial amount (should not happen with validation)
  - Transaction with zero amount

### Testing
- Unit tests for balance calculation logic
- Widget tests for balance display
- Test edge cases (no repayments, full repayment, partial repayment)

## Dependencies
- Requires completed TASK-0027 (repayment validation)
- Blocks TASK-0029 (progress bar - needs balance calculation)
- Blocks TASK-0030 (auto-completion - needs balance to detect zero)

## Files to Modify
1. `lib/data/repositories/transaction_repository.dart` - Add balance calculation
2. `lib/presentation/screens/transaction_details_screen.dart` - Display balance
3. `lib/presentation/widgets/transaction_list_widget.dart` - Display balance in list
4. Consider creating: `lib/domain/models/transaction_with_balance.dart` - View model

## Acceptance Criteria
- [ ] Remaining balance is calculated correctly (initial amount - sum of repayments)
- [ ] Balance is displayed on transaction details screen
- [ ] Balance is displayed in transaction list
- [ ] Balance updates immediately after recording a repayment
- [ ] Balance is formatted with proper currency symbol
- [ ] Unit tests verify calculation logic
- [ ] Widget tests verify balance display
- [ ] Code passes `flutter analyze`
- [ ] Code is formatted with `dart format`
