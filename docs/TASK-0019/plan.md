# Implementation Plan: Delete Transaction (TASK-0019)

## Task Description
Add functionality to delete transactions with confirmation dialog.

## Current State Analysis
- Transaction model exists with CRUD operations in repository
- Transaction details screen displays transaction information
- No delete functionality currently implemented

## Implementation Steps

### 1. Add Delete Method to Repository
**File:** `lib/data/repositories/transaction_repository.dart`

- Add `deleteTransaction(int id)` method to `TransactionRepository`
- Implement database deletion logic using Isar
- Return success/failure result

### 2. Add Delete Action to Transaction Details Screen
**File:** `lib/presentation/screens/transaction_details_screen.dart`

- Add delete button to AppBar actions or floating action menu
- Use icon: `Icons.delete` or `Icons.delete_outline`
- Position: AppBar trailing actions

### 3. Implement Confirmation Dialog
**Location:** `lib/presentation/screens/transaction_details_screen.dart`

- Create confirmation dialog using `showDialog` with `AlertDialog`
- Dialog should display:
  - Title: "Delete Transaction?"
  - Content: Warning message about permanent deletion
  - Transaction name for context
  - Two actions: "Cancel" and "Delete"
- "Delete" button should use destructive color (red/error color from theme)

### 4. Handle Delete Operation
**Logic flow:**

1. User taps delete button
2. Show confirmation dialog
3. If user confirms:
   - Call repository delete method
   - Show success feedback (SnackBar)
   - Navigate back to main screen
4. If user cancels:
   - Close dialog, no action

### 5. Handle Associated Data
**Consideration:** Cascade deletion

- When deleting a transaction, also delete:
  - Associated repayments (if any exist)
  - Associated reminders (if any exist)
- Use Isar's cascade delete or manual cleanup in repository

### 6. Add Golden Test
**File:** `test/golden/delete_transaction_dialog_test.dart`

- Create golden test for confirmation dialog
- Test both light and dark themes
- Capture dialog appearance with transaction context

### 7. Add Widget Tests
**File:** `test/widget/transaction_details_screen_test.dart`

- Test delete button is visible
- Test confirmation dialog appears on delete tap
- Test cancel action closes dialog without deletion
- Test confirm action triggers deletion and navigation
- Test SnackBar appears after successful deletion

## Technical Considerations

### Error Handling
- Handle deletion failures gracefully
- Show error SnackBar if deletion fails
- Keep user on details screen if error occurs

### Navigation
- Use `Navigator.pop(context, true)` to return result indicating deletion
- Main screen should refresh list if deletion occurred

### State Management
- Ensure transaction list updates after deletion
- Use existing state management approach (likely ChangeNotifier/ValueNotifier)

### Accessibility
- Add semantic labels for delete button
- Ensure dialog is accessible with screen readers
- Provide clear focus management

## Files to Modify

1. `lib/data/repositories/transaction_repository.dart` - Add delete method
2. `lib/data/repositories/repayment_repository.dart` - Add delete by transaction ID
3. `lib/data/repositories/reminder_repository.dart` - Add delete by transaction ID (if exists)
4. `lib/presentation/screens/transaction_details_screen.dart` - Add UI and logic
5. `test/golden/delete_transaction_dialog_test.dart` - New golden test
6. `test/widget/transaction_details_screen_test.dart` - Add widget tests

## Implementation Order

1. Repository layer (delete methods)
2. UI implementation (button + dialog)
3. Integration (wire up delete flow)
4. Golden tests
5. Widget tests
6. Manual testing
7. Code formatting with `dart format .`
8. Verify with `flutter analyze` and `flutter test`

## Success Criteria

- [ ] Delete button visible in transaction details screen
- [ ] Confirmation dialog appears with clear message
- [ ] Transaction deleted from database on confirmation
- [ ] Associated repayments and reminders also deleted
- [ ] User navigated back to main screen after deletion
- [ ] Transaction list updated without deleted item
- [ ] Success feedback shown to user
- [ ] Golden tests pass for dialog
- [ ] Widget tests cover all scenarios
- [ ] No analyzer warnings
- [ ] All tests pass
