# Manual Testing Checklist - Multi-Currency Display (TASK-0045)

## Overview

This checklist ensures comprehensive manual testing of currency display across all supported currencies and locales.

## Test Environment Setup

- [ ] Android emulator/device available
- [ ] App built in debug mode
- [ ] Ability to change device system locale
- [ ] Test data prepared

## Pre-Testing Verification

- [ ] All automated tests pass (`flutter test`)
- [ ] No analysis warnings (`flutter analyze`)
- [ ] Golden tests regenerated and verified
- [ ] App builds successfully

## Test Execution

### Section 1: English Locale Testing

**Setup:** Set device system locale to English (United States or United Kingdom)

#### PLN Currency

- [ ] Create new debt with PLN currency, amount: 1234.56
  - [ ] Verify format in transaction list: `zł1,234.56`
  - [ ] Verify decimal separator is `.` (dot)
  - [ ] Verify thousands separator is `,` (comma)
  - [ ] Verify currency symbol appears before amount
- [ ] Open transaction details
  - [ ] Verify original amount format: `zł1,234.56`
  - [ ] Verify remaining balance format: `zł1,234.56`
- [ ] Add partial repayment: 234.56
  - [ ] Verify repayment amount format in history: `zł234.56`
  - [ ] Verify updated balance format: `zł1,000.00`
  - [ ] Verify paid/remaining amounts in progress section

#### EUR Currency

- [ ] Create new debt with EUR currency, amount: 5678.90
  - [ ] Verify format in transaction list: `€5,678.90`
  - [ ] Verify symbol position (before amount)
  - [ ] Verify separators (`.` for decimal, `,` for thousands)
- [ ] Open transaction details
  - [ ] Verify all amounts formatted correctly with €
- [ ] Add repayment: 678.90
  - [ ] Verify repayment displays as `€678.90`
  - [ ] Verify balance updates to `€5,000.00`

#### USD Currency

- [ ] Create new debt with USD currency, amount: 9876.54
  - [ ] Verify format in transaction list: `$9,876.54`
  - [ ] Verify $ symbol appears before amount
  - [ ] Verify proper separators
- [ ] Open transaction details
  - [ ] Verify consistent USD formatting throughout
- [ ] Add repayment: 876.54
  - [ ] Verify formatting: `$876.54`
  - [ ] Verify balance: `$9,000.00`

#### GBP Currency

- [ ] Create new debt with GBP currency, amount: 3456.78
  - [ ] Verify format in transaction list: `£3,456.78`
  - [ ] Verify £ symbol placement
  - [ ] Verify separators
- [ ] Open transaction details
  - [ ] Verify all GBP amounts formatted correctly
- [ ] Add repayment: 456.78
  - [ ] Verify formatting: `£456.78`
  - [ ] Verify balance: `£3,000.00`

#### Edge Cases (English Locale)

- [ ] Create debt with small amount: 0.01 PLN
  - [ ] Verify displays as `zł0.01`
- [ ] Create debt with large amount: 1,000,000.00 EUR
  - [ ] Verify displays as `€1,000,000.00`
  - [ ] Verify all thousands separators present
- [ ] Add repayment that results in 0.00 balance
  - [ ] Verify displays as `zł0.00` (or appropriate currency)
  - [ ] Transaction marked as completed

### Section 2: Polish Locale Testing

**Setup:** Set device system locale to Polski (Polish)

**Expected Changes:**
- Decimal separator: `,` (comma)
- Thousands separator: ` ` (space, non-breaking)
- Symbol position: After amount

#### PLN Currency

- [ ] Create new debt with PLN currency, amount: 1234.56
  - [ ] Verify format in transaction list: `1 234,56 zł`
  - [ ] Verify decimal separator is `,` (comma)
  - [ ] Verify thousands separator is space
  - [ ] Verify currency symbol appears after amount
- [ ] Open transaction details
  - [ ] Verify original amount: `1 234,56 zł`
  - [ ] Verify remaining balance: `1 234,56 zł`
- [ ] Add partial repayment: 234.56
  - [ ] Verify repayment: `234,56 zł`
  - [ ] Verify balance: `1 000,00 zł`

#### EUR Currency

- [ ] Create new debt with EUR currency, amount: 5678.90
  - [ ] Verify format: `5 678,90 €`
  - [ ] Verify € symbol after amount
  - [ ] Verify proper separators
- [ ] Open transaction details
  - [ ] Verify consistent EUR formatting
- [ ] Add repayment: 678.90
  - [ ] Verify: `678,90 €`
  - [ ] Verify balance: `5 000,00 €`

#### USD Currency

- [ ] Create new debt with USD currency, amount: 9876.54
  - [ ] Verify format: `9 876,54 USD`
  - [ ] Verify ISO code (USD) used instead of $ symbol
  - [ ] Verify code appears after amount
- [ ] Open transaction details
  - [ ] Verify USD code throughout
- [ ] Add repayment: 876.54
  - [ ] Verify: `876,54 USD`
  - [ ] Verify balance: `9 000,00 USD`

#### GBP Currency

- [ ] Create new debt with GBP currency, amount: 3456.78
  - [ ] Verify format: `3 456,78 GBP`
  - [ ] Verify ISO code (GBP) used instead of £ symbol
  - [ ] Verify code placement
- [ ] Open transaction details
  - [ ] Verify GBP code throughout
- [ ] Add repayment: 456.78
  - [ ] Verify: `456,78 GBP`
  - [ ] Verify balance: `3 000,00 GBP`

#### Edge Cases (Polish Locale)

- [ ] Create debt with small amount: 0.01 PLN
  - [ ] Verify displays as `0,01 zł`
- [ ] Create debt with large amount: 1,000,000.00 EUR
  - [ ] Verify displays as `1 000 000,00 €`
  - [ ] Verify space separators between thousands
- [ ] Add repayment resulting in 0.00 balance
  - [ ] Verify displays as `0,00 zł` (or appropriate currency)

### Section 3: Locale Switching

- [ ] Start with English locale
- [ ] Create transactions in all 4 currencies
- [ ] Verify all display correctly in English format
- [ ] Change device locale to Polish
- [ ] Restart app (or wait for locale detection)
- [ ] Verify all existing transactions now display in Polish format
- [ ] Create new transaction
- [ ] Verify new transaction uses Polish format
- [ ] Switch back to English locale
- [ ] Verify all transactions return to English format

### Section 4: Notifications (if applicable)

**Note:** Requires setting up reminders

#### English Locale

- [ ] Set reminder for a PLN transaction
- [ ] Trigger notification (or wait for scheduled time)
- [ ] Verify notification displays amount as `zł1,234.56`
- [ ] Repeat for EUR, USD, GBP

#### Polish Locale

- [ ] Set reminder for a PLN transaction
- [ ] Trigger notification
- [ ] Verify notification displays amount as `1 234,56 zł`
- [ ] Repeat for EUR, USD, GBP

### Section 5: Mixed Currency Display

- [ ] Create 4 transactions, one for each currency
- [ ] Verify all display simultaneously in transaction list
- [ ] Each uses correct formatting for current locale
- [ ] No mixing of formats between currencies
- [ ] Open each transaction details
- [ ] Verify individual formatting remains correct

### Section 6: Visual Quality

- [ ] No text overflow in any currency format
- [ ] Currency symbols render correctly (no boxes/missing chars)
- [ ] Proper spacing around currency symbols
- [ ] Amounts align properly in lists
- [ ] Format consistent across light and dark modes

#### Light Mode

- [ ] All currencies readable
- [ ] Symbols clearly visible
- [ ] No color/contrast issues

#### Dark Mode

- [ ] All currencies readable
- [ ] Symbols clearly visible
- [ ] No color/contrast issues

### Section 7: Stress Testing

- [ ] Create transaction with maximum practical amount (999,999,999.99)
  - [ ] Verify formatting doesn't break
  - [ ] UI doesn't overflow
- [ ] Create 20+ transactions with different currencies
  - [ ] List performance acceptable
  - [ ] All format correctly
- [ ] Rapidly switch between locales
  - [ ] No crashes
  - [ ] Formatting updates correctly

## Defects Found

Use this section to document any issues discovered during testing:

| # | Date | Locale | Currency | Issue Description | Severity | Status |
|---|------|--------|----------|-------------------|----------|--------|
| 1 |      |        |          |                   |          |        |
| 2 |      |        |          |                   |          |        |
| 3 |      |        |          |                   |          |        |

## Test Summary

**Testing Date:** _______________

**Tested By:** _______________

**Device/Emulator:** _______________

**Android Version:** _______________

**App Version:** _______________

### Results Summary

- Total test cases: _______________
- Passed: _______________
- Failed: _______________
- Blocked: _______________
- Not Tested: _______________

### Pass/Fail Criteria

- [x] All critical test cases pass (Currency display in both locales)
- [ ] No critical defects found
- [ ] No visual/UI issues
- [ ] Performance acceptable
- [ ] All edge cases handled

### Overall Result

- [ ] **PASS** - All tests passed, ready for production
- [ ] **PASS WITH MINOR ISSUES** - Minor issues found, documented, acceptable
- [ ] **FAIL** - Critical issues found, requires fixes before release

## Notes

Use this space for additional observations, comments, or recommendations:

---

## Sign-Off

**Tester Signature:** _______________

**Date:** _______________

**Project Lead Approval:** _______________

**Date:** _______________
