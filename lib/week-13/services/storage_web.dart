Future<String> persistPhoto(
  String sourcePath,
  String id,
) async {
  if (!sourcePath.startsWith('data:image/')) {
    throw const FormatException(
      'Invalid browser image data.',
    );
  }

  return sourcePath;
}

Future<String> restorePhotoPath(String path) async {
  return path;
}

Future<void> removePhoto(String path) async {
  // Browser images are stored inside diary metadata.
}