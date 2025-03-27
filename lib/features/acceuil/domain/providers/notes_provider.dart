// lib/features/acceuil/domain/providers/notes_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../acceuil/data/datasources/students_remote_data_source.dart';
import '../../../acceuil/data/models/note_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// We assume that dioProvider, secureStorageProvider, and studentsRemoteDataSourceProvider
// are defined as in your existing students provider code.
final dioProvider = Provider((ref) => Dio());
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final studentsRemoteDataSourceProvider = Provider<StudentsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return StudentsRemoteDataSource(dio: dio, storage: storage);
});

// FutureProvider.family to fetch notes by category and trimester.
final notesProvider = FutureProvider.family<List<Note>, Map<String, String>>((ref, params) async {
  final remoteDataSource = ref.watch(studentsRemoteDataSourceProvider);
  final category = params['category']!;
  final trimester = params['trimester']!;
  return remoteDataSource.fetchNotes(category, trimester);
});

