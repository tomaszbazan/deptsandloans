# TASK-0023: Implement Overdue Highlighting

## Task Description
Visually highlight (red color) transactions where due date has passed and remaining balance > 0

## Current State Analysis

### Existing Components
- **Transaction Model** (`lib/domain/models/transaction.dart`): Contains transaction data including `dueDate` and `status`
- **Transaction List Widget** (`lib/presentation/widgets/transaction_list.dart`): Displays transactions in a list
- **Transaction Card** (`lib/presentation/widgets/transaction_card.dart`): Individual card displaying transaction details
- **Repository Layer**: Transaction repository for data access
- **Sorting Logic**: Transactions are already sorted by due date (TASK-0022 completed)

### Dependencies
- Transaction sorting by due date is already implemented
- Need to calculate remaining balance (initial amount - sum of repayments)
- Need to determine if transaction is overdue (due date < current date)
- Need to apply visual styling (red color) to overdue transactions

## Implementation Plan

### 1. Add Overdue Check Logic to Transaction Model
**File**: `lib/domain/models/transaction.dart`

Add a getter method to check if transaction is overdue:
- Check if `dueDate` is not null
- Compare `dueDate` with current date
- Check if remaining balance > 0
- Return boolean indicating overdue status

### 2. Add Remaining Balance Calculation
**Approach**: Since repayments are tracked separately, we need to:
- Either add a method to calculate balance from repayments list
- Or use repository to fetch and calculate balance
- For efficiency, consider caching balance in UI layer

### 3. Update Transaction Card Widget
**File**: `lib/presentation/widgets/transaction_card.dart`

Modify the card to:
- Accept overdue status as parameter or calculate it
- Apply conditional styling based on overdue status
- Use red color from theme for overdue transactions
- Consider: text color, border color, background tint, or icon indicator

### 4. Update Transaction List Widget
**File**: `lib/presentation/widgets/transaction_list.dart`

- Pass necessary data to TransactionCard for overdue calculation
- Ensure repayment data is available if needed for balance calculation

### 5. Theme Integration
**File**: `lib/core/theme/app_theme.dart`

- Define overdue color in theme (ensure red works in both light/dark modes)
- Use semantic color naming (e.g., `error` or custom `overdueColor`)

### 6. Testing

#### Unit Tests
- Test overdue detection logic with various scenarios:
  - Transaction with due date in past and balance > 0 (overdue)
  - Transaction with due date in past and balance = 0 (not overdue)
  - Transaction with due date in future (not overdue)
  - Transaction with no due date (not overdue)

#### Widget Tests
- Test TransactionCard displays red styling for overdue transactions
- Test TransactionCard displays normal styling for non-overdue transactions
- Verify color contrast and accessibility

#### Golden Tests
- Create golden test for overdue transaction card appearance
- Test both light and dark theme rendering

## Visual Design Specification

### Red Highlighting Options
1. **Text Color**: Primary transaction details in red
2. **Border**: Red border around card
3. **Background**: Light red tint on card background
4. **Icon**: Red warning/alert icon
5. **Combination**: Multiple subtle indicators

**Recommended Approach**: Use a combination of:
- Red accent border (2px, semi-transparent)
- Red tint on amount text
- Optional warning icon

## Edge Cases to Consider

1. **Timezone handling**: Ensure date comparison uses consistent timezone
2. **Partially repaid transactions**: Balance calculation must be accurate
3. **Performance**: Avoid expensive calculations in build method
4. **Completed transactions**: Should never be overdue (status check)
5. **Archived transactions**: May need special handling

## Files to Modify

1. `lib/domain/models/transaction.dart` - Add overdue getter
2. `lib/presentation/widgets/transaction_card.dart` - Apply styling
3. `lib/presentation/widgets/transaction_list.dart` - Pass data
4. `lib/core/theme/app_theme.dart` - Define colors (if needed)
5. `test/domain/models/transaction_test.dart` - Add tests
6. `test/presentation/widgets/transaction_card_test.dart` - Add tests
7. `test/presentation/widgets/transaction_list_test.dart` - Update tests

## Files to Create

1. `test/presentation/widgets/transaction_card_golden_test.dart` - Golden tests for overdue styling

## Implementation Steps

1. **Step 1**: Add overdue detection logic to Transaction model with unit tests
2. **Step 2**: Calculate remaining balance (determine approach based on existing repayment implementation)
3. **Step 3**: Update TransactionCard widget to accept and display overdue state
4. **Step 4**: Define overdue colors in theme
5. **Step 5**: Update TransactionList to provide necessary data
6. **Step 6**: Write widget tests for overdue styling
7. **Step 7**: Create golden tests for visual verification
8. **Step 8**: Run full test suite and analyze
9. **Step 9**: Format code with `dart format .`

## Success Criteria

- [ ] Transactions with past due date and balance > 0 are visually highlighted in red
- [ ] Transactions with past due date but balance = 0 are NOT highlighted
- [ ] Transactions with future due date are NOT highlighted
- [ ] Transactions without due date are NOT highlighted
- [ ] Red highlighting is visible and accessible in both light and dark themes
- [ ] All existing tests pass
- [ ] New unit tests for overdue logic pass
- [ ] New widget tests for styling pass
- [ ] Code passes `flutter analyze`
- [ ] Code is formatted with `dart format .`

## Questions to Resolve

1. **Repayment Integration**: How is remaining balance currently calculated? Need to explore existing repayment implementation
2. **Performance**: Should balance be calculated on-demand or cached?
3. **Visual Design**: What specific red highlighting approach to use? (to be decided during implementation based on existing design)
