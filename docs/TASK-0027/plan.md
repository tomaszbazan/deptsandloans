# Implementation Plan: TASK-0027 - Implement Repayment Validation

## Task Description
Prevent entering repayment amount exceeding remaining balance

## Current State Analysis

### Existing Components
- Repayment form UI exists (TASK-0026 completed)
- Repayment model and repository are implemented
- Transaction model with initial amount field exists

### Missing Components
- Validation logic for repayment amount
- Calculation of remaining balance before validation
- User feedback mechanism for invalid amounts

## Implementation Steps

### 1. Analyze Current Repayment Form Implementation
- Read the repayment form widget to understand current structure
- Identify where amount input validation should be added
- Check if remaining balance calculation already exists

### 2. Implement Remaining Balance Calculation
- Create a method to calculate remaining balance:
  - Get transaction initial amount
  - Fetch all repayments for the transaction
  - Sum all repayment amounts
  - Return: initial amount - sum of repayments
- Location: Could be in Transaction model, Repository, or ViewModel/Controller

### 3. Add Validation Logic to Repayment Form
- Add validator to amount TextFormField
- Validate that entered amount > 0
- Validate that entered amount <= remaining balance
- Return appropriate error messages for each validation failure

### 4. Display User-Friendly Error Messages
- Add localized error messages:
  - "Amount must be greater than zero"
  - "Amount cannot exceed remaining balance (XXX PLN)"
- Ensure error messages appear near the input field
- Consider using FormField's validator return value

### 5. Real-time Feedback (Optional Enhancement)
- Consider showing remaining balance above/below input field
- Update validation as user types (onChanged callback)
- Disable submit button if validation fails

### 6. Testing
- Add unit tests for remaining balance calculation
- Add widget tests for validation logic
- Test edge cases:
  - Exactly remaining balance amount (should be valid)
  - One unit over remaining balance (should fail)
  - Zero amount (should fail)
  - Negative amount (should fail)
- Add golden tests if UI changes are significant

## Files to Modify

### Primary Files
- `lib/features/repayments/presentation/repayment_form_screen.dart` (or similar path)
- Possibly create: `lib/features/transactions/domain/transaction_extensions.dart` for balance calculation

### Secondary Files
- `lib/l10n/app_en.arb` - Add English error messages
- `lib/l10n/app_pl.arb` - Add Polish error messages
- `test/features/repayments/presentation/repayment_form_test.dart` - Widget tests
- `test/features/transactions/domain/transaction_test.dart` - Unit tests

## Technical Considerations

### Validation Approach
```dart
// Option 1: In form validator
validator: (value) {
  if (value == null || value.isEmpty) {
    return context.l10n.amountRequired;
  }
  final amount = double.tryParse(value);
  if (amount == null || amount <= 0) {
    return context.l10n.amountMustBePositive;
  }
  if (amount > remainingBalance) {
    return context.l10n.amountExceedsBalance(remainingBalance);
  }
  return null;
}
```

### Remaining Balance Calculation
```dart
// Option 2: As Transaction extension
extension TransactionBalance on Transaction {
  Future<double> getRemainingBalance(RepaymentRepository repo) async {
    final repayments = await repo.getRepaymentsForTransaction(id);
    final totalRepaid = repayments.fold<double>(
      0,
      (sum, repayment) => sum + repayment.amount
    );
    return amount - totalRepaid;
  }
}
```

## Dependencies
- No new external dependencies required
- Uses existing form validation framework
- May need access to RepaymentRepository in form

## Acceptance Criteria
- [ ] User cannot submit repayment amount greater than remaining balance
- [ ] User cannot submit zero or negative repayment amount
- [ ] Clear error message displayed when validation fails
- [ ] Error message shows the remaining balance amount
- [ ] Form validator works in both Polish and English
- [ ] All existing tests still pass
- [ ] New tests cover validation edge cases
- [ ] Code passes `flutter analyze`
- [ ] Code formatted with `dart format`

## Estimated Complexity
**Medium** - Requires coordination between form validation, data fetching, and localization

## Risks & Mitigations
- **Risk**: Race condition if multiple repayments are being added simultaneously
  - **Mitigation**: Use transactions in database if supported, or optimistic locking
- **Risk**: Performance issue fetching all repayments on every validation
  - **Mitigation**: Cache remaining balance in form state, refresh only when needed
- **Risk**: Currency conversion if multi-currency support exists
  - **Mitigation**: Ensure repayment is in same currency as transaction

## Notes
- This task is related to TASK-0028 (Calculate Remaining Balance) - they may share implementation
- Consider whether remaining balance calculation should be extracted as a separate service/utility
- Keep validation logic close to the UI for better user experience
