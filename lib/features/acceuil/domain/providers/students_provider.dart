import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../acceuil/data/datasources/students_remote_data_source.dart';
import '../../../acceuil/data/repositories/student_repository.dart';
import '../../../acceuil/data/models/student_model.dart';

// Provide Dio instance.
final dioProvider = Provider((ref) => Dio());

// Provide secure storage.
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

// Provide the remote data source.
final studentsRemoteDataSourceProvider = Provider<StudentsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return StudentsRemoteDataSource(dio: dio, storage: storage);
});

// Provide the repository.
final studentsRepositoryProvider = Provider<StudentsRepository>((ref) {
  final remoteDataSource = ref.watch(studentsRemoteDataSourceProvider);
  return StudentsRepository(remoteDataSource);
});

// FutureProvider to fetch the list of students.
final studentsProvider = FutureProvider<List<Student>>((ref) async {
  final repository = ref.watch(studentsRepositoryProvider);
  return repository.fetchStudents();
});
