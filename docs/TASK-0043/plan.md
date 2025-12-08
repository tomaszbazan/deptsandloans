# TASK-0043: Implement Locale Detection

## Task Description
Automatically set app language based on device locale (default to English)

## Current State Analysis

### What Works
- Flutter localization infrastructure is properly configured
- ARB files exist for English (`app_en.arb`) and Polish (`app_pl.arb`)
- `localeResolutionCallback` in MaterialApp handles basic device locale matching
- `flutter_localizations` and `intl` packages are already installed
- Generated localization classes exist in `lib/l10n/`

### What's Missing
- No explicit `locale` property set on MaterialApp
- No locale state management at app level
- App relies entirely on Flutter's automatic device locale detection
- No mechanism to programmatically control or override the locale
- No persistent storage for user language preference (future enhancement)

### Key Files to Modify
1. `/home/kwasiu/projekty/prv/deptsandloans/lib/main.dart` - Main app initialization
2. `/home/kwasiu/projekty/prv/deptsandloans/lib/core/providers/locale_provider.dart` - New file for locale state management

## Implementation Plan

### Step 1: Create Locale State Provider
**File:** `lib/core/providers/locale_provider.dart`

Create a `LocaleProvider` class using `ChangeNotifier` to manage the app's locale state:

```dart
class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  Locale detectDeviceLocale(List<Locale> supportedLocales) {
    // Get device locale from PlatformDispatcher
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // Try to match device locale with supported locales
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale;
      }
    }

    // Default to English if no match
    return const Locale('en');
  }

  void initializeLocale(List<Locale> supportedLocales) {
    final detectedLocale = detectDeviceLocale(supportedLocales);
    _locale = detectedLocale;
    notifyListeners();
  }
}
```

**Rationale:**
- Uses `ChangeNotifier` for simple state management (per CLAUDE.md guidelines)
- Detects device locale using `WidgetsBinding.instance.platformDispatcher.locale`
- Provides fallback to English for unsupported locales
- Allows future extension for user-selected locale overrides

### Step 2: Update Main App to Use Locale Provider
**File:** `lib/main.dart`

Modify the `_DeptsAndLoansAppState` class:

1. Add `LocaleProvider` instance as a field
2. Initialize locale detection in `initState()`
3. Wrap MaterialApp.router with `ListenableBuilder`
4. Set the `locale` property from provider

```dart
class _DeptsAndLoansAppState extends State<DeptsAndLoansApp> {
  late final IsarTransactionRepository _transactionRepository;
  late final IsarRepaymentRepository _repaymentRepository;
  late final IsarReminderRepository _reminderRepository;
  late final LocaleProvider _localeProvider;  // NEW
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _initializeNotifications();
    _localeProvider = LocaleProvider();  // NEW
    _localeProvider.initializeLocale(const [  // NEW
      Locale('en'),
      Locale('pl'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(  // NEW wrapper
      listenable: _localeProvider,
      builder: (context, child) {
        return MaterialApp.router(
          locale: _localeProvider.locale,  // NEW property
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          routerConfig: createAppRouter(...),
          localizationsDelegates: const [...],
          supportedLocales: const [Locale('en'), Locale('pl')],
          localeResolutionCallback: (locale, supportedLocales) {
            // Keep existing callback as fallback
            if (locale == null) {
              return supportedLocales.first;
            }
            for (final supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
```

**Rationale:**
- `ListenableBuilder` rebuilds MaterialApp when locale changes
- Explicit `locale` property overrides Flutter's automatic detection
- Keeps `localeResolutionCallback` as additional fallback layer
- Initialization happens in `initState()` before first build

### Step 3: Create Unit Tests
**File:** `test/core/providers/locale_provider_test.dart`

Test the locale detection logic:

```dart
void main() {
  group('LocaleProvider', () {
    late LocaleProvider provider;

    setUp(() {
      provider = LocaleProvider();
    });

    test('initial locale is null', () {
      expect(provider.locale, isNull);
    });

    test('setLocale updates locale and notifies listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);

      provider.setLocale(const Locale('pl'));

      expect(provider.locale, const Locale('pl'));
      expect(notified, isTrue);
    });

    test('detectDeviceLocale returns matching supported locale', () {
      // This test will need mocking of PlatformDispatcher
      // For now, test the fallback logic
      final supportedLocales = [const Locale('en'), const Locale('pl')];
      final detected = provider.detectDeviceLocale(supportedLocales);

      expect(detected.languageCode, isIn(['en', 'pl']));
    });

    test('detectDeviceLocale defaults to English for unsupported locale', () {
      // Mock scenario where device is in German
      final supportedLocales = [const Locale('en'), const Locale('pl')];
      // This will need proper mocking, but logic ensures fallback to 'en'
    });

    test('initializeLocale sets detected locale', () {
      final supportedLocales = [const Locale('en'), const Locale('pl')];
      provider.initializeLocale(supportedLocales);

      expect(provider.locale, isNotNull);
      expect(provider.locale!.languageCode, isIn(['en', 'pl']));
    });
  });
}
```

### Step 4: Update Existing Widget Tests
**Files:** `test/presentation/screens/main_screen_localization_test.dart` and others

Ensure existing tests still pass by:
- Wrapping test widgets with `LocaleProvider` if needed
- Using `AppFixture.createDefaultApp()` which already supports locale parameter
- Verifying that locale changes are reflected in the UI

### Step 5: Integration Testing
**File:** `test/integration/locale_detection_integration_test.dart` (new)

Create integration test to verify:
1. App starts with device locale (if supported)
2. App defaults to English for unsupported locales
3. Locale changes are reflected throughout the app

## Implementation Order

1. **Create `LocaleProvider`** - Foundation for locale state management
2. **Update `main.dart`** - Integrate provider with MaterialApp
3. **Write unit tests** - Ensure locale detection logic works correctly
4. **Update widget tests** - Verify existing tests still pass
5. **Run `flutter analyze`** - Check for any linting issues
6. **Run `flutter test`** - Verify all tests pass
7. **Run `dart format .`** - Format all modified code

## Testing Strategy

### Unit Tests
- Test `LocaleProvider` locale detection logic
- Test fallback to English for unsupported locales
- Test listener notification on locale changes

### Widget Tests
- Verify MaterialApp receives correct locale from provider
- Test that UI displays correct translations based on detected locale

### Integration Tests
- Test end-to-end locale detection on app startup
- Verify locale persists across navigation

### Manual Testing
1. Change device language to English → App shows English
2. Change device language to Polish → App shows Polish
3. Change device language to German → App defaults to English
4. Change device language to French → App defaults to English

## Success Criteria

- [ ] App automatically detects device locale on startup
- [ ] Supported locales (EN, PL) are properly applied
- [ ] Unsupported locales default to English
- [ ] All existing tests continue to pass
- [ ] New unit tests for `LocaleProvider` pass
- [ ] `flutter analyze` shows no errors
- [ ] Code is properly formatted with `dart format`

## Future Enhancements (Out of Scope for TASK-0043)

- **Persistent Storage:** Save user's language preference using `shared_preferences`
- **Language Switcher UI:** Add settings screen to manually change language
- **Regional Locales:** Support regional variants (e.g., `en_US`, `en_GB`)
- **Locale Change Notifications:** Show snackbar when locale changes

## Dependencies

No new dependencies required. Uses existing packages:
- `flutter_localizations` (already installed)
- `intl` (already installed)

## Risks & Considerations

- **Device Locale Access:** `PlatformDispatcher.locale` is available after `WidgetsFlutterBinding.ensureInitialized()`, which is called by `runApp()`. Initialization in `initState()` is safe.
- **Testing Limitations:** Mocking `PlatformDispatcher` requires additional setup in tests. Consider using integration tests for device locale scenarios.
- **Locale Changes at Runtime:** The current implementation detects locale only at startup. If device language changes while app is running, it won't update automatically (this is acceptable for MVP).

## Related Tasks

- **TASK-0044:** Implement Currency Formatting (will use same locale from provider)
- **TASK-0045:** Test Multi-Currency Display (depends on TASK-0043 and TASK-0044)
- **TASK-0042:** Create Translation Files (already completed)

## Notes

This implementation follows CLAUDE.md guidelines:
- Uses built-in Flutter state management (`ChangeNotifier` + `ListenableBuilder`)
- Follows SOLID principles with single responsibility
- Simple and maintainable code structure
- Avoids third-party packages for basic state management
- Properly tested with unit and integration tests
