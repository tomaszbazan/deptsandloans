# TASK-0041: Create Notification Content

## Overview
Format notification with transaction name, amount, and remaining balance.

## Current State Analysis
Based on the codebase:
- Notification system is already set up (TASK-0036 completed)
- Reminders are configured (TASK-0037, TASK-0038, TASK-0039 completed)
- Notification scheduling is implemented in `IsarTransactionRepository`
- Basic notification display exists but content formatting needs enhancement

## Implementation Steps

### 1. Analyze Current Notification Implementation
- Review `lib/core/notifications/notification_service.dart` to understand current notification structure
- Check `lib/data/repositories/isar_transaction_repository.dart` for notification scheduling logic
- Identify where notification content is currently being created

### 2. Design Notification Content Format
Determine the optimal format for notification content:
- **Title**: Transaction name
- **Body**: Include amount and remaining balance with proper currency formatting
- **Example**:
  - Title: "Loan to John"
  - Body: "Amount: $500.00 • Remaining: $250.00"

### 3. Implement Content Formatting
- Create a helper method to format notification content
- Use proper currency formatting based on transaction currency
- Include localization support (PL/EN)
- Ensure remaining balance is calculated correctly

### 4. Update Notification Service
- Modify notification creation to use formatted content
- Ensure proper handling of different transaction types (debt/loan)
- Add transaction details to notification payload for potential tap actions

### 5. Integration with Existing System
- Update `IsarTransactionRepository.scheduleNotificationsForTransaction()` to use new formatting
- Ensure notifications display correctly for both one-time and recurring reminders
- Verify notification content updates when repayments are made

### 6. Testing
- Test notification content for various currencies (PLN, EUR, USD, GBP)
- Test with different transaction amounts and remaining balances
- Test with both Polish and English locales
- Verify notifications at 19:00 display correctly
- Test edge cases (fully repaid, overdue transactions)

### 7. Add Golden Tests
- Create golden tests for notification content formatting
- Test different locales and currencies

## Files to Modify
- `lib/core/notifications/notification_service.dart` - Main notification content implementation
- `lib/data/repositories/isar_transaction_repository.dart` - Integration with scheduling
- `test/core/notifications/notification_service_test.dart` - Unit tests
- `test/goldens/notifications/` - Golden tests for notification content

## Dependencies
- No new dependencies required
- Uses existing `intl` package for currency formatting
- Uses existing localization system

## Acceptance Criteria
- [ ] Notification title shows transaction name
- [ ] Notification body shows initial amount with currency
- [ ] Notification body shows remaining balance with currency
- [ ] Currency formatting matches device locale
- [ ] Content is localized (PL/EN)
- [ ] Works for both debts and loans
- [ ] Golden tests pass
- [ ] Unit tests pass
- [ ] `flutter analyze` passes with no errors
