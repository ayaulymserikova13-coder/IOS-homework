class NoteItem {
  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String dateText;
  final bool isCompleted;

  NoteItem withTitle(String value) => NoteItem(
    id: id,
    title: value,
    dateText: dateText,
    isCompleted: isCompleted,
  );

  NoteItem toggled() => NoteItem(
    id: id,
    title: title,
    dateText: dateText,
    isCompleted: !isCompleted,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dateText': dateText,
    'isCompleted': isCompleted,
  };

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! String ||
        json['title'] is! String ||
        json['dateText'] is! String ||
        json['isCompleted'] is! bool) {
      throw const FormatException('Invalid note fields');
    }
    return NoteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      dateText: json['dateText'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
