# TASK-0025: Create Transaction Details Screen - Implementation Plan

## Overview
Build a comprehensive transaction details screen that displays full transaction information, repayment history, and visual progress indicators.

## Current State Analysis
Based on the codebase:
- Transaction model exists with all necessary fields (id, type, name, amount, currency, description, dueDate, status)
- Repayment model exists with transactionId, amount, when, createdAt fields
- Repositories for transactions and repayments are implemented
- Navigation using go_router is configured
- Reusable transaction list components exist (TransactionListTile)
- Theme system with light/dark mode support is in place

## Requirements
1. Display complete transaction details:
   - Transaction type (debt/loan)
   - Name
   - Original amount with currency
   - Current remaining balance
   - Description (full text, not truncated)
   - Due date (if set)
   - Status (active/completed)
   - Overdue indicator if applicable

2. Show repayment history:
   - List of all repayments
   - Each repayment showing: amount, date/time
   - Ordered chronologically (newest first recommended)
   - Handle empty state (no repayments yet)

3. Display progress visualization:
   - Visual progress bar/indicator
   - Percentage of amount repaid
   - Remaining balance clearly shown

4. Navigation:
   - Route parameter for transaction ID
   - Back button to return to main screen
   - Handle invalid transaction ID gracefully

## Implementation Steps

### Step 1: Define Route Configuration
**File**: `lib/core/router/app_router.dart`
- Add new route: `/transaction/:id`
- Configure route with path parameter for transaction ID
- Link to TransactionDetailsScreen widget

### Step 2: Create TransactionDetailsScreen Widget
**File**: `lib/presentation/screens/transaction_details_screen.dart`
- Create StatelessWidget for the main screen
- Extract transaction ID from route parameters
- Use FutureBuilder or StreamBuilder to load transaction data
- Handle loading, error, and success states
- Implement AppBar with title and back button
- Structure the screen layout with scrollable content

### Step 3: Create Transaction Info Section Widget
**File**: `lib/presentation/widgets/transaction_details/transaction_info_section.dart`
- Display transaction type badge/chip (debt/loan with distinct styling)
- Show transaction name as headline
- Display formatted original amount with currency symbol
- Show current remaining balance prominently
- Display full description (with proper text wrapping)
- Show due date if set (formatted according to locale)
- Show overdue warning if past due date and balance > 0
- Show status (active/completed)

### Step 4: Create Progress Section Widget
**File**: `lib/presentation/widgets/transaction_details/progress_section.dart`
- Calculate repayment percentage: (totalRepayments / originalAmount) * 100
- Implement LinearProgressIndicator or custom progress bar
- Show percentage text
- Display "Paid: X" and "Remaining: Y" with currency formatting
- Use theme colors (primary color for progress, red for overdue)

### Step 5: Create Repayment History Section Widget
**File**: `lib/presentation/widgets/transaction_details/repayment_history_section.dart`
- Section header: "Repayment History"
- Load repayments from repository using transactionId
- Sort repayments by date (newest first)
- Create RepaymentListItem widget for each repayment
- Handle empty state: "No repayments recorded yet"
- Format dates according to locale (use intl package)
- Format amounts with currency symbol

### Step 6: Create RepaymentListItem Widget
**File**: `lib/presentation/widgets/transaction_details/repayment_list_item.dart`
- Display repayment amount with currency symbol
- Display repayment date/time
- Use Card or ListTile for consistent styling
- Apply appropriate padding and spacing
- Use theme colors for text hierarchy

### Step 7: Implement Data Loading Logic
**File**: `lib/presentation/screens/transaction_details_screen.dart`
- Create method to load transaction by ID
- Create method to load repayments for transaction
- Calculate remaining balance: originalAmount - sum(repayments)
- Handle cases where transaction doesn't exist
- Implement error handling for database operations
- Consider using StreamBuilder for real-time updates

### Step 8: Add Navigation Integration
**File**: `lib/presentation/widgets/transaction_list_tile.dart` (modify existing)
- Add onTap handler to navigate to details screen
- Pass transaction ID as route parameter
- Use context.go() or context.push() from go_router

**Alternative locations that might trigger navigation:**
- From main screen transaction list items
- From any other location showing transaction summaries

### Step 9: Handle Edge Cases
- Transaction not found: Show error message with back button
- No repayments: Show encouraging empty state
- Very long descriptions: Ensure proper text wrapping
- Large number of repayments: Consider scrolling performance
- Currency formatting for different locales
- Date formatting for different locales

### Step 10: Styling and Theming
- Use consistent spacing (padding, margins) from theme
- Apply elevation/shadows to cards for depth
- Use typography hierarchy from theme
- Ensure dark mode support
- Add subtle dividers between sections
- Use icons to enhance understanding (calendar for due date, wallet for amount, etc.)

## Testing Strategy

### Widget Tests
**File**: `test/presentation/screens/transaction_details_screen_test.dart`
- Test screen renders with valid transaction ID
- Test loading state display
- Test error handling for invalid transaction ID
- Test all sections render correctly with data
- Test navigation back functionality

**File**: `test/presentation/widgets/transaction_details/progress_section_test.dart`
- Test progress calculation with various repayment amounts
- Test 0% progress (no repayments)
- Test 100% progress (fully repaid)
- Test partial progress

**File**: `test/presentation/widgets/transaction_details/repayment_history_section_test.dart`
- Test empty state rendering
- Test repayment list rendering
- Test chronological ordering
- Test date/amount formatting

### Integration Tests (optional for this task)
- Navigate from main screen to details screen
- Verify all data displays correctly
- Test back navigation

## Dependencies
- Existing: go_router, intl (for locale formatting)
- May need: none (all required packages should already be in place)

## Acceptance Criteria
- [ ] Transaction details screen accessible via route with transaction ID
- [ ] All transaction information displayed correctly
- [ ] Progress bar shows correct percentage
- [ ] Remaining balance calculated and displayed accurately
- [ ] Repayment history shows all repayments chronologically
- [ ] Empty state for no repayments
- [ ] Proper error handling for invalid transaction ID
- [ ] Navigation works correctly (to and from screen)
- [ ] Responsive layout for different screen sizes
- [ ] Dark mode support
- [ ] Currency formatting respects locale
- [ ] Date formatting respects locale
- [ ] All widget tests pass
- [ ] Code passes flutter analyze
- [ ] Code formatted with dart format

## Estimated Complexity
**Medium** - Requires multiple widgets, data loading from repositories, calculations, and proper state management, but follows established patterns in the codebase.

## Notes
- Reuse existing theme components and styling patterns
- Follow the established project structure (presentation/widgets/screens)
- Consider extracting color logic for overdue indicators into a utility function if not already present
- The screen should be read-only for now (future tasks will add repayment form and actions)
- Pay attention to currency symbol positioning based on locale (some currencies have symbol before, others after)
