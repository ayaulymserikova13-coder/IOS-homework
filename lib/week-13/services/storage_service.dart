import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/diary_entry.dart';

import 'storage_native.dart'
    if (dart.library.js_interop) 'storage_web.dart'
    as platform_storage;

class StorageService {
  static const storageKey = 'narxoz_week13_memoir_v2';

  Future<List<DiaryEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(storageKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final data = jsonDecode(raw) as List<dynamic>;

    final entries = <DiaryEntry>[];

    for (final item in data) {
      final entry = DiaryEntry.fromJson(
        item as Map<String, dynamic>,
      );

      final restoredPath =
          await platform_storage.restorePhotoPath(
        entry.photoPath,
      );

      entries.add(
        entry.withPhotoPath(restoredPath),
      );
    }

    return entries;
  }

  Future<DiaryEntry> saveEntry({
    required String photoPath,
    required String caption,
    required Position position,
    required List<DiaryEntry> existing,
  }) async {
    if (photoPath.isEmpty || caption.trim().isEmpty) {
      throw const FormatException(
        'A photo and caption are required.',
      );
    }

    final now = DateTime.now();

    final id = now.microsecondsSinceEpoch.toString();

    final savedPath =
        await platform_storage.persistPhoto(
      photoPath,
      id,
    );

    final entry = DiaryEntry(
      id: id,
      photoPath: savedPath,
      caption: caption.trim(),
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      timestamp: now,
    );

    try {
      await _writeEntries([
        entry,
        ...existing,
      ]);

      return entry;
    } catch (_) {
      await platform_storage.removePhoto(savedPath);
      rethrow;
    }
  }

  Future<void> deleteEntry({
    required DiaryEntry entry,
    required List<DiaryEntry> existing,
  }) async {
    final updated = existing
        .where((item) => item.id != entry.id)
        .toList();

    await _writeEntries(updated);

    try {
      await platform_storage.removePhoto(
        entry.photoPath,
      );
    } catch (_) {
      // Metadata was already saved successfully.
    }
  }

  Future<void> _writeEntries(
    List<DiaryEntry> entries,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      entries.map((entry) => entry.toJson()).toList(),
    );

    if (kIsWeb && encoded.length > 3500000) {
      throw const FormatException(
        'Browser storage is almost full. '
        'Delete an old memory and try again.',
      );
    }

    final saved = await prefs.setString(
      storageKey,
      encoded,
    );

    if (!saved) {
      throw StateError(
        'Could not save diary entries.',
      );
    }
  }
}