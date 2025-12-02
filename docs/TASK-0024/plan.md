# TASK-0024: Implement FAB for Adding Transactions

## Task Description
Add Floating Action Button to open transaction form for adding new debt/loan

## Current State Analysis

### Existing Components
- Transaction form screen exists (TASK-0014 completed)
- Main screen with tabs implemented (TASK-0020 completed)
- Navigation system configured with go_router (TASK-0006 completed)
- Transaction repository for saving data (TASK-0011 completed)

### Files to Investigate
- `lib/screens/main_screen.dart` - Main screen with tabs where FAB should be added
- `lib/router/app_router.dart` or similar - Router configuration
- `lib/screens/transaction_form_screen.dart` - Target screen to navigate to

## Implementation Plan

### Step 1: Locate Main Screen Implementation
- Read `lib/screens/main_screen.dart` to understand current structure
- Identify where FAB should be added in the widget tree
- Check if Scaffold is used (required for FloatingActionButton)

### Step 2: Locate Transaction Form Screen
- Find the transaction form screen implementation
- Verify the route configuration for navigation
- Determine required parameters (transaction type: debt/loan)

### Step 3: Implement FAB in Main Screen
- Add FloatingActionButton to the Scaffold
- Position it appropriately (typically bottom-right)
- Configure the button to detect current active tab (My Debts vs My Loans)
- Add appropriate icon (e.g., Icons.add)

### Step 4: Implement Navigation Logic
- Use go_router navigation to open transaction form
- Pass transaction type parameter based on active tab:
  - If "My Debts" tab is active → open form with type = 'debt'
  - If "My Loans" tab is active → open form with type = 'loan'
- Ensure proper navigation context

### Step 5: Handle Form Return
- Implement proper navigation after form submission
- Ensure transaction list refreshes when returning to main screen
- Handle back navigation correctly

### Step 6: Styling and UX
- Apply theme colors to FAB
- Add tooltip for accessibility
- Ensure FAB doesn't overlap with important content
- Consider animation/transition effects (optional)

### Step 7: Testing
- Test FAB appears correctly on both tabs
- Test navigation opens form with correct transaction type
- Test form submission and return flow
- Run widget tests for FAB interaction
- Verify with `flutter analyze` and `flutter test`

### Step 8: Code Quality
- Format code with `dart format .`
- Ensure no linting errors
- Follow project's coding standards

## Technical Considerations

### FAB Implementation Pattern
```dart
Scaffold(
  body: // existing body
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Navigate to form with type based on current tab
    },
    child: const Icon(Icons.add),
  ),
)
```

### Tab State Management
- Need to track which tab is currently active
- Use TabController or similar state management
- Pass correct transaction type to form

### Navigation with Parameters
- Use go_router with path parameters or query parameters
- Example: `/transaction/new?type=debt` or `/transaction/new/debt`

## Dependencies
- No new dependencies required
- Uses existing go_router navigation
- Uses existing Material widgets

## Success Criteria
- [ ] FAB visible on main screen
- [ ] FAB opens transaction form when tapped
- [ ] Correct transaction type passed based on active tab
- [ ] Navigation flow works smoothly
- [ ] Code passes flutter analyze
- [ ] Code passes flutter test
- [ ] Code properly formatted

## Risks and Mitigations
- **Risk**: Tab state not accessible where FAB is defined
  - **Mitigation**: Use TabController or lift state up appropriately

- **Risk**: Navigation route not properly configured
  - **Mitigation**: Verify router configuration supports required parameters

## Estimated Complexity
**Low-Medium** - Straightforward UI addition with basic navigation logic
