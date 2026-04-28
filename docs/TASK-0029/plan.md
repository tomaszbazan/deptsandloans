# Implementation Plan: TASK-0029 - Implement Progress Bar

## Task Description
Create visual progress bar showing repayment percentage on transaction details screen.

## Current State Analysis
Based on the backlog:
- Transaction model with initial amount exists (TASK-0008 completed)
- Repayment model and repository exist (TASK-0009, TASK-0012 completed)
- Transaction details screen exists (TASK-0025 completed)
- Balance calculation logic exists (TASK-0028 completed)

## Implementation Steps

### 1. Analyze Existing Code Structure
- Read the transaction details screen to understand current layout
- Review how balance calculation is currently implemented
- Check the transaction and repayment models for required data

### 2. Design Progress Bar Component
- Determine repayment percentage calculation: `(initialAmount - remainingBalance) / initialAmount * 100`
- Decide on visual representation:
  - Use `LinearProgressIndicator` for horizontal bar
  - Display percentage text alongside the bar
  - Color coding: green for progress, red if overdue
  - Height and padding for visual prominence

### 3. Implement Progress Calculation Logic
- Create a method to calculate repayment percentage
- Handle edge cases:
  - Division by zero when initial amount is 0
  - Overpayment scenarios (if percentage > 100%)
  - No repayments yet (0% progress)

### 4. Create Progress Bar Widget
- Build a reusable widget component for the progress bar
- Include:
  - Progress indicator
  - Percentage text label
  - Appropriate styling matching app theme
  - Responsive layout for different screen sizes

### 5. Integrate into Transaction Details Screen
- Add the progress bar widget to the transaction details layout
- Position it prominently (likely near the top after transaction name/amount)
- Ensure proper data flow from transaction and repayments to the widget

### 6. Apply Theme and Styling
- Use app's color scheme for progress colors
- Apply shadows and styling per PRD guidelines
- Ensure dark mode compatibility
- Add appropriate padding and spacing

### 7. Add Golden Test
- Create visual regression test for the progress bar widget
- Test cases:
  - 0% progress (no repayments)
  - 50% progress (partial repayment)
  - 100% progress (fully repaid)
  - Different screen sizes

### 8. Verify Implementation
- Run `flutter analyze` to check for issues
- Run `flutter test` to execute all tests including new golden test
- Manual testing on transaction details screen
- Test with various repayment scenarios

## Files to Create/Modify

### New Files
- `lib/features/transactions/presentation/widgets/repayment_progress_bar.dart` - Progress bar widget
- `test/features/transactions/presentation/widgets/repayment_progress_bar_test.dart` - Unit/widget tests
- `test/features/transactions/presentation/widgets/goldens/repayment_progress_bar_*.png` - Golden test images

### Files to Modify
- Transaction details screen file (location TBD after analysis)
- Possibly view model/controller if calculation logic needs to be added there

## Technical Considerations

### Widget Structure
```dart
class RepaymentProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final bool isOverdue;

  // Display progress with LinearProgressIndicator
  // Show percentage text
  // Apply conditional styling based on overdue status
}
```

### Percentage Calculation
```dart
double calculateProgress(double initialAmount, double remainingBalance) {
  if (initialAmount <= 0) return 0.0;
  final repaidAmount = initialAmount - remainingBalance;
  return (repaidAmount / initialAmount).clamp(0.0, 1.0);
}
```

## Success Criteria
- Progress bar displays correctly on transaction details screen
- Percentage accurately reflects repayment status
- Visual design matches app theme and PRD guidelines
- Works in both light and dark modes
- Golden tests pass
- All existing tests continue to pass
- No analyzer warnings

## Dependencies
No new external dependencies required. Will use:
- Flutter's built-in `LinearProgressIndicator`
- Existing theme system
- Existing transaction and repayment data models

## Risk Assessment
**Low Risk** - This is a UI enhancement that doesn't affect core business logic or data persistence. The progress calculation is straightforward and isolated.
