# Implementation Plan: TASK-0034 - Implement Archive Toggle

## Task Description
Add functionality to expand/collapse Archive section by clicking header

## Current State Analysis
Based on TASK-0032 and TASK-0033 completion:
- Archive section (collapsible accordion) has been implemented
- Archive section is already collapsed by default on app launch
- Need to add interactive toggle functionality to the header

## Files to Investigate
1. Transaction list widget files (likely in `lib/` directory)
2. Archive section implementation
3. State management for collapse/expand state

## Implementation Steps

### Step 1: Locate Archive Section Implementation
- Find the widget/screen that displays the Archive section
- Identify the current header implementation
- Review how the collapsed state is currently managed

### Step 2: Implement Toggle State Management
- Add a boolean state variable to track expanded/collapsed state
- Initialize it to `false` (collapsed) to maintain TASK-0033 requirement
- Use appropriate state management (ValueNotifier, State, or existing solution)

### Step 3: Make Header Interactive
- Wrap the Archive section header in an `InkWell` or `GestureDetector`
- Add `onTap` callback to toggle the expanded/collapsed state
- Add visual feedback (ripple effect, pointer cursor on web)

### Step 4: Add Visual Indicators
- Add an icon (chevron/arrow) to indicate expandable state
- Rotate icon based on expanded/collapsed state
- Consider using `AnimatedRotation` or `RotationTransition` for smooth animation

### Step 5: Implement Expand/Collapse Animation
- Use `AnimatedSize`, `ExpansionTile`, or custom animation
- Ensure smooth transition when toggling
- Consider using `Curves.easeInOut` for natural feel

### Step 6: Persist State (Optional Enhancement)
- Consider if toggle state should persist across app restarts
- If yes, use SharedPreferences or similar local storage
- If no, state resets to collapsed on each launch (per TASK-0033)

## Technical Considerations

### Widget Choice
- If using `ExpansionTile`: Built-in support for expand/collapse
- If using custom implementation: More control over appearance

### Accessibility
- Ensure proper semantics for screen readers
- Add semantic label indicating expandable/collapsible nature
- Announce state changes to accessibility services

### Performance
- Use `const` constructors where possible
- Avoid rebuilding entire list when toggling
- Consider using `AnimatedBuilder` for efficient animations

## Testing Strategy

### Widget Tests
1. Test initial collapsed state
2. Test toggle functionality (tap header -> expands)
3. Test toggle back (tap again -> collapses)
4. Test visual indicator rotation

### Golden Tests
1. Capture collapsed state appearance
2. Capture expanded state appearance
3. Capture header with visual indicators

### Integration Tests
1. Test user flow: open app -> tap archive header -> verify expansion
2. Test multiple toggles in succession
3. Verify completed transactions remain visible when expanded

## Definition of Done
- [ ] Archive header is clickable/tappable
- [ ] Clicking header toggles between expanded and collapsed states
- [ ] Visual indicator (icon) shows current state
- [ ] Smooth animation during state transition
- [ ] Archive section remains collapsed on app launch (TASK-0033)
- [ ] Widget tests written and passing
- [ ] Golden tests created
- [ ] Code passes `flutter analyze`
- [ ] Code formatted with `dart format .`

## Risk Assessment
- **Low Risk**: Standard Flutter pattern, well-documented
- **Dependency**: Relies on TASK-0032 and TASK-0033 completion
- **Edge Cases**: Rapid toggling should not cause visual glitches

## Estimated Complexity
**Low-Medium**: Straightforward implementation using standard Flutter widgets and patterns
