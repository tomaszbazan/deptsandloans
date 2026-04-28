# Implementation Plan: TASK-0018 - Implement Edit Transaction

## Overview
Enable editing existing transactions with the restriction that the initial Amount field cannot be modified after creation.

## Current State Analysis
Based on the backlog, we have:
- Transaction Form Screen (TASK-0014) ✓
- Form Validation (TASK-0015) ✓
- Currency Selection (TASK-0016) ✓
- Save Transaction functionality (TASK-0017) ✓
- Transaction Details Screen (TASK-0025) ✓

## Implementation Steps

### 1. Extend Transaction Form to Support Edit Mode
**Files to modify:**
- `lib/presentation/screens/transaction_form_screen.dart` (or similar)
- `lib/presentation/widgets/transaction_form.dart` (if form is separated)

**Changes:**
- Add optional `Transaction?` parameter to constructor to indicate edit mode
- Populate form fields with existing transaction data when in edit mode
- Disable/make read-only the Amount field when editing
- Update screen title to reflect "Edit Transaction" vs "Add Transaction"

### 2. Update Repository Layer
**Files to modify:**
- `lib/data/repositories/transaction_repository.dart`

**Changes:**
- Verify `update()` method exists and properly handles transaction updates
- Ensure the method doesn't allow changing the initial amount field
- Add validation to prevent amount modification at repository level

### 3. Add Navigation to Edit Screen
**Files to modify:**
- `lib/presentation/screens/transaction_details_screen.dart`
- Router configuration file (likely using `go_router`)

**Changes:**
- Add "Edit" button/icon in transaction details screen
- Add route for edit transaction screen with transaction ID parameter
- Pass transaction object to edit form

### 4. Update Form Validation Logic
**Files to modify:**
- Form validation logic files

**Changes:**
- Keep existing validation for Name (non-empty) and Description (max 200 chars)
- Ensure Amount field validation is bypassed in edit mode (since it's read-only)

### 5. Handle State Management
**Files to modify:**
- State management files (ViewModel/ChangeNotifier/etc.)

**Changes:**
- Update state management to handle edit operation
- Ensure UI refreshes properly after edit
- Navigate back to details/list screen after successful update

### 6. Add Visual Indicators
**Files to modify:**
- Form UI components

**Changes:**
- Show visual indication that Amount field is read-only (disabled styling, helper text)
- Add explanatory text: "Amount cannot be changed after creation"

## Testing Strategy

### Unit Tests
- Test repository update method
- Test that amount field cannot be modified
- Test validation logic for edit mode

### Widget Tests
- Test form in edit mode renders correctly
- Test Amount field is disabled in edit mode
- Test other fields are editable
- Test form submission with updated data

### Integration Tests
- Test complete flow: navigate to details → edit → save → verify changes
- Test that amount remains unchanged after edit

### Golden Tests
- Add golden test for edit form screen showing disabled amount field
- Compare with add form to verify visual differences

## Edge Cases to Consider
1. What if transaction has repayments? Should editing be restricted?
2. Concurrent edits (if multi-device support is added later)
3. Validation when currency is already set (can it be changed?)
4. How to handle if transaction is completed/archived?

## Success Criteria
- [ ] User can navigate to edit screen from transaction details
- [ ] All fields except Amount are editable
- [ ] Amount field is visually disabled with explanation
- [ ] Form validation works correctly in edit mode
- [ ] Changes are persisted to local database
- [ ] UI updates reflect the changes immediately
- [ ] All tests pass (unit, widget, integration, golden)
- [ ] `flutter analyze` passes with no issues
- [ ] Code is formatted with `dart format`

## Dependencies
- Requires TASK-0025 (Transaction Details Screen) - Already completed
- Blocks TASK-0019 (Delete Transaction) - Can be implemented independently

## Estimated Complexity
**Medium** - Requires modifications to existing form logic, navigation setup, and careful handling of read-only fields with proper validation.
