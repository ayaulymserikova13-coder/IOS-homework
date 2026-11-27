class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.photoPath,
    required this.caption,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.timestamp,
  });

  final String id;
  final String photoPath;
  final String caption;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photoPath': photoPath,
      'caption': caption,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] as String,
      photoPath: json['photoPath'] as String,
      caption: json['caption'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  DiaryEntry withPhotoPath(String path) {
    return DiaryEntry(
      id: id,
      photoPath: path,
      caption: caption,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      altitude: altitude,
      timestamp: timestamp,
    );
  }
}