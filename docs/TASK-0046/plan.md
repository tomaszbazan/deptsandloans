# TASK-0046: Implement Dark Mode Support

## Task Description
Apply dark theme based on device system settings using ThemeMode.system

## Current State Analysis

### Already Implemented
1. **Dark Theme Defined** (`lib/core/theme/app_theme.dart:32-55`)
   - `AppTheme.darkTheme()` method exists with full dark color scheme
   - Uses `darkColorScheme` from `color_schemes.dart`
   - All component themes are properly configured for dark mode

2. **Light Theme Defined** (`lib/core/theme/app_theme.dart:7-30`)
   - `AppTheme.lightTheme()` method exists with light color scheme
   - Uses `lightColorScheme` from `color_schemes.dart`
   - Consistent component themes structure

3. **ThemeMode.system Already Set** (`lib/main.dart:133`)
   - MaterialApp.router already uses `themeMode: ThemeMode.system`
   - Both `theme` and `darkTheme` are configured
   - App should already respond to system theme changes

### Current Implementation Status
**The dark mode support is ALREADY IMPLEMENTED** at the code level:
- Line 131-133 in `lib/main.dart` shows:
  ```dart
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: ThemeMode.system,
  ```

## Implementation Plan

Since the dark mode is already implemented in code, the task requires:

### 1. Verification Testing
**Goal:** Verify that dark mode works correctly across the entire app

**Steps:**
1. Manual testing on Android device/emulator:
   - Change system theme to light mode → verify app uses light theme
   - Change system theme to dark mode → verify app uses dark theme
   - Verify smooth transition between themes

2. Test all screens in both themes:
   - Main screen (My Debts / My Loans tabs)
   - Transaction form screen (add/edit)
   - Transaction details screen
   - Repayment form
   - Archive section
   - Dialogs (delete confirmation, etc.)

3. Verify visual elements in dark mode:
   - Color contrast and readability
   - Overdue transaction highlighting (red) is visible
   - Progress bars are clearly visible
   - Icons are properly colored
   - Card shadows/elevations work well

### 2. Golden Tests for Dark Theme
**Goal:** Add visual regression tests for dark theme

**Steps:**
1. Create dark theme golden tests for key screens:
   - Transaction form screen (dark mode variant)
   - Transaction details screen (dark mode variant)
   - Main screen with transactions list (dark mode variant)
   - Archive section (dark mode variant)

2. Update existing golden test files or create new ones:
   - `test/golden/screens/transaction_form_screen_test.dart`
   - `test/golden/screens/transaction_details_screen_test.dart`
   - Add new: `test/golden/screens/main_screen_dark_test.dart`

3. Test structure for each screen:
   ```dart
   testWidgets('Screen renders correctly in dark mode', (tester) async {
     await tester.pumpWidget(
       AppFixture.createDefaultApp(
         ScreenWidget(),
         theme: AppTheme.darkTheme(),
       ),
     );

     await expectLater(
       find.byType(ScreenWidget),
       matchesGoldenFile('goldens/screen_dark.png'),
     );
   });
   ```

### 3. Update AppFixture for Dark Theme Testing
**Goal:** Ensure test fixtures support dark theme

**Steps:**
1. Verify `test/fixtures/app_fixture.dart` supports theme parameter
   - Already has `theme` parameter in `createDefaultApp` ✓
   - Can pass `AppTheme.darkTheme()` for dark mode tests ✓

2. Add dark theme variant for router tests if needed:
   - Add optional `ThemeData? darkTheme` parameter to `createDefaultRouter`
   - Add optional `ThemeMode themeMode` parameter

### 4. Documentation
**Goal:** Document dark mode behavior

**Steps:**
1. Update README (if exists) with dark mode information
2. Add comment in `app_theme.dart` explaining the theme system
3. Document for users:
   - Dark mode follows system settings
   - No manual toggle required (as per PRD - system-based only)

### 5. Quality Assurance
**Goal:** Ensure all tests pass and code is properly formatted

**Steps:**
1. Run all tests: `flutter test`
2. Run analyzer: `flutter analyze`
3. Format code: `dart format .`
4. Generate new golden files for dark mode tests
5. Verify golden files visually

## Files to Modify

1. **Test Files to Create/Update:**
   - `test/golden/screens/transaction_form_screen_test.dart` - add dark mode variant
   - `test/golden/screens/transaction_details_screen_test.dart` - add dark mode variant
   - `test/golden/screens/main_screen_dark_test.dart` - create new
   - `test/golden/widgets/repayment_form_test.dart` - add dark mode variant
   - `test/golden/widgets/delete_transaction_dialog_test.dart` - add dark mode variant

2. **Test Fixture to Update (optional):**
   - `test/fixtures/app_fixture.dart` - add dark theme support to router

3. **Documentation (optional):**
   - `lib/core/theme/app_theme.dart` - add documentation comments

## Success Criteria

1. ✅ App responds to system theme changes automatically
2. ✅ All screens render correctly in dark mode
3. ✅ Dark mode golden tests pass
4. ✅ All existing tests continue to pass
5. ✅ Code passes `flutter analyze` with no warnings
6. ✅ Code is properly formatted with `dart format`
7. ✅ Visual elements maintain good contrast and readability in dark mode

## Notes

- The core implementation is already complete in the codebase
- This task focuses on **testing and verification** rather than implementation
- No user-facing toggle needed (system-based only per PRD)
- Dark mode is part of Material 3 design system which is already enabled
- Priority is ensuring visual quality and test coverage

## Estimated Complexity
**Low** - Implementation exists, mainly testing and verification work needed
