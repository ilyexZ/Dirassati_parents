// lib/features/acceuil/presentation/widgets/notes_tab.dart
import 'package:flutter/material.dart';
import '../../data/models/note_model.dart';
import 'grade_item.dart';

class NotesTab extends StatelessWidget {
  final List<Note> notes;

  const NotesTab({Key? key, required this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: (context, i) {
        final note = notes[i];
        return GradeItem(
          subject: note.subjectName,
          tri: note.trimester,
          grade: note.value,
          // you can pass trimester if GradeItem shows it
        );
      },
    );
  }
}
