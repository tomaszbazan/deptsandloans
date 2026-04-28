# Implementation Plan: TASK-0031 - Implement Manual Completion

## Task Description
Add option for user to manually mark transaction as completed at any time.

## Current State Analysis
- Transactions are automatically marked as completed when balance reaches zero (TASK-0030)
- Transaction model has status field to track completion state
- Transaction details screen exists showing transaction information
- Need to add UI control and logic for manual completion

## Implementation Steps

### 1. Update Transaction Model (if needed)
- Verify Transaction model supports manual completion flag
- Ensure status field can handle manually completed state
- Check if we need to distinguish between auto-completed and manually completed transactions

### 2. Update Transaction Repository
- Add method to manually mark transaction as completed: `markAsCompleted(String transactionId)`
- Update transaction status in database
- Ensure method handles validation (transaction must be active)

### 3. Create Manual Completion UI
- Add "Mark as Completed" button/action on transaction details screen
- Position it prominently but not intrusively (e.g., in app bar menu or as a secondary action button)
- Button should only be visible for active (non-completed) transactions

### 4. Implement Confirmation Dialog
- Show confirmation dialog before marking as completed
- Dialog should warn user that this action will:
  - Move transaction to archive
  - Cancel any active reminders
  - Mark remaining balance as forgiven/written off (if applicable)
- Provide clear "Confirm" and "Cancel" options

### 5. Handle Manual Completion Logic
- On confirmation:
  - Update transaction status to completed
  - Cancel any associated reminders (integrate with TASK-0040 logic)
  - Update UI to reflect new state
  - Navigate back or refresh the view
- Show success feedback (snackbar/toast)

### 6. Update Transaction List Display
- Ensure manually completed transactions appear in archive section
- Verify sorting and filtering work correctly with manually completed transactions

### 7. Add Localization Strings
- Add translations for:
  - "Mark as Completed" button text
  - Confirmation dialog title and message
  - Success/error messages
- Support both PL and EN locales

### 8. Write Tests
- Unit tests for repository method
- Widget tests for button visibility and interaction
- Widget tests for confirmation dialog
- Integration test for complete manual completion flow

### 9. Create Golden Test
- Add golden test for transaction details screen with "Mark as Completed" button
- Test both light and dark themes

## Files to Modify/Create

### Existing Files to Modify
- `lib/data/repositories/transaction_repository.dart` - Add manual completion method
- `lib/presentation/screens/transaction_details_screen.dart` - Add UI controls
- `lib/l10n/app_en.arb` - Add English translations
- `lib/l10n/app_pl.arb` - Add Polish translations

### New Test Files
- `test/data/repositories/transaction_repository_manual_completion_test.dart`
- `test/presentation/screens/transaction_details_manual_completion_test.dart`
- `test/goldens/transaction_details_with_manual_completion_test.dart`

## Technical Considerations
- Ensure manual completion respects transaction state transitions
- Consider if partially repaid transactions should show remaining balance before completion
- Ensure reminder cancellation is handled properly (may need to coordinate with TASK-0040)
- Verify archive section handles manually completed transactions correctly

## Acceptance Criteria
- [ ] User can manually mark active transaction as completed from details screen
- [ ] Confirmation dialog appears before completion
- [ ] Transaction moves to archive after manual completion
- [ ] Success feedback is shown to user
- [ ] Reminders are cancelled (if implemented)
- [ ] UI updates correctly after completion
- [ ] All tests pass including golden tests
- [ ] Both locales (PL/EN) work correctly

## Dependencies
- None (standalone feature)
- Optional: TASK-0040 (for reminder cancellation integration)

## Estimated Complexity
Low to Medium - Straightforward feature with UI, repository, and state management components.
