import 'package:flutter/material.dart';

/// Big, high-contrast and calm: the players may have weaker eyes and less steady hands.
final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2E6B4F),
    contrastLevel: 1,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 22),
    bodyMedium: TextStyle(fontSize: 22),
    labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  ),
  appBarTheme: const AppBarTheme(toolbarHeight: 72, centerTitle: true),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size(64, 64)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(minimumSize: const Size(64, 64)),
  ),
);
