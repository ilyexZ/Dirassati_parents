import 'package:dirassati/core/auth_info_provider.dart';
import 'package:dirassati/core/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../acceuil/data/datasources/students_remote_data_source.dart';
import '../../../acceuil/data/repositories/student_repository.dart';
import '../../../acceuil/data/models/student_model.dart';


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

// ./features/acceuil/domain/providers/students_provider.dart
final studentsProvider = FutureProvider<List<Student>>((ref) async {
  final parentId = await ref.watch(parentIdProvider.future);
  final repository = ref.watch(studentsRepositoryProvider);
  return repository.fetchStudents(parentId); 
});


