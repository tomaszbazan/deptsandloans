# TASK-0021: Implement Transaction List Widget

## Task Description
Create reusable list widget to display transactions with name, amount, balance, and due date

## Current State Analysis
- ✅ Transaction model exists (`lib/data/models/transaction.dart`)
- ✅ Transaction repository exists (`lib/data/repositories/transaction_repository.dart`)
- ✅ Repayment model exists for calculating balance
- ✅ Main screen with tabs exists (`lib/presentation/screens/main_screen.dart`)
- ❌ No transaction list widget implementation yet

## Implementation Plan

### 1. Create Transaction List Item Widget
**File:** `lib/presentation/widgets/transaction_list_item.dart`

Create a reusable widget that displays a single transaction with:
- Transaction name (primary text)
- Initial amount and currency
- Current balance (calculated from initial amount - repayments)
- Due date (formatted according to locale)
- Visual styling following app theme

### 2. Create Transaction List Widget
**File:** `lib/presentation/widgets/transaction_list.dart`

Create a list widget that:
- Takes a list of transactions as input
- Uses `ListView.builder` for performance with large lists
- Renders each transaction using `TransactionListItem`
- Handles empty state (no transactions)
- Supports tap callbacks for navigation to details

### 3. Update MainScreen to Use Transaction List Widget
**File:** `lib/presentation/screens/main_screen.dart`

Integrate the new list widget:
- Replace placeholder content in "My Debts" tab
- Replace placeholder content in "My Loans" tab
- Load transactions from repository
- Filter by transaction type (debt vs loan)
- Pass appropriate callbacks for item interaction

## Technical Considerations

### Data Flow
1. MainScreen loads transactions via TransactionRepository
2. Filters transactions by type (debt/loan)
3. For each transaction, calculate balance using repayments
4. Pass filtered list to TransactionList widget
5. TransactionList renders items using TransactionListItem

### UI Design
- Use Material Card or ListTile for list items
- Show amount with currency symbol and proper formatting
- Display balance prominently (different color if differs from initial amount)
- Format due date using intl package (already configured)
- Add subtle shadows and spacing per design guidelines

### State Management
- Use FutureBuilder or StreamBuilder to load transactions asynchronously
- Show loading indicator while fetching data
- Handle error states gracefully

### Testing Strategy
1. Unit tests for balance calculation logic
2. Widget tests for TransactionListItem
3. Widget tests for TransactionList (with mock data)
4. Integration tests for MainScreen with transaction list
5. Golden test with elements in the list.

## Dependencies
- No new dependencies required
- Uses existing:
  - `intl` for date/currency formatting
  - `isar` for data persistence via repository

## Files to Create/Modify
1. **CREATE**: `lib/presentation/widgets/transaction_list_item.dart`
2. **CREATE**: `lib/presentation/widgets/transaction_list.dart`
3. **MODIFY**: `lib/presentation/screens/main_screen.dart`

## Acceptance Criteria
- [ ] Transaction list displays all required fields (name, amount, balance, due date)
- [ ] List is performant with many transactions (uses ListView.builder)
- [ ] Currency formatting matches device locale
- [ ] Date formatting matches device locale
- [ ] Tapping a transaction item can trigger a callback (for future navigation)
- [ ] Empty state is handled gracefully
- [ ] Widget is reusable (can be used in both tabs)
- [ ] Code follows Flutter best practices and project guidelines
- [ ] All tests pass (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)

## Next Tasks (Dependencies)
This task enables:
- TASK-0022: Implement Transaction Sorting
- TASK-0023: Implement Overdue Highlighting
- TASK-0024: Implement FAB for Adding
- TASK-0025: Create Transaction Details Screen
