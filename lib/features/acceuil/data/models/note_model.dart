// lib/features/acceuil/data/models/note_model.dart
class Note {
  final String title;
  final int coef;
  final double grade;

  Note({
    required this.title,
    required this.coef,
    required this.grade,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'] as String,
      coef: json['coef'] as int,
      grade: (json['grade'] as num).toDouble(),
    );
  }
}
