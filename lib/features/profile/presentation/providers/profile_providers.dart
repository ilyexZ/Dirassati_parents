import 'package:dio/dio.dart';
import 'package:dirassati/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:dirassati/features/profile/data/datasources/repository/profile_repository.dart';
import 'package:dirassati/features/profile/domain/entity/profile.dart';
import 'package:dirassati/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Provide Dio instance
final dioProvider = Provider<Dio>((ref) => Dio());

// Provide the remote data source
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRemoteDataSourceImpl(dio: dio,ref:ref);
});

// Provide the repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Provide the use case
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repository: repository);
});

// Finally, create a FutureProvider to fetch the profile
final profileProvider = FutureProvider<Profile>((ref) async {
  final useCase = ref.watch(getProfileUseCaseProvider);
  return await useCase.execute();
});
