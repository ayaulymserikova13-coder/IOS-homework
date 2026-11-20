import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/note_item.dart';
import 'screens/notes_vault_screen.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = LocalStorageService(await SharedPreferences.getInstance());
  // Read all persisted state before the very first Flutter frame.
  final darkMode = storage.darkMode;
  final name = storage.displayName;
  final notes = storage.loadNotes();
  runApp(
    NotesVaultApp(
      storage: storage,
      initialDarkMode: darkMode,
      initialName: name,
      initialNotes: notes,
    ),
  );
}

class NotesVaultApp extends StatefulWidget {
  const NotesVaultApp({
    super.key,
    required this.storage,
    required this.initialDarkMode,
    required this.initialName,
    required this.initialNotes,
  });
  final LocalStorageService storage;
  final bool initialDarkMode;
  final String initialName;
  final List<NoteItem> initialNotes;

  @override
  State<NotesVaultApp> createState() => _NotesVaultAppState();
}

class _NotesVaultAppState extends State<NotesVaultApp> {
  late bool darkMode = widget.initialDarkMode;

  ThemeData theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final background = Color(dark ? 0xFF111322 : 0xFFF7F7FC);
    final surface = Color(dark ? 0xFF1C2033 : 0xFFFFFFFF);
    final foreground = Color(dark ? 0xFFF1F5F9 : 0xFF0F172A);
    final border = Color(dark ? 0xFF32364F : 0xFFE7E7F2);
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: brightness,
          ).copyWith(
            surface: surface,
            onSurface: foreground,
            primary: Color(dark ? 0xFFA5B4FC : 0xFF6366F1),
            onPrimary: Color(dark ? 0xFF0F172A : 0xFFFFFFFF),
            outlineVariant: border,
          ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: const Color(0x0D0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Offline-First Notes & Settings Vault',
    theme: theme(Brightness.light),
    darkTheme: theme(Brightness.dark),
    themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
    home: NotesVaultScreen(
      storage: widget.storage,
      initialName: widget.initialName,
      initialNotes: widget.initialNotes,
      darkMode: darkMode,
      onThemeChanged: (value) => setState(() => darkMode = value),
    ),
  );
}
