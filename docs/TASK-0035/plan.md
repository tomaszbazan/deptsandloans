# Implementation Plan: TASK-0035 - Display Completed Transactions

## Task Description
Show completed transactions in Archive with read-only view.

## Current State Analysis
Based on the backlog, the Archive section has been implemented (TASK-0032, TASK-0033, TASK-0034) with:
- Collapsible accordion section for completed transactions
- Default collapsed state
- Toggle functionality to expand/collapse

What's missing is displaying the actual completed transactions within the Archive section.

## Implementation Steps

### 1. Analyze Current Archive Implementation
- Read existing Archive widget implementation
- Understand how the Archive section is currently structured
- Identify where completed transactions should be displayed

### 2. Filter Completed Transactions
- Verify transaction model has a `status` field or completion indicator
- Implement filtering logic to separate completed transactions from active ones
- Ensure the filter respects transaction type (debt vs loan)

### 3. Create Archive Transaction List Widget
- Create a read-only transaction list widget for archived items
- Display key information: name, original amount, currency, completion date
- Apply visual distinction from active transactions (e.g., muted colors, no interaction)
- Ensure consistent styling with the rest of the app

### 4. Integrate with Archive Section
- Connect the filtered completed transactions to the Archive accordion
- Handle empty state when no completed transactions exist
- Maintain proper sorting (e.g., by completion date, descending)

### 5. Implement Read-Only Behavior
- Disable tap interactions that would navigate to transaction details
- Remove action buttons (edit, delete) from archived transactions
- Optionally: Allow viewing full details in a read-only mode

### 6. Testing
- Write golden tests for Archive section with completed transactions
- Test empty state (no completed transactions)
- Test with multiple completed transactions
- Test expand/collapse behavior with populated list
- Verify visual distinction between active and archived transactions

### 7. Code Quality
- Run `flutter analyze` to ensure no issues
- Run `flutter test` to verify all tests pass
- Format code with `dart format .`

## Technical Considerations

### Data Model
- Transaction model should have a `completed` boolean or `status` enum
- Need to track completion date for sorting

### UI/UX Decisions
- Should archived transactions show repayment history?
- Should users be able to "unarchive" transactions?
- What information is most relevant for archived items?

### Performance
- If many completed transactions exist, consider pagination or limiting display
- Use `ListView.builder` for efficient rendering

## Files to Modify/Create
- `lib/features/transactions/presentation/widgets/archive_section.dart` (likely exists)
- `lib/features/transactions/presentation/widgets/archived_transaction_item.dart` (new, read-only variant)
- Repository layer to filter completed transactions
- Golden test files for Archive section

## Acceptance Criteria
- [ ] Completed transactions are displayed in the Archive section
- [ ] Archive section shows empty state when no completed transactions exist
- [ ] Archived transactions are visually distinct from active ones
- [ ] Archived transactions are read-only (no edit/delete actions)
- [ ] Proper sorting is applied (by completion date)
- [ ] Golden tests cover all Archive states
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter test` passes with all tests green
