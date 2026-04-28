# TASK-0045: Test Multi-Currency Display

## Task Description

Verify correct display of PLN, EUR, USD, GBP in both locales (Polish and English) across the entire
application to ensure currency formatting is consistent, accurate, and locale-aware.

## Current State Analysis

### Completed Prerequisites

✅ **TASK-0044**: CurrencyFormatter utility class implemented

- Centralized currency formatting using `intl` package
- Locale-aware formatting with proper separators and symbols
- Unit tests covering all 4 currencies in both locales

### Existing Test Coverage

#### Unit Tests

1. **CurrencyFormatter Tests** (`test/core/utils/currency_formatter_test.dart`)
    - ✅ USD in en_US locale
    - ✅ EUR in en_US and pl_PL locales
    - ✅ PLN in pl_PL locale
    - ✅ GBP in en_GB locale
    - ✅ Edge cases (zero, negative, large amounts)

#### Golden Tests (Visual Regression)

1. **TransactionListItem** (`test/golden/widgets/transaction_list_item_test.dart`)
    - Tests with PLN, EUR, USD, GBP
    - Tests in light and dark mode
    - ❓ Locale coverage unclear

2. **TransactionInfoSection** (`test/golden/widgets/transaction_info_section_test.dart`)
3. **RepaymentListItem** (`test/golden/widgets/repayment_list_item_test.dart`)
4. **ProgressSection** (`test/golden/widgets/progress_section_test.dart`)
5. **RepaymentForm** (`test/golden/widgets/repayment_form_test.dart`)
6. **TransactionDetailsScreen** (`test/golden/screens/transaction_details_screen_test.dart`)
7. **TransactionFormScreen** (`test/golden/screens/transaction_form_screen_test.dart`)
8. **MainScreen** (`test/golden/screens/main_screen_test.dart`)

### What Needs Testing

#### Locale Coverage Matrix

Test all 4 currencies (PLN, EUR, USD, GBP) in both locales (en, pl):

| Currency | English Locale | Polish Locale |
|----------|----------------|---------------|
| PLN      | 1,234.56 zł    | 1 234,56 zł   |
| EUR      | €1,234.56      | 1 234,56 €    |
| USD      | $1,234.56      | 1 234,56 $    |
| GBP      | £1,234.56      | 1 234,56 £    |

#### Key Formatting Differences

**English Locale (en_US, en_GB)**:

- Decimal separator: `.` (dot)
- Thousands separator: `,` (comma)
- Symbol position: Before amount (usually)
- Format: `$1,234.56`

**Polish Locale (pl_PL)**:

- Decimal separator: `,` (comma)
- Thousands separator: ` ` (non-breaking space `\u00A0`)
- Symbol position: After amount
- Format: `1 234,56 zł`

### Components Using Currency Formatting

All components now use `CurrencyFormatter.format()` from TASK-0044:

1. **TransactionListItem** - displays transaction amount and balance
2. **TransactionInfoSection** - shows original amount and remaining balance
3. **RepaymentListItem** - displays repayment amount
4. **ProgressSection** - shows paid and remaining amounts
5. **RepaymentForm** - displays remaining balance
6. **NotificationContentFormatter** - formats amounts in notifications

## Implementation Plan

### Step 1: Create Comprehensive Multi-Currency Test Suite

**New Test File**: `test/multi_currency/currency_display_test.dart`

**Purpose**: Integration test verifying end-to-end currency display

**Test Structure**:

```dart
void main() {
  group('Multi-Currency Display Tests', () {
    group('English Locale (en_US)', () {
      testWidgets('displays PLN correctly', (tester) async {
        ...
      });
      testWidgets('displays EUR correctly', (tester) async {
        ...
      });
      testWidgets('displays USD correctly', (tester) async {
        ...
      });
      testWidgets('displays GBP correctly', (tester) async {
        ...
      });
    });

    group('Polish Locale (pl_PL)', () {
      testWidgets('displays PLN correctly', (tester) async {
        ...
      });
      testWidgets('displays EUR correctly', (tester) async {
        ...
      });
      testWidgets('displays USD correctly', (tester) async {
        ...
      });
      testWidgets('displays GBP correctly', (tester) async {
        ...
      });
    });
  });
}
```

**Test Coverage**:

- Create transaction with each currency
- Navigate to transaction details
- Verify amount formatting in list view
- Verify amount formatting in details view
- Add repayment and verify formatting
- Check progress bar amounts

### Step 2: Enhance Golden Tests with Locale Variants

**Update Existing Golden Tests** to include both locales:

#### A. TransactionListItem Golden Tests

- Add explicit locale variants for each currency
- Test scenarios:
    - PLN in en vs pl locale
    - EUR in en vs pl locale
    - USD in en vs pl locale
    - GBP in en vs pl locale

#### B. TransactionDetailsScreen Golden Tests

- Full screen tests with different currency/locale combinations
- Test complete transaction flow

#### C. RepaymentForm Golden Tests

- Balance display in different locales
- Currency symbol rendering

### Step 3: Create Visual Comparison Documentation

**New File**: `docs/TASK-0045/currency_display_reference.md`

**Contents**:

- Screenshots/visual examples of each currency in both locales
- Expected formatting rules
- Common pitfalls and edge cases
- Troubleshooting guide

### Step 4: Manual Testing Checklist

Create comprehensive manual testing checklist:

**Checklist Items**:

1. ✓ Create debt with PLN in English locale
2. ✓ Create debt with PLN in Polish locale
3. ✓ Create debt with EUR in English locale
4. ✓ Create debt with EUR in Polish locale
5. ✓ Create debt with USD in English locale
6. ✓ Create debt with USD in Polish locale
7. ✓ Create debt with GBP in English locale
8. ✓ Create debt with GBP in Polish locale
9. ✓ Add repayment and verify formatting
10. ✓ Check notification formatting
11. ✓ Verify on Android device with different system locales
12. ✓ Switch app locale and verify changes

### Step 5: Edge Case Testing

**Test Scenarios**:

1. **Very small amounts**: 0.01, 0.99
2. **Large amounts**: 1,000,000+
3. **Precise decimals**: 1234.56789 (should round to 2 decimals)
4. **Zero amounts**: 0.00
5. **Negative amounts**: -1234.56 (for repayments/adjustments)
6. **Locale switching**: Change locale mid-session
7. **Mixed currencies**: Multiple transactions with different currencies

## Implementation Steps

### Step 1: Create Multi-Currency Integration Test

- [ ] Create `test/multi_currency/` directory
- [ ] Create `currency_display_test.dart`
- [ ] Implement English locale tests (4 currencies)
- [ ] Implement Polish locale tests (4 currencies)
- [ ] Add edge case tests
- [ ] Run tests and verify all pass

### Step 2: Enhance Golden Tests

- [ ] Review existing golden tests for currency coverage
- [ ] Add missing currency/locale combinations
- [ ] Update golden test scenarios with explicit locales
- [ ] Regenerate golden images for new scenarios
- [ ] Verify visual consistency

### Step 3: Create Documentation

- [ ] Create `currency_display_reference.md`
- [ ] Document expected formatting for each currency/locale
- [ ] Add troubleshooting section
- [ ] Include code examples

### Step 4: Manual Testing

- [ ] Create manual testing checklist document
- [ ] Test on Android emulator with English locale
- [ ] Test on Android emulator with Polish locale
- [ ] Test locale switching
- [ ] Test all 4 currencies in both locales
- [ ] Verify notification formatting
- [ ] Document any issues found

### Step 5: Verification

- [ ] Run `flutter test` - all tests pass
- [ ] Run `flutter analyze` - no warnings related to currency
- [ ] Generate test coverage report
- [ ] Review coverage for currency-related code
- [ ] Mark TASK-0045 as completed in backlog

## Expected Test File Structure

```
test/
├── multi_currency/
│   ├── currency_display_test.dart         # NEW: Integration tests
│   └── currency_edge_cases_test.dart      # NEW: Edge case tests
├── golden/
│   ├── widgets/
│   │   ├── transaction_list_item_test.dart    # ENHANCE: Add locale variants
│   │   ├── transaction_info_section_test.dart # ENHANCE: Add locale variants
│   │   ├── repayment_form_test.dart           # ENHANCE: Add locale variants
│   │   └── progress_section_test.dart         # ENHANCE: Add locale variants
│   └── screens/
│       ├── transaction_details_screen_test.dart # ENHANCE: Add locale variants
│       └── transaction_form_screen_test.dart    # ENHANCE: Add locale variants
└── core/
    └── utils/
        └── currency_formatter_test.dart    # EXISTING: Already comprehensive
```

## Acceptance Criteria

### Automated Tests

✅ All CurrencyFormatter unit tests pass (already implemented)
✅ New multi-currency integration tests pass for all 8 combinations (4 currencies × 2 locales)
✅ All golden tests pass with updated currency/locale scenarios
✅ Edge case tests pass (small, large, zero, negative amounts)
✅ No test flakiness related to currency formatting

### Visual Verification

✅ Golden images correctly show:

- Proper decimal separator for each locale (. vs ,)
- Proper thousands separator for each locale (, vs space)
- Correct currency symbol placement (before vs after)
- Consistent formatting across all components

### Manual Testing

✅ All currencies display correctly in English locale
✅ All currencies display correctly in Polish locale
✅ Currency formatting updates when switching locale
✅ Notifications show correct currency formatting
✅ No formatting issues on physical Android device
✅ No visual glitches or text overflow

### Code Quality

✅ All tests run successfully (`flutter test`)
✅ No analysis warnings (`flutter analyze`)
✅ Test coverage ≥80% for currency-related code
✅ Code formatted (`dart format .`)

### Documentation

✅ Currency display reference document created
✅ Manual testing checklist completed
✅ Any issues documented with resolutions

## Test Matrix Summary

| Component              | PLN/en | EUR/en | USD/en | GBP/en | PLN/pl | EUR/pl | USD/pl | GBP/pl |
|------------------------|--------|--------|--------|--------|--------|--------|--------|--------|
| TransactionListItem    | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      |
| TransactionInfoSection | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      |
| RepaymentListItem      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      |
| ProgressSection        | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      |
| RepaymentForm          | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      |
| NotificationFormatter  | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      | ✓      |

**Total Scenarios**: 48 (6 components × 4 currencies × 2 locales)

## Estimated Effort

- **Test Creation**: 2-3 hours
- **Golden Test Enhancement**: 1-2 hours
- **Manual Testing**: 1-2 hours
- **Documentation**: 1 hour
- **Total**: 5-8 hours

## Dependencies

- ✅ TASK-0044 (Currency Formatting) - **Completed**
- ✅ TASK-0043 (Locale Detection) - **Completed**
- ✅ TASK-0042 (Translation Files) - **Completed**

## Risks & Mitigation

### Risk 1: Flaky Golden Tests

**Impact**: Medium
**Mitigation**: Use consistent test data, fixed dates, and proper widget wrapping

### Risk 2: Platform-Specific Rendering

**Impact**: Low
**Mitigation**: Test on multiple Android versions, use font fallbacks

### Risk 3: Locale-Specific Edge Cases

**Impact**: Low
**Mitigation**: Comprehensive edge case test suite, manual testing

## Success Metrics

1. **Test Coverage**: ≥80% for currency-related code
2. **Zero Failures**: All automated tests pass
3. **Visual Consistency**: All golden tests match expected output
4. **Manual Verification**: All manual test checklist items pass
5. **No Regressions**: Existing tests continue to pass

## Notes

- This task focuses on **verification and testing**, not implementation
- TASK-0044 already implemented the currency formatting functionality
- The goal is to ensure comprehensive test coverage and visual verification
- Both automated and manual testing are required
- Documentation is crucial for future maintenance
- This task validates that TASK-0044 was implemented correctly

## References

- Flutter `intl` package: https://pub.dev/packages/intl
- NumberFormat documentation: https://api.flutter.dev/flutter/intl/NumberFormat-class.html
- Alchemist golden testing: https://pub.dev/packages/alchemist
- ISO 4217 Currency Codes: https://en.wikipedia.org/wiki/ISO_4217
- CLDR Locale Data: http://cldr.unicode.org/
