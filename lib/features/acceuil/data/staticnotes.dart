import 'package:dirassati/features/acceuil/data/models/note_model.dart';

final List<Note> debugNotes = [
  // Trimester 1
  Note(subjectName: "langue Arabe", examTypeName: 'devoir1', value: 12.5, trimester: 1),
  Note(subjectName: "langue Arabe", examTypeName: 'devoir2', value: 13.0, trimester: 1),
  Note(subjectName: "langue Arabe", examTypeName: 'examen', value: 14.0, trimester: 1),

  Note(subjectName: "Mathematiques", examTypeName: 'devoir1', value: 15.5, trimester: 1),
  Note(subjectName: "Mathematiques", examTypeName: 'evaluation', value: 16.0, trimester: 1),
  Note(subjectName: "Mathematiques", examTypeName: 'examen', value: 14.5, trimester: 1),

  Note(subjectName: "langue Francaise", examTypeName: 'devoir1', value: 7.0, trimester: 1),
  Note(subjectName: "Physiques", examTypeName: 'devoir1', value: 14.75, trimester: 1),
  Note(subjectName: "Sciences naturelles", examTypeName: 'devoir1', value: 12.5, trimester: 1),
  Note(subjectName: "sport", examTypeName: 'evaluation', value: 15.0, trimester: 1),
  Note(subjectName: "langue Anglaise", examTypeName: 'examen', value: 7.0, trimester: 1),

  // Trimester 2
  Note(subjectName: "langue Arabe", examTypeName: 'devoir1', value: 11.5, trimester: 2),
  Note(subjectName: "langue Arabe", examTypeName: 'evaluation', value: 12.0, trimester: 2),
  Note(subjectName: "Mathematiques", examTypeName: 'examen', value: 17.0, trimester: 2),
  Note(subjectName: "langue Francaise", examTypeName: 'devoir2', value: 9.0, trimester: 2),
  Note(subjectName: "Physiques", examTypeName: 'evaluation', value: 13.5, trimester: 2),
  Note(subjectName: "Sciences naturelles", examTypeName: 'examen', value: 14.0, trimester: 2),
  Note(subjectName: "sport", examTypeName: 'devoir1', value: 16.0, trimester: 2),
  Note(subjectName: "langue Anglaise", examTypeName: 'devoir2', value: 8.0, trimester: 2),

  // Extra entries
  Note(subjectName: "Informatique", examTypeName: 'devoir1', value: 13.5, trimester: 1),
  Note(subjectName: "Informatique", examTypeName: 'examen', value: 16.5, trimester: 2),
  Note(subjectName: "Histoire", examTypeName: 'devoir1', value: 12.0, trimester: 1),
  Note(subjectName: "Histoire", examTypeName: 'evaluation', value: 13.0, trimester: 2),
  Note(subjectName: "Géographie", examTypeName: 'examen', value: 14.5, trimester: 2),
  Note(subjectName: "Philosophie", examTypeName: 'devoir2', value: 10.0, trimester: 2),
];
