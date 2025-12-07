# Implementation Plan: TASK-0042 - Create Translation Files

## Task Description
Create ARB files for Polish and English translations of all UI strings.

## Current Status

### Infrastructure (Already Complete)
- ✅ `l10n.yaml` configuration file exists
- ✅ `flutter_localizations` and `intl` dependencies added
- ✅ `flutter: generate: true` enabled in pubspec.yaml
- ✅ `lib/l10n/app_en.arb` exists with 70+ translation keys
- ✅ `lib/l10n/app_pl.arb` exists with Polish translations
- ✅ Main app configured with localization delegates and supported locales

### Issues Identified
1. **Incomplete Polish ARB structure** - Missing metadata descriptions for translation keys
2. **19+ hardcoded strings** found across multiple widget files that bypass localization
3. **Dialog content** in transaction_details_screen.dart uses hardcoded English text

## Implementation Steps

### Step 1: Audit and Document Missing Strings
**Goal:** Create a complete list of all hardcoded strings that need translation keys.

**Files to examine:**
- `lib/presentation/widgets/debts_list.dart`
- `lib/presentation/widgets/loans_list.dart`
- `lib/presentation/screens/transaction_details_screen.dart`
- `lib/presentation/widgets/transaction_details/transaction_info_section.dart`
- `lib/presentation/widgets/transaction_details/progress_section.dart`
- `lib/presentation/widgets/repayment_form.dart`

**Hardcoded strings found:**
1. `'All debts completed!'` (debts_list.dart:62)
2. `'Check archive below'` (debts_list.dart:64)
3. `'All loans completed!'` (loans_list.dart:62)
4. `'Check archive below'` (loans_list.dart:64)
5. `'Delete Transaction?'` (transaction_details_screen.dart:81)
6. `'This action cannot be undone...'` (transaction_details_screen.dart:86)
7. `'Transaction deleted successfully'` (transaction_details_screen.dart:112)
8. `'Failed to delete transaction: $e'` (transaction_details_screen.dart:117)
9. `'Transaction Details'` (transaction_details_screen.dart:170)
10. `'Transaction not found'` (transaction_details_screen.dart:223)
11. `'The requested transaction could not be loaded.'` (transaction_details_screen.dart:225)
12. `'Go Back'` (transaction_details_screen.dart:227)
13. `'Debt'` (transaction_info_section.dart:27)
14. `'Loan'` (transaction_info_section.dart:27)
15. `'Overdue'` (transaction_info_section.dart:34)
16. `'Original Amount'` (transaction_info_section.dart:43)
17. `'Remaining Balance'` (transaction_info_section.dart:47)
18. `'Description'` (transaction_info_section.dart:64)
19. `'Due Date'` (transaction_info_section.dart:77)
20. `'Status'` (transaction_info_section.dart:84)
21. `'Completed'` (transaction_info_section.dart:85)
22. `'Active'` (transaction_info_section.dart:85)
23. `'Repayment Progress'` (progress_section.dart:28)
24. `'Paid'` (progress_section.dart:52)
25. `'Remaining'` (progress_section.dart:54)
26. `'Failed to add repayment'` (repayment_form.dart:76)

### Step 2: Update app_en.arb (English Template)
**Goal:** Add all missing translation keys with proper metadata.

**New keys to add:**
```json
{
  "allDebtsCompleted": "All debts completed!",
  "@allDebtsCompleted": {
    "description": "Message shown when all debts are completed"
  },
  "allLoansCompleted": "All loans completed!",
  "@allLoansCompleted": {
    "description": "Message shown when all loans are completed"
  },
  "checkArchiveBelow": "Check archive below",
  "@checkArchiveBelow": {
    "description": "Hint to check the archive section below"
  },
  "deleteTransactionTitle": "Delete Transaction?",
  "@deleteTransactionTitle": {
    "description": "Title for delete transaction confirmation dialog"
  },
  "deleteTransactionMessage": "This action cannot be undone. The transaction and all associated repayments will be permanently deleted.",
  "@deleteTransactionMessage": {
    "description": "Warning message in delete confirmation dialog"
  },
  "transactionDeletedSuccessfully": "Transaction deleted successfully",
  "@transactionDeletedSuccessfully": {
    "description": "Success message after deleting a transaction"
  },
  "failedToDeleteTransaction": "Failed to delete transaction: {error}",
  "@failedToDeleteTransaction": {
    "description": "Error message when transaction deletion fails",
    "placeholders": {
      "error": {
        "type": "String",
        "example": "Network error"
      }
    }
  },
  "transactionDetails": "Transaction Details",
  "@transactionDetails": {
    "description": "Title for transaction details screen"
  },
  "transactionNotFound": "Transaction not found",
  "@transactionNotFound": {
    "description": "Error message when transaction cannot be found"
  },
  "transactionNotFoundMessage": "The requested transaction could not be loaded.",
  "@transactionNotFoundMessage": {
    "description": "Detailed error message for missing transaction"
  },
  "goBack": "Go Back",
  "@goBack": {
    "description": "Button label to navigate back"
  },
  "debt": "Debt",
  "@debt": {
    "description": "Label for debt transaction type"
  },
  "loan": "Loan",
  "@loan": {
    "description": "Label for loan transaction type"
  },
  "originalAmount": "Original Amount",
  "@originalAmount": {
    "description": "Label for the original transaction amount"
  },
  "remainingBalance": "Remaining Balance",
  "@remainingBalance": {
    "description": "Label for the remaining balance to be paid"
  },
  "dueDate": "Due Date",
  "@dueDate": {
    "description": "Label for transaction due date"
  },
  "status": "Status",
  "@status": {
    "description": "Label for transaction status"
  },
  "active": "Active",
  "@active": {
    "description": "Status label for active transactions"
  },
  "repaymentProgress": "Repayment Progress",
  "@repaymentProgress": {
    "description": "Title for repayment progress section"
  },
  "paid": "Paid",
  "@paid": {
    "description": "Label for amount already paid"
  },
  "remaining": "Remaining",
  "@remaining": {
    "description": "Label for amount remaining to be paid"
  },
  "failedToAddRepayment": "Failed to add repayment",
  "@failedToAddRepayment": {
    "description": "Error message when repayment cannot be added"
  }
}
```

**Action items:**
1. Open `lib/l10n/app_en.arb`
2. Add all 26 new translation keys with metadata
3. Ensure proper JSON formatting and alphabetical ordering (optional but recommended)
4. Verify all placeholders are correctly defined

### Step 3: Update app_pl.arb (Polish Translations)
**Goal:** Add Polish translations for all keys and complete metadata structure.

**New keys to add (Polish translations):**
```json
{
  "@locale": "pl",
  "allDebtsCompleted": "Wszystkie długi spłacone!",
  "@allDebtsCompleted": {
    "description": "Komunikat wyświetlany gdy wszystkie długi są spłacone"
  },
  "allLoansCompleted": "Wszystkie pożyczki spłacone!",
  "@allLoansCompleted": {
    "description": "Komunikat wyświetlany gdy wszystkie pożyczki są spłacone"
  },
  "checkArchiveBelow": "Sprawdź archiwum poniżej",
  "@checkArchiveBelow": {
    "description": "Wskazówka do sprawdzenia sekcji archiwum poniżej"
  },
  "deleteTransactionTitle": "Usunąć transakcję?",
  "@deleteTransactionTitle": {
    "description": "Tytuł okna potwierdzenia usunięcia transakcji"
  },
  "deleteTransactionMessage": "Ta operacja jest nieodwracalna. Transakcja i wszystkie powiązane spłaty zostaną trwale usunięte.",
  "@deleteTransactionMessage": {
    "description": "Komunikat ostrzegawczy w oknie potwierdzenia usunięcia"
  },
  "transactionDeletedSuccessfully": "Transakcja usunięta pomyślnie",
  "@transactionDeletedSuccessfully": {
    "description": "Komunikat sukcesu po usunięciu transakcji"
  },
  "failedToDeleteTransaction": "Nie udało się usunąć transakcji: {error}",
  "@failedToDeleteTransaction": {
    "description": "Komunikat błędu gdy usunięcie transakcji nie powiodło się",
    "placeholders": {
      "error": {
        "type": "String",
        "example": "Błąd sieci"
      }
    }
  },
  "transactionDetails": "Szczegóły transakcji",
  "@transactionDetails": {
    "description": "Tytuł ekranu szczegółów transakcji"
  },
  "transactionNotFound": "Nie znaleziono transakcji",
  "@transactionNotFound": {
    "description": "Komunikat błędu gdy nie można znaleźć transakcji"
  },
  "transactionNotFoundMessage": "Żądana transakcja nie mogła zostać wczytana.",
  "@transactionNotFoundMessage": {
    "description": "Szczegółowy komunikat błędu dla brakującej transakcji"
  },
  "goBack": "Wróć",
  "@goBack": {
    "description": "Etykieta przycisku powrotu"
  },
  "debt": "Dług",
  "@debt": {
    "description": "Etykieta dla typu transakcji dług"
  },
  "loan": "Pożyczka",
  "@loan": {
    "description": "Etykieta dla typu transakcji pożyczka"
  },
  "originalAmount": "Kwota początkowa",
  "@originalAmount": {
    "description": "Etykieta dla początkowej kwoty transakcji"
  },
  "remainingBalance": "Pozostała kwota",
  "@remainingBalance": {
    "description": "Etykieta dla pozostałej kwoty do spłaty"
  },
  "dueDate": "Termin płatności",
  "@dueDate": {
    "description": "Etykieta dla terminu płatności transakcji"
  },
  "status": "Status",
  "@status": {
    "description": "Etykieta dla statusu transakcji"
  },
  "active": "Aktywna",
  "@active": {
    "description": "Etykieta statusu dla aktywnych transakcji"
  },
  "repaymentProgress": "Postęp spłaty",
  "@repaymentProgress": {
    "description": "Tytuł sekcji postępu spłaty"
  },
  "paid": "Spłacono",
  "@paid": {
    "description": "Etykieta dla już spłaconej kwoty"
  },
  "remaining": "Pozostało",
  "@remaining": {
    "description": "Etykieta dla kwoty pozostałej do spłaty"
  },
  "failedToAddRepayment": "Nie udało się dodać spłaty",
  "@failedToAddRepayment": {
    "description": "Komunikat błędu gdy nie można dodać spłaty"
  }
}
```

**Action items:**
1. Open `lib/l10n/app_pl.arb`
2. Ensure `"@locale": "pl"` is at the top of the file
3. Add all 26 new translation keys with Polish translations
4. Add metadata descriptions for all keys (matching English structure)
5. Review existing translations and add missing metadata for any existing keys
6. Verify proper Polish grammar and terminology

### Step 4: Verify ARB Files Structure
**Goal:** Ensure both ARB files are complete and properly formatted.

**Checklist:**
- [ ] Both files have valid JSON syntax
- [ ] All keys in app_en.arb exist in app_pl.arb
- [ ] All keys have corresponding metadata (@keyName entries)
- [ ] All placeholders are properly defined in both files
- [ ] app_pl.arb has `"@locale": "pl"` at the top
- [ ] Descriptions are clear and helpful
- [ ] No typos or formatting issues

**Verification command:**
```bash
dart run intl_utils:validate
```
Or manually trigger code generation:
```bash
flutter gen-l10n
```

### Step 5: Run Code Generation
**Goal:** Generate AppLocalizations class from updated ARB files.

**Commands:**
```bash
flutter gen-l10n
flutter pub get
```

**Expected output:**
- `lib/generated/intl/messages_*.dart` files updated
- `lib/generated/l10n.dart` regenerated with new getters
- No errors or warnings

### Step 6: Verification and Testing
**Goal:** Ensure localization works correctly for both languages.

**Manual verification:**
1. Check that `.arb/gen_l10n/app_localizations.dart` contains all new getters
2. Verify no compilation errors after code generation
3. Run `flutter analyze` to ensure no issues

**Test commands:**
```bash
flutter analyze
dart format . --set-exit-if-changed
```

**Expected results:**
- ✅ No analysis errors
- ✅ All new translation keys accessible via AppLocalizations
- ✅ Both English and Polish translations available
- ✅ Code properly formatted

### Step 7: Documentation
**Goal:** Document the translation system for future reference.

**Create documentation covering:**
1. How to add new translation keys
2. ARB file structure and conventions
3. Running code generation
4. Testing translations
5. Translation key naming conventions

**Document location:** `docs/TASK-0042/localization-guide.md`

## Files Modified
1. `lib/l10n/app_en.arb` - Add 26 new translation keys
2. `lib/l10n/app_pl.arb` - Add 26 new Polish translations with metadata

## Files to Review (for future tasks)
These files contain hardcoded strings and will need to be updated in subsequent tasks:
1. `lib/presentation/widgets/debts_list.dart`
2. `lib/presentation/widgets/loans_list.dart`
3. `lib/presentation/screens/transaction_details_screen.dart`
4. `lib/presentation/widgets/transaction_details/transaction_info_section.dart`
5. `lib/presentation/widgets/transaction_details/progress_section.dart`
6. `lib/presentation/widgets/repayment_form.dart`

## Success Criteria
- [x] Infrastructure already set up (l10n.yaml, dependencies, main.dart)
- [ ] `app_en.arb` contains all 70+ existing keys plus 26 new keys (total: 96+)
- [ ] `app_pl.arb` contains matching Polish translations for all keys
- [ ] All translation keys have proper metadata descriptions
- [ ] Code generation runs without errors
- [ ] `flutter analyze` passes with no issues
- [ ] Both English and Polish translations are complete and accurate

## Dependencies
- None (all dependencies already added in TASK-0005)

## Estimated Complexity
**Low-Medium** - ARB file updates are straightforward, but requires attention to detail for:
- Proper JSON formatting
- Accurate Polish translations
- Complete metadata structure
- Placeholder definitions

## Notes
- This task focuses ONLY on creating/updating ARB files
- Replacing hardcoded strings in widget files will be handled in TASK-0043 (Implement Locale Detection) or subsequent tasks
- The localization infrastructure is already functional and properly configured
- Code generation happens automatically during build, but can be triggered manually with `flutter gen-l10n`
- Follow alphabetical ordering of keys for maintainability (optional but recommended)
- Use descriptive metadata to help future translators understand context

## References
- Flutter Internationalization Guide: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
- ARB File Format: https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification
- Existing configuration: `l10n.yaml`
- Current ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_pl.arb`
