# TASK-0005: Configure Localization

## Task Description
Set up i18n support for Polish (PL) and English (EN) with automatic locale detection

## Implementation Plan

### 1. Add Required Dependencies
Add Flutter's internationalization packages to `pubspec.yaml`:
- `flutter_localizations` (SDK dependency)
- `intl` (for message formatting and date/number formatting)

### 2. Enable Code Generation
Update `pubspec.yaml` to enable ARB file generation:
- Set `generate: true` in the flutter section
- Create `l10n.yaml` configuration file at project root

### 3. Configure l10n.yaml
Create configuration file specifying:
- ARB directory path (`lib/l10n`)
- Template ARB file (`app_en.arb`)
- Output localization file name
- Nullable getter option
- Supported locales (en, pl)

### 4. Create Translation Files
Create ARB (Application Resource Bundle) files:
- `lib/l10n/app_en.arb` - English translations (template)
- `lib/l10n/app_pl.arb` - Polish translations

Initial strings to include:
- App title
- Common UI labels (save, cancel, delete, edit, etc.)
- Tab names (My Debts, My Loans)
- Field labels (Name, Amount, Currency, Description, Due Date)
- Validation messages
- Empty state messages

### 5. Run Code Generation
Execute `flutter gen-l10n` to generate localization classes:
- This creates `AppLocalizations` class
- Generates delegate classes for MaterialApp
- Creates locale-specific message lookups

### 6. Update MaterialApp Configuration
Modify `lib/main.dart` to:
- Import generated localization files
- Add `localizationsDelegates` property with:
  - `AppLocalizations.delegate`
  - `GlobalMaterialLocalizations.delegate`
  - `GlobalWidgetsLocalizations.delegate`
  - `GlobalCupertinoLocalizations.delegate`
- Add `supportedLocales` property with en and pl locales
- Set `localeResolutionCallback` for automatic locale detection

### 7. Implement Locale Detection Logic
Configure locale resolution to:
- Check device locale first
- Fall back to English if device locale is not supported
- Handle null locale cases gracefully

### 8. Create Usage Examples
Document how to access translations in code:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)
```

### 9. Testing
Verify localization works by:
- Testing on device with Polish locale
- Testing on device with English locale
- Testing on device with unsupported locale (should default to English)
- Verifying all strings display correctly in both languages

### 10. Documentation
Update project documentation:
- Add instructions for adding new translations
- Document ARB file structure
- Explain how to use translations in widgets

## Files to Create/Modify

### New Files
- `l10n.yaml` - Localization configuration
- `lib/l10n/app_en.arb` - English translations
- `lib/l10n/app_pl.arb` - Polish translations

### Modified Files
- `pubspec.yaml` - Add dependencies and enable generation
- `lib/main.dart` - Configure MaterialApp with localization support

## Dependencies
- `flutter_localizations` (SDK: flutter)
- `intl` (pub.dev package)

## Success Criteria
- [ ] App displays in Polish when device locale is pl
- [ ] App displays in English when device locale is en or unsupported
- [ ] All UI strings are localized (no hardcoded strings)
- [ ] Date and number formatting follows locale conventions
- [ ] Code generation completes without errors
- [ ] No hardcoded strings remain in UI code

## Notes
- Follow Flutter's official internationalization guide
- Use descriptive keys in ARB files (e.g., `appTitle`, `saveButton`)
- Include placeholders for dynamic content where needed
- Ensure ARB files are valid JSON
- Generated files should not be committed to version control
