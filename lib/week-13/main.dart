import 'package:flutter/material.dart';

import 'screens/photo_diary_screen.dart';
import 'screens/journal_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PhotoJournalApp());
}

class PhotoJournalApp extends StatelessWidget {
  const PhotoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memoir — Narxoz Photo Journal',

      debugShowCheckedModeBanner: false,

      themeAnimationDuration: Duration.zero,

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: journalBackground,

        colorScheme: ColorScheme.fromSeed(
          seedColor: journalGreen,
          primary: journalGreen,
          secondaryContainer: journalSoft,
          onSecondaryContainer: journalGreen,
          surface: Colors.white,
          onSurface: journalInk,
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 48),

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),

            animationDuration: Duration.zero,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: journalGreen,

            minimumSize: const Size(0, 48),

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),

            animationDuration: Duration.zero,

            side: const BorderSide(
              color: journalBorder,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,

          fillColor: journalBackground,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(
              color: journalGreen,
            ),
          ),

          contentPadding: const EdgeInsets.all(16),
        ),

        snackBarTheme: const SnackBarThemeData(
          backgroundColor: journalInk,
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),

        progressIndicatorTheme:
            const ProgressIndicatorThemeData(
          color: journalGreen,
        ),
      ),

      home: const PhotoDiaryScreen(),
    );
  }
}