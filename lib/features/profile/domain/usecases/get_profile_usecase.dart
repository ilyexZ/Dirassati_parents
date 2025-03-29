import 'package:dirassati/features/profile/data/datasources/repository/profile_repository.dart';
import 'package:dirassati/features/profile/domain/entity/profile.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase({required this.repository});

  Future<Profile> execute() async {
    return await repository.getProfile();
  }
}
