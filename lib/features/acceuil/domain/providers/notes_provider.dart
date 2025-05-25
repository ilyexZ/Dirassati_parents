// lib/features/acceuil/domain/providers/notes_provider.dart
import 'package:dirassati/core/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../acceuil/data/datasources/students_remote_data_source.dart';
import '../../../acceuil/data/models/note_model.dart';

// We assume that dioProvider, secureStorageProvider, and studentsRemoteDataSourceProvider
// are defined as in your existing students provider code.


final studentsRemoteDataSourceProvider = Provider<StudentsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return StudentsRemoteDataSource(dio: dio, storage: storage);
});


// In notes_provider.dart
final studentNotesProvider = FutureProvider.family<List<Note>, String>((ref, studentId) async {
  final remoteDataSource = ref.watch(studentsRemoteDataSourceProvider);
  return remoteDataSource.fetchStudentNotes(studentId);
});
