import 'package:flutter/material.dart';
import 'package:deptsandloans/core/theme/color_schemes.dart';
import 'package:deptsandloans/core/theme/text_themes.dart';
import 'package:deptsandloans/core/theme/component_themes.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final colorScheme = lightColorScheme;
    final textTheme = createTextTheme(colorScheme);

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      useMaterial3: true,
      brightness: Brightness.light,
      appBarTheme: createAppBarTheme(colorScheme),
      elevatedButtonTheme: createElevatedButtonTheme(colorScheme),
      textButtonTheme: createTextButtonTheme(colorScheme),
      outlinedButtonTheme: createOutlinedButtonTheme(colorScheme),
      inputDecorationTheme: createInputDecorationTheme(colorScheme),
      cardTheme: createCardTheme(colorScheme),
      floatingActionButtonTheme: createFloatingActionButtonTheme(colorScheme),
      dialogTheme: createDialogTheme(colorScheme),
      snackBarTheme: createSnackBarTheme(colorScheme),
      chipTheme: createChipTheme(colorScheme),
      listTileTheme: createListTileTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: colorScheme.outlineVariant,
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = darkColorScheme;
    final textTheme = createTextTheme(colorScheme);

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      appBarTheme: createAppBarTheme(colorScheme),
      elevatedButtonTheme: createElevatedButtonTheme(colorScheme),
      textButtonTheme: createTextButtonTheme(colorScheme),
      outlinedButtonTheme: createOutlinedButtonTheme(colorScheme),
      inputDecorationTheme: createInputDecorationTheme(colorScheme),
      cardTheme: createCardTheme(colorScheme),
      floatingActionButtonTheme: createFloatingActionButtonTheme(colorScheme),
      dialogTheme: createDialogTheme(colorScheme),
      snackBarTheme: createSnackBarTheme(colorScheme),
      chipTheme: createChipTheme(colorScheme),
      listTileTheme: createListTileTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: colorScheme.outlineVariant,
    );
  }
}
