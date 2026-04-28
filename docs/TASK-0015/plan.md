# TASK-0015: Implement Form Validation

## Task Description
Add validation for required Name field (non-empty) and Description field (max 200 characters) in the Transaction Form Screen.

## Current State Analysis

### Existing Implementation
- **Form Screen**: `lib/presentation/screens/transaction_form/transaction_form_screen.dart`
- **View Model**: `lib/presentation/screens/transaction_form/transaction_form_view_model.dart`
- **Data Model**: `lib/data/models/transaction.dart`

### Current Validation Status
1. **Backend Validation**: The `Transaction.validate()` method already implements validation logic:
   - Name must not be empty (line 51-53)
   - Amount must be positive (line 55-57)
   - Description must not exceed 200 characters (line 59-61)
   - Due date must be in the future (line 63-65)

2. **Current UI Behavior**:
   - No visual validation feedback in the UI
   - Validation only happens on save button press
   - Errors are shown via SnackBar (line 78 in screen)
   - Description field shows character counter but no validation error

3. **Localization**:
   - Validation messages exist in `app_en.arb`:
     - `nameRequired`: "Name is required"
     - `descriptionTooLong`: "Description must be 200 characters or less"

## Implementation Plan

### Phase 1: Add Real-time Validation to ViewModel
**File**: `lib/presentation/screens/transaction_form/transaction_form_view_model.dart`

1. **Add validation state properties**:
   ```dart
   String? _nameError;
   String? _descriptionError;
   String? _amountError;

   String? get nameError => _nameError;
   String? get descriptionError => _descriptionError;
   String? get amountError => _amountError;
   ```

2. **Add validation methods**:
   ```dart
   String? _validateName(String value) {
     if (value.trim().isEmpty) {
       return 'nameRequired'; // Localization key
     }
     return null;
   }

   String? _validateDescription(String? value) {
     if (value != null && value.length > 200) {
       return 'descriptionTooLong'; // Localization key
     }
     return null;
   }

   String? _validateAmount(double? value) {
     if (value == null || value <= 0) {
       return 'amountRequired'; // Will need to add this localization key
     }
     return null;
   }
   ```

3. **Update setter methods to validate on change**:
   ```dart
   void setName(String value) {
     _name = value;
     _nameError = _validateName(value);
     _clearError();
     notifyListeners();
   }

   void setDescription(String? value) {
     if (value == null || value.isEmpty) {
       _description = null;
     } else {
       _description = value;
     }
     _descriptionError = _validateDescription(value);
     _clearError();
     notifyListeners();
   }

   void setAmount(double? value) {
     _amount = value;
     _amountError = _validateAmount(value);
     _clearError();
     notifyListeners();
   }
   ```

4. **Add form-wide validation method**:
   ```dart
   bool validateForm() {
     _nameError = _validateName(_name);
     _descriptionError = _validateDescription(_description);
     _amountError = _validateAmount(_amount);

     notifyListeners();

     return _nameError == null &&
            _descriptionError == null &&
            _amountError == null;
   }
   ```

5. **Update saveTransaction method**:
   ```dart
   Future<bool> saveTransaction() async {
     // Validate form before proceeding
     if (!validateForm()) {
       return false;
     }

     _isLoading = true;
     _errorMessage = null;
     notifyListeners();

     // ... rest of the method
   }
   ```

### Phase 2: Update UI to Display Validation Errors
**File**: `lib/presentation/screens/transaction_form/transaction_form_screen.dart`

1. **Update Name TextField**:
   ```dart
   ListenableBuilder(
     listenable: _viewModel,
     builder: (context, _) {
       return TextField(
         controller: _nameController,
         focusNode: _nameFocusNode,
         decoration: InputDecoration(
           labelText: l10n.name,
           border: const OutlineInputBorder(),
           errorText: _viewModel.nameError != null
             ? _getLocalizedError(_viewModel.nameError!)
             : null,
         ),
         onChanged: _viewModel.setName,
         textInputAction: TextInputAction.next,
       );
     },
   )
   ```

2. **Update Amount TextField**:
   ```dart
   ListenableBuilder(
     listenable: _viewModel,
     builder: (context, _) {
       return TextField(
         controller: _amountController,
         decoration: InputDecoration(
           labelText: l10n.amount,
           border: const OutlineInputBorder(),
           errorText: _viewModel.amountError != null
             ? _getLocalizedError(_viewModel.amountError!)
             : null,
         ),
         keyboardType: const TextInputType.numberWithOptions(decimal: true),
         inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
         onChanged: (value) {
           final amount = double.tryParse(value);
           _viewModel.setAmount(amount);
         },
         textInputAction: TextInputAction.next,
       );
     },
   )
   ```

3. **Update Description TextField** (already wrapped in ListenableBuilder):
   ```dart
   // Add errorText to existing decoration
   decoration: InputDecoration(
     labelText: '${l10n.description} (${l10n.optional})',
     border: const OutlineInputBorder(),
     helperText: l10n.charactersRemaining(remaining),
     errorText: _viewModel.descriptionError != null
       ? _getLocalizedError(_viewModel.descriptionError!)
       : null,
   ),
   ```

4. **Add helper method for error localization**:
   ```dart
   String _getLocalizedError(String errorKey) {
     final l10n = AppLocalizations.of(context);
     switch (errorKey) {
       case 'nameRequired':
         return l10n.nameRequired;
       case 'descriptionTooLong':
         return l10n.descriptionTooLong;
       case 'amountRequired':
         return l10n.amountRequired;
       default:
         return errorKey;
     }
   }
   ```

### Phase 3: Add Missing Localization Strings
**Files**:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_pl.arb`

1. **Add to app_en.arb**:
   ```json
   "amountRequired": "Amount is required",
   "@amountRequired": {
     "description": "Validation message for required amount field"
   },
   "amountMustBePositive": "Amount must be greater than zero",
   "@amountMustBePositive": {
     "description": "Validation message for positive amount"
   }
   ```

2. **Add to app_pl.arb**:
   ```json
   "amountRequired": "Kwota jest wymagana",
   "@amountRequired": {
     "description": "Validation message for required amount field"
   },
   "amountMustBePositive": "Kwota musi być większa od zera",
   "@amountMustBePositive": {
     "description": "Validation message for positive amount"
   }
   ```

### Phase 4: Update Tests

#### Update Unit Tests
**File**: `test/presentation/screens/transaction_form_screen_test.dart`

Add new test cases:
```dart
testWidgets('shows validation error when name is empty', (tester) async {
  // Test implementation
});

testWidgets('shows validation error when description exceeds 200 characters', (tester) async {
  // Test implementation
});

testWidgets('shows validation error when amount is zero', (tester) async {
  // Test implementation
});

testWidgets('clears validation error when valid input is entered', (tester) async {
  // Test implementation
});

testWidgets('prevents save when validation fails', (tester) async {
  // Test implementation
});
```

#### Update ViewModel Tests
**File**: Create `test/presentation/view_models/transaction_form_view_model_test.dart`

Test validation logic:
```dart
test('validates name is not empty', () {
  // Test implementation
});

test('validates description does not exceed 200 characters', () {
  // Test implementation
});

test('validates amount is positive', () {
  // Test implementation
});

test('validateForm returns false when fields are invalid', () {
  // Test implementation
});

test('validateForm returns true when all fields are valid', () {
  // Test implementation
});
```

#### Update Golden Tests
**File**: `test/golden/screens/transaction_form_screen_test.dart`

Add scenarios with validation errors:
```dart
GoldenTestScenario(
  name: 'validation_errors',
  child: _buildScenarioWithErrors(
    TransactionType.debt,
    null,
    AppTheme.lightTheme(),
  ),
),
```

### Phase 5: Update Transaction Model Validation Messages
**File**: `lib/data/models/transaction.dart`

Consider updating the `validate()` method to use localization keys instead of hardcoded strings, or keep backend validation separate from UI validation.

Option: Keep backend validation as-is (throws ArgumentError with English messages) and ensure ViewModel catches and translates these appropriately.

## Testing Checklist

### Manual Testing
- [ ] Empty name shows validation error immediately on blur
- [ ] Description exceeding 200 chars shows validation error
- [ ] Amount of 0 or empty shows validation error
- [ ] Save button is disabled or shows error when validation fails
- [ ] Error messages are localized correctly in both EN and PL
- [ ] Validation errors clear when valid input is entered
- [ ] Character counter updates correctly for description
- [ ] Form can be saved when all validations pass

### Automated Testing
- [ ] All existing unit tests pass
- [ ] New validation unit tests pass
- [ ] Widget tests verify validation UI behavior
- [ ] Golden tests capture validation error states
- [ ] Localization tests verify error messages in both languages

## Implementation Order

1. **Step 1**: Add missing localization strings (Phase 3)
2. **Step 2**: Add validation logic to ViewModel (Phase 1)
3. **Step 3**: Update UI to display validation errors (Phase 2)
4. **Step 4**: Generate localization files (`flutter gen-l10n`)
5. **Step 5**: Run and verify manual testing
6. **Step 6**: Add/update automated tests (Phase 4)
7. **Step 7**: Run `flutter analyze` and `flutter test`
8. **Step 8**: Format code with `dart format .`
9. **Step 9**: Update golden test baselines if needed

## Dependencies
- No new package dependencies required
- Uses existing localization infrastructure
- Uses existing ViewModel pattern with ChangeNotifier

## Acceptance Criteria
- [x] Name field shows error when empty
- [x] Description field shows error when > 200 characters
- [x] Amount field shows error when empty or zero
- [x] Validation errors appear in real-time as user types
- [x] Validation errors are localized (EN/PL)
- [x] Form cannot be saved with validation errors
- [x] All existing tests pass
- [x] New validation tests added and passing
- [x] Code follows project style guidelines
- [x] Golden tests updated to show validation states

## Estimated Effort
- Implementation: 2-3 hours
- Testing: 1-2 hours
- Total: 3-5 hours

## Notes
- The current implementation already has backend validation in `Transaction.validate()`
- This task focuses on adding **frontend/UI validation** for better UX
- Real-time validation provides immediate feedback to users
- Keep backend validation as final safety check
- Consider adding debouncing for description validation to avoid too many updates while typing
