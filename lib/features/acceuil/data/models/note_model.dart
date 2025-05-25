// lib/features/acceuil/data/models/note_model.dart
class Note {
  final String examTypeName;
  final int trimester;
  final double value;
  final String subjectName;

  Note({
    required this.examTypeName,
    required this.trimester,
    required this.value,
    required this.subjectName,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      examTypeName: json['examTypeName'] as String,
      subjectName: json['subjectName'] as String,
      trimester: json['tremester'] as int,
      value: (json['value'] as num).toDouble(),
    );
  }
}
