import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecoveryAction {
  none,
  appSettings,
  locationSettings,
}

class DeviceIssue implements Exception {
  const DeviceIssue(
    this.message, [
    this.action = RecoveryAction.none,
  ]);

  final String message;
  final RecoveryAction action;

  @override
  String toString() => message;
}

class DeviceService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickPhoto(ImageSource source) async {
    if (!kIsWeb && source == ImageSource.camera) {
      var permission = await Permission.camera.status;

      if (permission.isDenied) {
        permission = await Permission.camera.request();
      }

      if (permission.isPermanentlyDenied) {
        throw const DeviceIssue(
          'Camera access is blocked. '
          'Please allow it in app settings.',
          RecoveryAction.appSettings,
        );
      }

      if (!permission.isGranted) {
        throw const DeviceIssue(
          'Camera permission was denied or restricted.',
        );
      }
    }

    return _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1080,
      requestFullMetadata: false,
    );
  }

  Future<String> preparePhoto(XFile photo) async {
    if (!kIsWeb) {
      return photo.path;
    }

    final bytes = await photo.readAsBytes();

    final original = img.decodeImage(bytes);

    if (original == null) {
      throw const DeviceIssue(
        'This image format is not supported. '
        'Please choose a JPG or PNG photo.',
      );
    }

    var optimized = img.bakeOrientation(original);

    if (optimized.width > 1080) {
      optimized = img.copyResize(
        optimized,
        width: 1080,
      );
    }

    final compressed = img.encodeJpg(
      optimized,
      quality: 80,
    );

    return 'data:image/jpeg;base64,'
        '${base64Encode(compressed)}';
  }

  Future<XFile?> recoverLostPhoto() async {
    if (kIsWeb ||
        defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }

    final response = await _picker.retrieveLostData();

    if (response.isEmpty) {
      return null;
    }

    if (response.exception != null) {
      throw response.exception!;
    }

    final files = response.files;

    if (files == null || files.isEmpty) {
      return null;
    }

    return files.first;
  }

  Future<Position> fetchPosition() async {
    if (!kIsWeb) {
      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        throw const DeviceIssue(
          'Location services are disabled. '
          'Please turn on GPS.',
          RecoveryAction.locationSettings,
        );
      }
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw DeviceIssue(
        kIsWeb
            ? 'Location access is blocked. '
                'Allow it in Chrome site settings.'
            : 'Location access is blocked. '
                'Allow it in app settings.',
        kIsWeb
            ? RecoveryAction.none
            : RecoveryAction.appSettings,
      );
    }

    if (!kIsWeb &&
        permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      throw const DeviceIssue(
        'Location permission was denied.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
      ),
    );
  }
}