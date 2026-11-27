import 'package:flutter/material.dart';

ThemeData buildAppTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5))
      .copyWith(
        primary: const Color(0xFF4F46E5),
        surface: Colors.white,
        onSurface: const Color(0xFF111827),
        onSurfaceVariant: const Color(0xFF64748B),
        error: const Color(0xFFDC2626),
      ),
  scaffoldBackgroundColor: const Color(0xFFF5F7FB),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF5F7FB),
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shadowColor: const Color(0x14111827),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: Color(0xFFE7EAF2)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF5F7FB),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    hintStyle: const TextStyle(color: Color(0xFF8B95A7), fontSize: 14),
    prefixIconColor: const Color(0xFF788399),
    suffixIconColor: const Color(0xFF788399),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE7EAF2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
);
