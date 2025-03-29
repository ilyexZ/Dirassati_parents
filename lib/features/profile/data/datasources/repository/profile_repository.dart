import 'package:dirassati/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:dirassati/features/profile/domain/entity/profile.dart';


abstract class ProfileRepository {
  Future<Profile> getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Profile> getProfile() async {
    return await remoteDataSource.fetchProfile();
  }
}
