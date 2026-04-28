# TASK-0006: Setup Navigation - Implementation Plan

## Task Overview
Implement routing solution using `go_router` package for navigation between screens in the Depts and Loans Register app.

## Prerequisites
- Flutter project is already initialized (TASK-0001 ✓)
- Development environment is configured (TASK-0002 ✓)
- Localization is configured (TASK-0005 ✓)

## Implementation Steps

### 1. Add go_router Dependency
- Add `go_router` package to `pubspec.yaml` using `flutter pub add go_router`
- Run `flutter pub get` to fetch the dependency

### 2. Define Route Structure
Based on the backlog requirements, we need routes for:
- **Main Screen** (`/`) - Home screen with two tabs: "My Debts" and "My Loans"
- **Transaction Form Screen** (`/transaction/new` and `/transaction/:id/edit`) - For adding/editing transactions
- **Transaction Details Screen** (`/transaction/:id`) - For viewing full transaction details
- **Archive View** - Will be part of main screen (collapsible section)

### 3. Create Router Configuration
Create a centralized router configuration file:
- Location: `lib/core/router/app_router.dart`
- Define all application routes
- Configure route parameters (transaction ID for details/edit)
- Set up initial route (`/`)

### 4. Implement Route Guards (Future Enhancement)
While not required for MVP, prepare structure for:
- Authentication redirects (if needed in future)
- Route validation

### 5. Integrate Router with MaterialApp
- Update `lib/main.dart` to use `MaterialApp.router`
- Pass the configured `GoRouter` instance to `routerConfig`
- Ensure compatibility with existing localization setup

### 6. Create Placeholder Screens
Create minimal placeholder widgets for navigation testing:
- `lib/presentation/screens/home_screen.dart` - Main screen placeholder
- `lib/presentation/screens/transaction_form_screen.dart` - Form screen placeholder
- `lib/presentation/screens/transaction_details_screen.dart` - Details screen placeholder

### 7. Implement Navigation Helpers
- Use `context.go()` for declarative navigation
- Use `context.push()` for imperative navigation (stacking)
- Use `context.pop()` for going back
- Handle path parameters extraction

### 8. Test Navigation Flow
- Verify navigation between all defined routes
- Test deep linking support
- Verify browser back/forward buttons work (web)
- Test route parameter passing

## File Structure
```
lib/
├── core/
│   └── router/
│       └── app_router.dart          # Router configuration
├── presentation/
│   └── screens/
│       ├── home_screen.dart         # Main screen (placeholder)
│       ├── transaction_form_screen.dart    # Form (placeholder)
│       └── transaction_details_screen.dart # Details (placeholder)
└── main.dart                        # Updated to use router
```

## Code Examples

### Router Configuration (app_router.dart)
```dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/transaction/new',
      name: 'transaction-new',
      builder: (context, state) => const TransactionFormScreen(),
    ),
    GoRoute(
      path: '/transaction/:id',
      name: 'transaction-details',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TransactionDetailsScreen(transactionId: id);
      },
    ),
    GoRoute(
      path: '/transaction/:id/edit',
      name: 'transaction-edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TransactionFormScreen(transactionId: id);
      },
    ),
  ],
);
```

### MaterialApp Integration (main.dart)
```dart
MaterialApp.router(
  routerConfig: appRouter,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ... theme configuration
)
```

## Testing Checklist
- [ ] go_router package is added to dependencies
- [ ] Router configuration is created with all routes
- [ ] MaterialApp.router is configured in main.dart
- [ ] Placeholder screens are created
- [ ] Navigation to home screen works
- [ ] Navigation to transaction form works
- [ ] Navigation to transaction details works (with ID parameter)
- [ ] Navigation to edit transaction works (with ID parameter)
- [ ] Back navigation works correctly
- [ ] Deep linking is functional
- [ ] No navigation-related errors in console

## Success Criteria
- ✅ go_router package is integrated
- ✅ All main routes are defined and functional
- ✅ Navigation between screens works smoothly
- ✅ Route parameters are correctly passed and extracted
- ✅ App builds without errors
- ✅ Navigation is ready for future feature implementation

## Dependencies
- `go_router` - Latest stable version from pub.dev

## Estimated Complexity
**Low-Medium** - Standard navigation setup with multiple routes and parameters.

## Notes
- This task focuses on setting up the navigation infrastructure
- Actual screen implementations will be done in subsequent tasks (TASK-0014, TASK-0020, TASK-0025)
- The router configuration should be extensible for future routes
- Consider web support - go_router handles deep linking and browser navigation automatically
