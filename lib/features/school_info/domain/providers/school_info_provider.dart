// lib/features/school_info/domain/providers/school_info_provider.dart
import 'package:dirassati/core/auth_info_provider.dart';
import 'package:dirassati/core/core_providers.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/features/acceuil/domain/providers/students_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/school_info_model.dart';
import '../../data/datasources/school_info_remote_data_source.dart';
import '../../data/repositories/school_info_repository.dart';

String get backendUrl => BackendProvider.backendProviderIp;

/// Provider for the remote data source - this follows your exact pattern
/// from the absences provider, keeping consistency across your app
final schoolInfoRemoteDataSourceProvider = Provider<SchoolInfoRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return SchoolInfoRemoteDataSource(dio: dio, storage: storage);
});

/// Provider for the repository - again following your established pattern
/// This makes it easy to inject dependencies and test your code
final schoolInfoRepositoryProvider = Provider<SchoolInfoRepository>((ref) {
  final remoteDataSource = ref.watch(schoolInfoRemoteDataSourceProvider);
  return SchoolInfoRepository(remoteDataSource);
});

/// Main provider to fetch school information
/// This uses FutureProvider just like your other providers
final schoolInfoProvider = FutureProvider<SchoolInfo>((ref) async {
  final parentId = await ref.watch(parentIdProvider.future);
  final repository = ref.watch(schoolInfoRepositoryProvider);
  final students = await ref.watch(studentsProvider.future);
  
  // Get the first student's ID from the students list
  if (students.isEmpty) {
    throw Exception('No students found for this parent');
  }
  
  final firstStudentId = students.first.studentId;
  final response = await repository.fetchSchoolInfo(firstStudentId);
  clog("r", "SCHOOL INFO!!!");
  print(response);
  return response;
});