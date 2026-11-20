import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_item.dart';

class LocalStorageService {
  LocalStorageService(this.preferences);
  final SharedPreferences preferences;
  static const themeKey = 'app_theme_dark_mode';
  static const nameKey = 'user_display_name';
  static const notesKey = 'saved_notes';
  bool hadInvalidNotes = false;

  bool get darkMode => preferences.getBool(themeKey) ?? false;
  String get displayName => preferences.getString(nameKey) ?? 'Guest User';

  List<NoteItem> loadNotes() {
    hadInvalidNotes = false;
    final raw = preferences.getString(notesKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) throw const FormatException('Expected a list');
      final notes = <NoteItem>[];
      for (final item in decoded) {
        try {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Expected an object');
          }
          notes.add(NoteItem.fromJson(item));
        } on FormatException {
          hadInvalidNotes = true;
        }
      }
      return notes;
    } on FormatException {
      hadInvalidNotes = true;
      return [];
    }
  }

  Future<void> _check(Future<bool> result) async {
    if (!await result) throw StateError('Local storage write failed');
  }

  Future<void> saveTheme(bool value) =>
      _check(preferences.setBool(themeKey, value));
  Future<void> saveName(String value) =>
      _check(preferences.setString(nameKey, value));
  Future<void> saveNotes(List<NoteItem> notes) => _check(
    preferences.setString(
      notesKey,
      jsonEncode(notes.map((note) => note.toJson()).toList()),
    ),
  );
}
