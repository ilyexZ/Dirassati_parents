// lib/features/acceuil/presentation/widgets/notes_tab.dart
import 'package:flutter/material.dart';
import 'grade_item.dart';

class NotesTab extends StatefulWidget {
  final String title;
  const NotesTab({Key? key, required this.title}) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final List<Map<String, dynamic>> subjects = [
    {"subject": "langue Arabe", "coef": 3, "grade": 12.5},
    {"subject": "Mathematiques", "coef": 4, "grade": 15.5},
    {"subject": "langue Francaise", "coef": 2, "grade": 7.0},
    {"subject": "Physiques", "coef": 2, "grade": 14.75},
    {"subject": "Sciences naturelles", "coef": 3, "grade": 12.5},
    {"subject": "sport", "coef": 4, "grade": 15.0},
    {"subject": "langue Anglaise", "coef": 2, "grade": 7.0},
  ];

  final List<String> trimesters = ["Trimestre 1", "Trimestre 2", "Trimestre 3"];
  String _selectedTrimester = "Trimestre 1";

  @override
  Widget build(BuildContext context) {
    final sharedStyle = const TextStyle(fontSize: 10, fontWeight: FontWeight.w400);

    return Padding(
      
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    padding: EdgeInsets.zero,
                    value: _selectedTrimester,
                    menuWidth: 95,
                    
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedTrimester = newValue;
                        });
                      }
                    },
                    items: trimesters.map((String trimester) {
                      return DropdownMenuItem<String>(
                        value: trimester,
                        child: Text(trimester, style: sharedStyle),
                      );
                    }).toList(),
                  ),
                ),
                const Expanded(flex: 3, child: SizedBox()),
                const Expanded(flex: 1, child: Text("Coef", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400))),
                const Expanded(
                  flex: 2,
                  child: Text("Note", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400), textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
          // ListView of Grades (Static Data)
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final item = subjects[index];
                return GradeItem(
                  subject: item["subject"] as String,
                  coef: item["coef"] as int,
                  grade: item["grade"] as double,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
/*
// lib/features/acceuil/presentation/widgets/notes_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../acceuil/domain/providers/notes_provider.dart';
import '../../../acceuil/data/models/note_model.dart';
import 'grade_item.dart';

class NotesTab extends ConsumerStatefulWidget {
  final String title;
  const NotesTab({Key? key, required this.title}) : super(key: key);

  @override
  ConsumerState<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends ConsumerState<NotesTab> {
  final List<String> trimesters = ["Trimestre 1", "Trimestre 2", "Trimestre 3"];
  String _selectedTrimester = "Trimestre 1";

  @override
  Widget build(BuildContext context) {
    final sharedStyle = const TextStyle(fontSize: 10, fontWeight: FontWeight.w400);
    
    // Use the provider with both the category (from widget.title) and selected trimester.
    final notesAsyncValue = ref.watch(notesProvider({
      'category': widget.title,
      'trimester': _selectedTrimester,
    }));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    padding: EdgeInsets.zero,
                    value: _selectedTrimester,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedTrimester = newValue;
                        });
                      }
                    },
                    items: trimesters.map((String trimester) {
                      return DropdownMenuItem<String>(
                        value: trimester,
                        child: Text(trimester, style: sharedStyle),
                      );
                    }).toList(),
                  ),
                ),
                const Expanded(flex: 3, child: SizedBox()),
                const Expanded(flex: 1, child: Text("Coef", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400))),
                const Expanded(
                  flex: 2,
                  child: Text("Note", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400), textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
          // ListView with API data
          Expanded(
            child: notesAsyncValue.when(
              data: (notes) => ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final Note note = notes[index];
                  return GradeItem(
                    subject: note.title,
                    coef: note.coef,
                    grade: note.grade,
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text("Error: $error")),
            ),
          ),
        ],
      ),
    );
  }
}

 */