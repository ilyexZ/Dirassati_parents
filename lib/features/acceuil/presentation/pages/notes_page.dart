// lib/features/acceuil/presentation/pages/notes_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/note_model.dart';
import '../../domain/providers/notes_provider.dart';
import '../../domain/providers/students_provider.dart';
import '../widgets/notes_tab.dart';

// 1) Define a provider for the currently selected trimester:
final trimesterProvider = StateProvider<int>((ref) => 1);

// 2) Make NotesPage a ConsumerWidget:
class NotesPage extends ConsumerWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsProvider);
    final studentId = studentsAsync.maybeWhen(
      data: (list) => list.isNotEmpty ? list.first.studentId : null,
      orElse: () => null,
    );

    // Read & write the trimester through Riverpod
    final trimester = ref.watch(trimesterProvider);
    void setTrimester(int t) => ref.read(trimesterProvider.notifier).state = t;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          bottom: TabBar(tabs: const [
            Tab(text: "Devoir 1"),
            Tab(text: "Devoir 2"),
            Tab(text: "Examen"),
            Tab(text: "Evaluation"),
          ]),
        ),
        body: studentId == null
            ? const Center(child: Text("No student found"))
            : ref.watch(studentNotesProvider(studentId)).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e,_) => Center(child: Text("Error: $e")),
                data: (allNotes) {
                  // Shared header fixed above tabs:
                  return Column(
                    children: [
                      // Trimester selector + labels:
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            DropdownButton<int>(
                              value: trimester,
                              onChanged: (v) => v != null ? setTrimester(v) : null,
                              items: const [
                                DropdownMenuItem(value: 1, child: Text("Trimestre 1")),
                                DropdownMenuItem(value: 2, child: Text("Trimestre 2")),
                                DropdownMenuItem(value: 3, child: Text("Trimestre 3")),
                              ],
                            ),
                            const Spacer(),
                            const SizedBox(
                              width: 60,
                              child: Text("Coef",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                            ),
                            const SizedBox(
                              width: 60,
                              child: Text("Note",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Tab content:
                      Expanded(
                        child: TabBarView(children: [
                          NotesTab(notes: allNotes.where((n) => n.trimester == trimester && n.examTypeName=="devoir1").toList()),
                          NotesTab(notes: allNotes.where((n) => n.trimester == trimester && n.examTypeName=="devoir2").toList()),
                          NotesTab(notes: allNotes.where((n) => n.trimester == trimester && n.examTypeName=="examen").toList()),
                          NotesTab(notes: allNotes.where((n) => n.trimester == trimester && n.examTypeName=="evaluation").toList()),
                        ]),
                      )
                    ],
                  );
                }),
      ),
    );
  }
}
