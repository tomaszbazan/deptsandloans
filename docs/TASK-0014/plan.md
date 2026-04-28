# TASK-0014: Create Transaction Form Screen - Implementation Plan

## Overview
Build a form UI for adding and editing transactions with the following fields:
- Name (required)
- Amount (required)
- Currency (required)
- Description (optional)
- Due Date (optional)

## Prerequisites
- Transaction model already exists (TASK-0008 ✓)
- Transaction repository implemented (TASK-0011 ✓)
- Navigation setup complete (TASK-0006 ✓)

## Architecture

### MVVM Pattern
- **View**: TransactionFormScreen widget (UI)
- **ViewModel**: TransactionFormViewModel (state management, validation)
- **Model**: Transaction model (already exists)

### File Structure
```
lib/
├── presentation/
│   └── screens/
│       └── transaction_form/
│           ├── transaction_form_screen.dart
│           └── transaction_form_view_model.dart
└── core/
    └── enums/
        └── transaction_type.dart (if not exists)
```

## Implementation Steps

### 1. Create TransactionFormViewModel
**File**: `lib/presentation/screens/transaction_form/transaction_form_view_model.dart`

**Responsibilities**:
- Hold form state (name, amount, currency, description, dueDate)
- Manage transaction type (debt/loan)
- Provide methods to update individual fields
- Expose state via ChangeNotifier
- Handle saving logic (calling repository)

**Key Properties**:
- `String name`
- `double? amount`
- `String currency` (default: PLN)
- `String? description`
- `DateTime? dueDate`
- `TransactionType type` (debt/loan)
- `bool isLoading`
- `String? errorMessage`

**Key Methods**:
- `void setName(String value)`
- `void setAmount(double value)`
- `void setCurrency(String value)`
- `void setDescription(String? value)`
- `void setDueDate(DateTime? value)`
- `Future<bool> saveTransaction()` - returns success status

### 2. Create TransactionFormScreen
**File**: `lib/presentation/screens/transaction_form/transaction_form_screen.dart`

**UI Components**:
1. **AppBar**
   - Title: "Add Debt" / "Add Loan" / "Edit Transaction"
   - Back button
   - Save action button (AppBar action)

2. **Form Fields** (in scrollable view):
   - **Name Field**
     - TextFormField
     - Label: Localized "Name"
     - Required indicator
     - Auto-focus on screen open

   - **Amount Field**
     - TextFormField with numeric keyboard
     - Label: Localized "Amount"
     - Required indicator
     - Input formatter for decimal numbers

   - **Currency Selector**
     - DropdownButtonFormField or custom picker
     - Options: PLN, EUR, USD, GBP
     - Default: PLN
     - Display currency symbol next to amount

   - **Description Field**
     - TextFormField (multiline)
     - Label: Localized "Description"
     - Optional
     - Max length: 200 characters
     - Helper text showing character count

   - **Due Date Picker**
     - InkWell or TextFormField (read-only) with date picker
     - Label: Localized "Due Date"
     - Optional
     - Shows "Not set" or formatted date
     - Calendar icon
     - Opens date picker dialog on tap

3. **Floating Action Button** or **Bottom Action**
   - Save button (alternative to AppBar action)
   - Shows loading indicator when saving

### 3. Routing Integration
**Update**: `lib/core/routing/app_router.dart` (or equivalent)

Add routes:
- `/add-debt` -> TransactionFormScreen(type: TransactionType.debt)
- `/add-loan` -> TransactionFormScreen(type: TransactionType.loan)
- `/edit-transaction/:id` -> TransactionFormScreen(transactionId: id)

### 4. Dependency Injection
**Constructor Parameters**:
```dart
TransactionFormScreen({
  Key? key,
  required TransactionType type,
  String? transactionId, // for edit mode
  required TransactionRepository repository,
})
```

**ViewModel Initialization**:
- Create ViewModel in initState
- If transactionId is provided, load existing transaction
- Pass repository to ViewModel

### 5. State Management
Use `ChangeNotifier` + `ListenableBuilder` pattern:
- ViewModel extends ChangeNotifier
- Screen uses ListenableBuilder to rebuild on changes
- Call `notifyListeners()` after each field update

### 6. Form Validation (Preparation)
Add validation placeholders in ViewModel:
- Name: non-empty (will be implemented in TASK-0015)
- Description: max 200 chars (will be implemented in TASK-0015)
- Amount: positive number
- Note: Full validation will be implemented in next task

## UI/UX Considerations

### Layout
- Use `SingleChildScrollView` for scrollable form
- Add padding around form fields (16.0)
- Consistent spacing between fields (16.0)
- Use Material Design components

### Accessibility
- Proper labels for all fields
- Keyboard navigation support
- Screen reader support

### Visual Design
- Follow app theme (from TASK-0007)
- Use elevation/shadows for form container
- Consistent input decoration theme
- Visual feedback for focus states

### User Flow
1. User taps FAB on main screen (TASK-0024)
2. Navigation to form screen
3. User fills required fields
4. User taps save button
5. Success: Navigate back to main screen
6. Error: Show error message, keep form open

## Testing Strategy

### Widget Tests
- Form renders correctly
- All input fields are present
- Currency dropdown shows all options
- Date picker opens on tap
- Save button is visible

### Integration Points
- ViewModel creation and disposal
- Field updates trigger ViewModel changes
- Save button calls ViewModel.saveTransaction()

## Dependencies
```yaml
dependencies:
  # Already in project:
  # - go_router (navigation)
  # - isar (database via repository)
```

## Implementation Order
1. Create ViewModel class with state properties
2. Create basic screen layout (AppBar + scaffold)
3. Add Name field + ViewModel binding
4. Add Amount field + ViewModel binding
5. Add Currency dropdown + ViewModel binding
6. Add Description field + ViewModel binding
7. Add Due Date picker + ViewModel binding
8. Implement save logic in ViewModel
9. Connect save button to ViewModel
10. Add loading states
11. Add error handling
12. Add routing configuration
13. Test all fields and interactions

## Follow-up Tasks
- TASK-0015: Implement Form Validation
- TASK-0016: Implement Currency Selection (enhance current dropdown)
- TASK-0017: Implement Save Transaction (connect to repository)
- TASK-0018: Implement Edit Transaction (load existing data)

## Notes
- Keep form simple and focused on data entry
- Validation details will be added in TASK-0015
- Currency selection will be enhanced in TASK-0016
- Edit mode will be fully implemented in TASK-0018
- Focus on clean separation between View and ViewModel
- Ensure proper disposal of ViewModel in screen's dispose()
