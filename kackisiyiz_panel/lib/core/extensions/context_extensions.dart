import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData themeData() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          background: baseColor,
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        elevatedButtonTheme: elevatedButtonTheme,
      );

  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );

  /// koyu
  Color get baseColor => const Color(0xFF121212);
  /// orta koyu
  Color get secondaryColor => const Color(0xFF1F1A24);
  /// açık
  Color get primaryColor => const Color(0xFFBB86FC);

  TextStyle get titleStyle =>
      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
}
