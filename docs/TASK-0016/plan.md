# TASK-0016: Implement Currency Selection

## Overview
Create a currency picker supporting PLN, EUR, USD, GBP with proper locale-based formatting.

## Current State Analysis
- Transaction form screen exists with basic fields
- Currency field needs to be implemented with picker functionality
- Need to support 4 currencies: PLN, EUR, USD, GBP
- Must format amounts according to locale settings

## Implementation Steps

### 1. Create Currency Model
- Define `Currency` enum with PLN, EUR, USD, GBP
- Add currency symbol getter

### 2. Update Transaction Model
- Ensure `currency` field is properly integrated
- Add default currency (PLN)

### 3. Create Currency Picker Widget
- Design reusable currency picker component
- Display currency code and symbol
- Support dropdown or bottom sheet selection
- Apply proper theming (light/dark mode)

### 4. Integrate Currency Picker in Transaction Form
- Add currency picker to form UI
- Position near amount field for better UX
- Update form validation to include currency
- Ensure currency is saved with transaction

### 5. Implement Currency Formatting
- Use `intl` package for locale-based formatting
- Format amounts with proper decimal separators
- Display currency symbols according to locale
- Handle different decimal places per currency

### 6. Update Transaction Display
- Format currency in transaction list
- Format currency in transaction details
- Ensure consistent formatting across app

### 7. Testing
- Write widget tests for currency picker
- Test currency formatting with different locales
- Test form submission with different currencies
- Add golden tests for currency picker UI

## Dependencies
- `intl` package (likely already added for localization)
- Existing form infrastructure
- Transaction model and repository

## Technical Considerations
- Currency formatting must respect locale settings
- Default currency should be PLN
- Picker should be accessible and easy to use
- Consider using Material dropdown or custom bottom sheet
- Ensure currency changes trigger form updates

## Acceptance Criteria
- [ ] User can select from PLN, EUR, USD, GBP
- [ ] Selected currency is displayed with proper symbol
- [ ] Amounts are formatted according to device locale
- [ ] Currency is saved with transaction
- [ ] Currency picker works in both light and dark themes
- [ ] Widget tests cover currency picker functionality
- [ ] All tests pass (`flutter test`)
- [ ] Code passes analysis (`flutter analyze`)
