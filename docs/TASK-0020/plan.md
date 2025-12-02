# Implementation Plan: TASK-0020 - Create Main Screen Layout

## Task Description
Build main screen with two tabs: "My Debts" and "My Loans"

## Current State Analysis
- Project has basic Flutter setup with navigation (go_router), theming, and localization
- Transaction model and repository are implemented
- Transaction form screen exists for creating/editing transactions
- Main screen layout with tabs does not exist yet

## Implementation Steps

### 1. Create Main Screen Widget
**File:** `lib/presentation/screens/main_screen.dart`

Create a new stateful widget that will serve as the main entry point of the app:
- Use `DefaultTabController` to manage two tabs
- Implement `Scaffold` with `AppBar` containing `TabBar`
- Add `TabBarView` with two tabs: "My Debts" and "My Loans"

### 2. Create Placeholder Widgets for Tab Content
**Files:**
- `lib/presentation/widgets/debts_list.dart`
- `lib/presentation/widgets/loans_list.dart`

Create placeholder widgets for each tab that will display:
- Empty state initially (will be implemented in TASK-0021)
- Basic layout structure ready for transaction list integration

### 3. Add Localization Strings
**Files:**
- `lib/l10n/app_en.arb`
- `lib/l10n/app_pl.arb`

Add translation keys:
- `myDebts`: "My Debts" / "Moje długi"
- `myLoans`: "Moje pożyczki" / "My Loans"
- `appTitle`: "Debts and Loans" / "Długi i pożyczki"

### 4. Update Router Configuration
**File:** `lib/core/router/app_router.dart`

- Set main screen as the default route (`/`)
- Ensure navigation from transaction form back to main screen works correctly

### 5. Implement Theme Styling
Apply consistent theming:
- Use theme colors for tab indicators
- Apply proper spacing and typography
- Ensure both light and dark mode support

### 6. Add Floating Action Button (Preparation for TASK-0024)
While TASK-0024 specifically covers the FAB, we should include it in the main screen structure:
- Add FAB to `Scaffold`
- Position it appropriately
- Connect it to navigation (navigate to transaction form)
- Make it context-aware (add debt when on "My Debts" tab, add loan when on "My Loans" tab)

## Technical Considerations

### Tab Management
- Use `DefaultTabController` for simplicity
- Store current tab index to pass correct transaction type to form
- Preserve tab state across navigation

### State Management
- Use `StatefulWidget` to track current tab
- Prepare structure for future integration with transaction repository

### Responsive Design
- Ensure tabs work on different screen sizes
- Consider horizontal scroll for tab labels if needed
- Apply proper padding and safe area handling

### Accessibility
- Add semantic labels for tabs
- Ensure proper contrast for tab indicators
- Support screen readers

## Files to Create
1. `lib/presentation/screens/main_screen.dart` - Main screen with tabs
2. `lib/presentation/widgets/debts_list.dart` - Debts tab content widget
3. `lib/presentation/widgets/loans_list.dart` - Loans tab content widget

## Files to Modify
1. `lib/core/router/app_router.dart` - Update routing
2. `lib/l10n/app_en.arb` - Add English translations
3. `lib/l10n/app_pl.arb` - Add Polish translations

## Dependencies
No new dependencies required. Using existing:
- `go_router` for navigation
- `flutter_localizations` for i18n

## Testing Strategy
1. **Widget Tests:**
   - Test main screen renders with two tabs
   - Test tab switching functionality
   - Test FAB visibility and tap behavior
   - Test localization strings display correctly

2. **Integration Tests:**
   - Test navigation from main screen to transaction form
   - Test navigation back from form to main screen
   - Test tab state preservation

3. **Visual Tests:**
   - Golden tests for light and dark mode
   - Golden tests for both tabs

## Success Criteria
- [ ] Main screen displays with "My Debts" and "My Loans" tabs
- [ ] Tabs are switchable and maintain state
- [ ] Localization works for both English and Polish
- [ ] Theme styling is consistent with app design
- [ ] FAB is present and functional
- [ ] Navigation to/from transaction form works
- [ ] Tests pass (`flutter test`)
- [ ] No analysis issues (`flutter analyze`)
- [ ] Code is formatted (`dart format .`)

## Notes
- This task lays the foundation for TASK-0021 (Transaction List Widget) and TASK-0024 (FAB for Adding)
- The actual transaction list implementation will be handled in subsequent tasks
- Focus on structure and navigation flow in this task
