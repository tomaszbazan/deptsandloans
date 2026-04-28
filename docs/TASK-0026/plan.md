# Implementation Plan: TASK-0026 - Create Repayment Form

## Task Description
Build UI for recording partial repayments with amount input

## Current State Analysis

### Existing Components
- Transaction model with repayment tracking
- Repayment model with fields: id, transactionId, amount, when, createdAt
- Repayment repository for CRUD operations
- Transaction Details Screen (TASK-0025) where repayments should be displayed

### Dependencies
- **Completed**: Transaction model (TASK-0008), Repayment model (TASK-0009), Repayment repository (TASK-0012), Transaction Details Screen (TASK-0025)
- **Related**: TASK-0027 (Repayment Validation), TASK-0028 (Calculate Remaining Balance)

## Implementation Steps

### 1. Create Repayment Form Widget
**Location**: `lib/presentation/widgets/repayment_form.dart`

Create a reusable form widget that:
- Displays current transaction balance (initial amount - sum of repayments)
- Provides an input field for repayment amount with currency formatting
- Shows a date picker for the repayment date (defaults to current date/time)
- Includes Save and Cancel buttons
- Uses Material Design 3 components for consistency

**Key Components**:
- `TextFormField` for amount input with decimal keyboard
- `DateTimePicker` or similar for selecting repayment date
- `ElevatedButton` for save action
- `TextButton` for cancel action

### 2. Integrate Form into Transaction Details Screen
**Location**: `lib/presentation/screens/transaction_details_screen.dart`

Add a "Record Repayment" button or FAB that:
- Opens the repayment form as a bottom sheet or dialog
- Passes the current transaction context
- Refreshes the screen after successful repayment recording

### 3. Create Repayment Provider/Controller
**Location**: `lib/presentation/providers/repayment_provider.dart` or similar

Implement state management for:
- Handling form submission
- Calling the repayment repository to save the repayment
- Managing loading states and error handling
- Notifying listeners of successful repayment creation

### 4. Update Transaction Details to Show Repayments
**Location**: `lib/presentation/screens/transaction_details_screen.dart`

Enhance the details screen to:
- Display a list of all repayments for the transaction
- Show each repayment's amount, date, and timestamp
- Sort repayments by date (most recent first)
- Display remaining balance dynamically

### 5. Add Localization Strings
**Location**: `lib/l10n/app_en.arb` and `lib/l10n/app_pl.arb`

Add translation keys for:
- "Record Repayment" button text
- "Repayment Amount" label
- "Repayment Date" label
- "Save Repayment" button
- "Cancel" button
- "Remaining Balance" label
- Success/error messages

### 6. Create Golden Tests
**Location**: `test/presentation/widgets/repayment_form_test.dart`

Create visual regression tests for:
- Repayment form in light mode
- Repayment form in dark mode
- Repayment form with validation errors
- Transaction details screen with repayments list

### 7. Create Widget Tests
**Location**: `test/presentation/widgets/repayment_form_test.dart`

Test scenarios:
- Form renders correctly with all fields
- Amount input accepts valid decimal numbers
- Date picker opens and updates the selected date
- Save button triggers form submission
- Cancel button closes the form without saving

## UI Design Considerations

### Form Layout
```
┌─────────────────────────────────┐
│  Record Repayment               │
├─────────────────────────────────┤
│  Transaction: [Name]            │
│  Remaining Balance: [Amount]    │
│                                 │
│  Amount *                       │
│  ┌───────────────────────────┐ │
│  │ 0.00                      │ │
│  └───────────────────────────┘ │
│                                 │
│  Date                           │
│  ┌───────────────────────────┐ │
│  │ 2025-12-03  📅           │ │
│  └───────────────────────────┘ │
│                                 │
│  [Cancel]        [Save]         │
└─────────────────────────────────┘
```

### Repayment History Display
```
┌─────────────────────────────────┐
│  Repayment History              │
├─────────────────────────────────┤
│  ● 100.00 PLN                   │
│    2025-12-03 14:30             │
│                                 │
│  ● 50.00 PLN                    │
│    2025-11-15 09:15             │
└─────────────────────────────────┘
```

## Technical Decisions

### Form Presentation
**Decision**: Use `showModalBottomSheet` for mobile-friendly UX
**Rationale**: Bottom sheets are native to Material Design and provide excellent mobile ergonomics

### Amount Input Formatting
**Decision**: Use `TextInputFormatter` with currency formatting
**Rationale**: Ensures consistent currency display and prevents invalid input

### State Management
**Decision**: Use `ChangeNotifier` with `ListenableBuilder`
**Rationale**: Follows project's MVVM pattern and built-in Flutter state management

### Date Selection
**Decision**: Use Material 3 `showDatePicker` and `showTimePicker`
**Rationale**: Native Flutter components with localization support

## Files to Create/Modify

### New Files
1. `lib/presentation/widgets/repayment_form.dart` - Main form widget
2. `lib/presentation/providers/repayment_provider.dart` - State management
3. `test/presentation/widgets/repayment_form_test.dart` - Widget tests
4. `test/golden/repayment_form_test.dart` - Golden tests

### Modified Files
1. `lib/presentation/screens/transaction_details_screen.dart` - Add repayment form integration
2. `lib/l10n/app_en.arb` - English translations
3. `lib/l10n/app_pl.arb` - Polish translations

## Validation Rules (Preview for TASK-0027)

While full validation is part of TASK-0027, basic validation should include:
- Amount must be greater than 0
- Amount must be a valid decimal number
- Date cannot be in the future (optional, to be confirmed)

## Success Criteria

- [ ] Repayment form widget created with all required fields
- [ ] Form integrated into Transaction Details Screen
- [ ] User can successfully record a repayment
- [ ] Repayments are saved to the database via repository
- [ ] Remaining balance updates after recording repayment
- [ ] Repayment history displays on Transaction Details Screen
- [ ] Localization strings added for both PL and EN
- [ ] Golden tests pass for all UI states
- [ ] Widget tests cover main user interactions
- [ ] Code passes `flutter analyze` with no issues
- [ ] Code formatted with `dart format .`

## Estimated Complexity
**Medium** - Requires creating new UI components, integrating with existing screens, and coordinating with repository layer

## Notes
- This task focuses on the UI and basic form functionality
- Advanced validation (TASK-0027) will be implemented separately
- Balance calculation logic (TASK-0028) may need to be implemented or enhanced during this task
- Consider showing a success snackbar after recording a repayment
- Ensure the form is accessible and works well on different screen sizes
