# TASK-0032: Implement Archive Section

## Overview
Create a collapsible accordion section for completed transactions that appears below the active transaction list on both "My Debts" and "My Loans" tabs.

## Current State Analysis
- Transaction listing exists with active transactions displayed
- Transactions can be marked as completed (manually or automatically)
- Need to separate completed transactions from active ones visually
- Need collapsible UI component for archive section

## Implementation Plan

### 1. Update Transaction List Widget
**File:** `lib/presentation/screens/main_screen.dart` or transaction list widget

**Changes:**
- Modify transaction list query to separate active and completed transactions
- Filter transactions by status (active vs completed)
- Create two separate lists: active and archived

### 2. Create Archive Section Component
**File:** `lib/presentation/widgets/archive_section.dart`

**Implementation:**
- Create a new widget `ArchiveSection` that wraps completed transactions
- Use `ExpansionTile` or `ExpansionPanelList` for accordion functionality
- Header should display:
  - "Archive" label (localized)
  - Count of completed transactions (e.g., "Archive (5)")
  - Expand/collapse icon
- Content should display completed transactions in read-only format
- Initial state: collapsed

**Widget Structure:**
```dart
class ArchiveSection extends StatelessWidget {
  final List<Transaction> completedTransactions;

  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Archive (${completedTransactions.length})'),
      initiallyExpanded: false,
      children: [
        // List of completed transactions
      ],
    );
  }
}
```

### 3. Integrate Archive Section into Main Screen
**File:** `lib/presentation/screens/main_screen.dart`

**Changes:**
- Add `ArchiveSection` widget below active transaction list
- Pass completed transactions to the archive section
- Ensure proper spacing between active list and archive
- Handle empty archive state (hide section if no completed transactions)

### 4. Update Transaction List Query
**File:** Repository or data layer files

**Changes:**
- Ensure transactions can be queried by status
- Separate queries or filtering for active vs completed transactions
- Order completed transactions by completion date (most recent first)

### 5. Styling and UX
**Considerations:**
- Archive section should be visually distinct from active list
- Use subtle background color or border to separate sections
- Completed transactions should appear with reduced opacity or different styling
- Maintain consistent design with existing transaction list items
- Ensure smooth expand/collapse animation

### 6. State Management
**Approach:**
- Expansion state managed locally by `ExpansionTile` (built-in)
- No need to persist expansion state (always collapsed on launch per requirements)
- Transaction data fetched from repository as usual

## Testing Strategy

### Unit Tests
- Test transaction filtering logic (active vs completed)
- Test completed transaction count calculation

### Widget Tests
- Test `ArchiveSection` widget renders correctly
- Test initial collapsed state
- Test expand/collapse functionality
- Test proper transaction count display
- Test empty state (no completed transactions)

### Integration Tests
- Verify completed transactions appear in archive
- Verify active transactions do not appear in archive
- Test navigation and interaction with archived transactions

### Golden Tests
- Create golden test for archive section collapsed state
- Create golden test for archive section expanded state
- Test both empty and populated archive states

## Dependencies
No new dependencies required - using Flutter's built-in `ExpansionTile` widget.

## Files to Create/Modify

### New Files:
- `lib/presentation/widgets/archive_section.dart`
- `test/presentation/widgets/archive_section_test.dart`
- `test/golden/archive_section_test.dart`

### Modified Files:
- `lib/presentation/screens/main_screen.dart` (integrate archive section)
- Existing transaction list widget (add filtering logic)

## Acceptance Criteria
- [ ] Archive section appears below active transaction list
- [ ] Archive section is collapsed by default on app launch
- [ ] Archive section displays count of completed transactions
- [ ] Clicking archive header expands/collapses the section
- [ ] Completed transactions are displayed in read-only format
- [ ] Archive section hidden when no completed transactions exist
- [ ] Smooth expand/collapse animation
- [ ] Consistent styling with app theme
- [ ] All tests pass (unit, widget, golden, integration)
- [ ] Code passes `flutter analyze`
- [ ] Code formatted with `dart format`

## Implementation Order
1. Create `ArchiveSection` widget with basic structure
2. Implement transaction filtering logic (active vs completed)
3. Integrate archive section into main screen
4. Add styling and polish
5. Write tests (unit, widget, golden)
6. Run analysis and format code
7. Verify all acceptance criteria met
