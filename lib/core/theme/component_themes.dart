import 'package:flutter/material.dart';

AppBarTheme createAppBarTheme(ColorScheme colorScheme) {
  return AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 3,
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    shadowColor: colorScheme.shadow,
  );
}

ElevatedButtonThemeData createElevatedButtonTheme(ColorScheme colorScheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
    ),
  );
}

TextButtonThemeData createTextButtonTheme(ColorScheme colorScheme) {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

OutlinedButtonThemeData createOutlinedButtonTheme(ColorScheme colorScheme) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: colorScheme.outline),
    ),
  );
}

InputDecorationTheme createInputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceContainerHighest,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

CardThemeData createCardTheme(ColorScheme colorScheme) {
  return CardThemeData(
    elevation: 3,
    shadowColor: colorScheme.shadow.withValues(alpha: 0.4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: colorScheme.surfaceContainerLow,
    margin: const EdgeInsets.all(8),
  );
}

FloatingActionButtonThemeData createFloatingActionButtonTheme(ColorScheme colorScheme) {
  return FloatingActionButtonThemeData(
    elevation: 6,
    highlightElevation: 12,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    backgroundColor: colorScheme.primaryContainer,
    foregroundColor: colorScheme.onPrimaryContainer,
  );
}

DialogThemeData createDialogTheme(ColorScheme colorScheme) {
  return DialogThemeData(
    elevation: 6,
    shadowColor: colorScheme.shadow.withValues(alpha: 0.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    backgroundColor: colorScheme.surface,
  );
}

SnackBarThemeData createSnackBarTheme(ColorScheme colorScheme) {
  return SnackBarThemeData(
    elevation: 6,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: colorScheme.inverseSurface,
    contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
  );
}

ChipThemeData createChipTheme(ColorScheme colorScheme) {
  return ChipThemeData(
    backgroundColor: colorScheme.surfaceContainerLow,
    selectedColor: colorScheme.secondaryContainer,
    disabledColor: colorScheme.surfaceContainerLow.withValues(alpha: 0.38),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: TextStyle(color: colorScheme.onSurface),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

ListTileThemeData createListTileTheme(ColorScheme colorScheme) {
  return ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    tileColor: colorScheme.surface,
    selectedTileColor: colorScheme.secondaryContainer.withValues(alpha: 0.5),
  );
}
