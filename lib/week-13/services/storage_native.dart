import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> persistPhoto(
  String sourcePath,
  String id,
) async {
  final root = await getApplicationDocumentsDirectory();

  final folder = Directory(
    '${root.path}/week13_photos',
  );

  await folder.create(recursive: true);

  final extension =
      sourcePath.split('.').last.toLowerCase();

  final suffix =
      RegExp(r'^[a-z0-9]{1,5}$').hasMatch(extension)
          ? extension
          : 'jpg';

  final destination = File(
    '${folder.path}/$id.$suffix',
  );

  await File(sourcePath).copy(destination.path);

  return destination.path;
}

Future<String> restorePhotoPath(String path) async {
  final root = await getApplicationDocumentsDirectory();

  final filename = path
      .replaceAll('\\', '/')
      .split('/')
      .last;

  return '${root.path}/week13_photos/$filename';
}

Future<void> removePhoto(String path) async {
  final file = File(path);

  if (await file.exists()) {
    await file.delete();
  }
}