# TASK-0007: Configure Theme System

## Overview
Create a comprehensive ThemeData configuration for both light and dark modes with color schemes and component themes. This will establish a consistent visual design system across the entire application.

## Implementation Steps

### 1. Create Theme Configuration Structure
- Create `lib/core/theme/` directory
- Create `app_theme.dart` file to hold theme configuration
- Define color constants and semantic color tokens

### 2. Implement Light Theme
- Generate `ColorScheme` from seed color using `ColorScheme.fromSeed`
- Define typography using `TextTheme`
- Configure component themes:
  - `AppBarTheme` - app bar styling
  - `ElevatedButtonTheme` - primary button styling
  - `TextButtonTheme` - text button styling
  - `OutlinedButtonTheme` - outlined button styling
  - `InputDecorationTheme` - form field styling
  - `CardTheme` - card styling with shadows
  - `FloatingActionButtonTheme` - FAB styling
  - `DialogTheme` - dialog styling
  - `SnackBarThemeData` - snackbar styling

### 3. Implement Dark Theme
- Generate dark `ColorScheme` from same seed color
- Mirror light theme structure with dark mode colors
- Ensure contrast and readability in dark mode
- Configure same component themes with dark variants

### 4. Apply Multi-layered Shadows
- Define custom shadow configurations for depth
- Apply to cards, buttons, and elevated surfaces
- Create subtle variations for different elevation levels

### 5. Configure Typography
- Use Material 3 typography scale
- Define text styles for:
  - Display (hero text)
  - Headline (section headlines)
  - Title (list headlines)
  - Body (paragraph text)
  - Label (button and UI labels)
- Ensure proper hierarchy and readability

### 6. Integrate Theme into App
- Update `MaterialApp.router` in `main.dart`
- Set `theme` property to light theme
- Set `darkTheme` property to dark theme
- Set `themeMode` to `ThemeMode.system` for automatic switching

### 7. Create Theme Documentation
- Document color usage and semantics
- Document component theme customizations
- Provide examples of common UI patterns

## Files to Create/Modify

### New Files
- `lib/core/theme/app_theme.dart` - main theme configuration
- `lib/core/theme/color_schemes.dart` - color scheme definitions
- `lib/core/theme/text_themes.dart` - typography configuration
- `lib/core/theme/component_themes.dart` - component theme definitions

### Modified Files
- `lib/main.dart` - integrate theme configuration

## Testing Strategy
- Visual inspection of common components in both themes
- Verify theme switching works correctly
- Ensure all Material components respect theme configuration
- Test readability and contrast in both modes
- Verify shadows render correctly

## Dependencies
No new dependencies required - uses built-in Material theming system.

## Acceptance Criteria
- [ ] Light theme configured with harmonious color scheme
- [ ] Dark theme configured with proper contrast
- [ ] All component themes defined
- [ ] Multi-layered shadows applied to cards and elevated surfaces
- [ ] Typography hierarchy established
- [ ] Theme automatically switches based on system settings
- [ ] Code passes `flutter analyze`
- [ ] Visual consistency across the app
