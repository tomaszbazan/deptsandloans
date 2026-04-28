# TASK-0044: Implement Currency Formatting

## Task Description
Format amounts according to device locale (separators, decimal places, currency symbols) to ensure consistent, locale-aware display across the entire application.

## Current State Analysis

### Existing Implementation
The application currently has **inconsistent** currency formatting:

1. **Two Formatting Approaches:**
   - **Locale-aware**: Uses `NumberFormat.currency()` from `intl` package (2 locations)
   - **Manual**: Uses `toStringAsFixed(2)` with string interpolation (4 locations)

2. **Currency Model** (`lib/data/models/currency.dart`):
   - Enum with 4 currencies: PLN, EUR, USD, GBP
   - Extension providing symbols only (zł, €, $, £)
   - No full currency names or ISO codes

3. **Amount Storage:**
   - Stored as integers (cents) in database
   - Converted to doubles via `amountInMainUnit` getter

4. **Files with Currency Display:**
   - `lib/presentation/widgets/transaction_list_item.dart` - ✅ Uses NumberFormat
   - `lib/presentation/widgets/transaction_details/transaction_info_section.dart` - ❌ Manual
   - `lib/presentation/widgets/transaction_details/repayment_list_item.dart` - ❌ Manual
   - `lib/presentation/widgets/transaction_details/progress_section.dart` - ❌ Manual
   - `lib/presentation/widgets/repayment_form.dart` - ✅ Uses NumberFormat
   - `lib/core/notifications/notification_content_formatter.dart` - ✅ Uses NumberFormat

### Problems to Solve
1. **Inconsistent formatting** across UI components
2. **No centralized formatting logic** leading to code duplication
3. **Missing currency metadata** (full names, ISO codes)
4. **Manual formatting ignores locale** (decimal separators, grouping)
5. **Repetitive code** creating NumberFormat instances

## Implementation Plan

### 1. Enhance Currency Model
**File:** `lib/data/models/currency.dart`

**Changes:**
- Add `code` getter returning ISO 4217 codes (PLN, EUR, USD, GBP)
- Add `name(Locale locale)` method returning localized currency names
- Keep existing `symbol` getter for compatibility

**Example:**
```dart
extension CurrencyExtension on Currency {
  String get code {
    switch (this) {
      case Currency.pln: return 'PLN';
      case Currency.eur: return 'EUR';
      case Currency.usd: return 'USD';
      case Currency.gbp: return 'GBP';
    }
  }

  String get symbol { /* existing */ }

  String name(Locale locale) {
    // Return localized names based on locale
  }
}
```

### 2. Create Currency Formatter Utility
**New File:** `lib/core/utils/currency_formatter.dart`

**Purpose:** Centralized, locale-aware currency formatting

**Implementation:**
```dart
class CurrencyFormatter {
  static String format({
    required double amount,
    required Currency currency,
    required Locale locale,
  }) {
    return NumberFormat.currency(
      locale: locale.toString(),
      symbol: currency.symbol,
      decimalDigits: 2,
    ).format(amount);
  }

  // Optional: Method to get formatter instance for reuse
  static NumberFormat getFormatter({
    required Currency currency,
    required Locale locale,
  }) {
    return NumberFormat.currency(
      locale: locale.toString(),
      symbol: currency.symbol,
      decimalDigits: 2,
    );
  }
}
```

**Benefits:**
- Single source of truth for formatting logic
- Consistent locale handling
- Easy to update formatting rules globally
- Testable and maintainable

### 3. Update UI Components

#### Files to Modify:

**A. TransactionInfoSection** (`lib/presentation/widgets/transaction_details/transaction_info_section.dart`)
- Replace: `'${transaction.amountInMainUnit.toStringAsFixed(2)} ${transaction.currency.symbol}'`
- With: `CurrencyFormatter.format(amount: transaction.amountInMainUnit, currency: transaction.currency, locale: Localizations.localeOf(context))`

**B. RepaymentListItem** (`lib/presentation/widgets/transaction_details/repayment_list_item.dart`)
- Replace: `'${repayment.amountInMainUnit.toStringAsFixed(2)} ${currency.symbol}'`
- With: `CurrencyFormatter.format(amount: repayment.amountInMainUnit, currency: currency, locale: Localizations.localeOf(context))`

**C. ProgressSection** (`lib/presentation/widgets/transaction_details/progress_section.dart`)
- Replace: `'${amount.toStringAsFixed(2)} ${currency.symbol}'` (used twice for paid/remaining)
- With: `CurrencyFormatter.format(amount: amount, currency: currency, locale: Localizations.localeOf(context))`

**D. TransactionListItem** (`lib/presentation/widgets/transaction_list_item.dart`)
- Refactor existing NumberFormat usage to use CurrencyFormatter
- Remove local `currencyFormat` variable
- Use formatter utility for consistency

**E. RepaymentForm** (`lib/presentation/widgets/repayment_form.dart`)
- Refactor existing NumberFormat usage to use CurrencyFormatter
- Simplify balance display logic

### 4. Locale-Specific Formatting Verification

**Test Cases to Verify:**

| Locale | Currency | Amount | Expected Output |
|--------|----------|--------|-----------------|
| en_US  | USD      | 1234.56 | $1,234.56      |
| en_US  | EUR      | 1234.56 | €1,234.56      |
| pl_PL  | PLN      | 1234.56 | 1 234,56 zł    |
| pl_PL  | EUR      | 1234.56 | 1 234,56 €     |
| en_GB  | GBP      | 1234.56 | £1,234.56      |

**Key Differences:**
- **Decimal separator**: dot (.) vs comma (,)
- **Thousands separator**: comma (,) vs space
- **Symbol position**: before vs after amount

### 5. Update Tests

**New Test File:** `test/core/utils/currency_formatter_test.dart`

**Test Coverage:**
- Format amounts in different locales (en, pl)
- Format different currencies (PLN, EUR, USD, GBP)
- Verify decimal places
- Verify separators (decimal and grouping)
- Verify symbol placement

**Update Golden Tests:**
- Regenerate all golden images with proper formatting
- Verify visual consistency across locales

**Files with Golden Tests:**
- `test/presentation/widgets/transaction_list_item_test.dart`
- `test/presentation/widgets/transaction_details/transaction_info_section_test.dart`
- `test/presentation/widgets/transaction_details/repayment_list_item_test.dart`
- `test/presentation/widgets/transaction_details/progress_section_test.dart`
- `test/presentation/widgets/repayment_form_test.dart`

### 6. Add Localization Strings (Optional Enhancement)

**Files:**
- `lib/l10n/app_en.arb`
- `lib/l10n/app_pl.arb`

**New Keys:**
```json
{
  "currencyPLN": "Polish Zloty",
  "currencyEUR": "Euro",
  "currencyUSD": "US Dollar",
  "currencyGBP": "British Pound"
}
```

## Implementation Steps

### Step 1: Create Currency Formatter Utility
- [ ] Create `lib/core/utils/currency_formatter.dart`
- [ ] Implement `format()` method with locale support
- [ ] Add unit tests in `test/core/utils/currency_formatter_test.dart`

### Step 2: Enhance Currency Model
- [ ] Update `lib/data/models/currency.dart`
- [ ] Add `code` getter for ISO codes
- [ ] Add `name(Locale)` method for localized names (optional)
- [ ] Update tests if they exist

### Step 3: Update UI Components
- [ ] Update `TransactionInfoSection` to use formatter
- [ ] Update `RepaymentListItem` to use formatter
- [ ] Update `ProgressSection` to use formatter
- [ ] Refactor `TransactionListItem` to use formatter
- [ ] Refactor `RepaymentForm` to use formatter

### Step 4: Verify and Test
- [ ] Run `flutter analyze` to check for errors
- [ ] Run `flutter test` to verify all tests pass
- [ ] Regenerate golden tests for updated widgets
- [ ] Manually test with different locales (en, pl)
- [ ] Verify formatting for all 4 currencies

### Step 5: Final Cleanup
- [ ] Run `dart format .` to format code
- [ ] Remove any unused imports
- [ ] Verify consistent formatting across all files

## Acceptance Criteria

✅ All amounts are formatted using centralized `CurrencyFormatter` utility
✅ Formatting respects device/app locale (decimal separator, grouping)
✅ All 4 currencies (PLN, EUR, USD, GBP) display correctly
✅ English locale uses dot (.) as decimal separator and comma (,) for grouping
✅ Polish locale uses comma (,) as decimal separator and space for grouping
✅ All UI components show consistent formatting
✅ No manual `toStringAsFixed()` usage for currency display
✅ All tests pass (`flutter test`)
✅ No analysis errors (`flutter analyze`)
✅ Golden tests updated and passing
✅ Code formatted (`dart format .`)

## Files Modified Summary

### New Files:
1. `lib/core/utils/currency_formatter.dart`
2. `test/core/utils/currency_formatter_test.dart`

### Modified Files:
1. `lib/data/models/currency.dart`
2. `lib/presentation/widgets/transaction_list_item.dart`
3. `lib/presentation/widgets/transaction_details/transaction_info_section.dart`
4. `lib/presentation/widgets/transaction_details/repayment_list_item.dart`
5. `lib/presentation/widgets/transaction_details/progress_section.dart`
6. `lib/presentation/widgets/repayment_form.dart`

### Test Files to Update:
1. All golden test files for modified widgets
2. Any existing unit tests for modified components

## Estimated Impact
- **High**: Affects all currency displays across the application
- **Low Risk**: Centralized approach makes rollback easy if issues arise
- **User-Facing**: Improves UX with proper locale-aware formatting
- **Maintainability**: Reduces code duplication and improves consistency

## References
- Flutter `intl` package: https://pub.dev/packages/intl
- NumberFormat documentation: https://api.flutter.dev/flutter/intl/NumberFormat-class.html
- ISO 4217 Currency Codes: https://en.wikipedia.org/wiki/ISO_4217
