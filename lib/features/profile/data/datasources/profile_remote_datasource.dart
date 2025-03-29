import 'package:dio/dio.dart';
import 'package:dirassati/core/auth_info_provider.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/features/profile/domain/entity/profile.dart';
import 'package:riverpod/riverpod.dart';

abstract class ProfileRemoteDataSource {
  Future<Profile> fetchProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  final Ref ref;

  ProfileRemoteDataSourceImpl({required this.dio, required this.ref});

  @override
  Future<Profile> fetchProfile() async {
    final parentID = await ref.read(parentIdProvider.future);
    final url = "http://$backendProviderIp/api/parents/$parentID";

    // For now, you can return static data if you wish:
    if (parentID == "debugparentID") {
      return Profile(
        parentId: "1f0fd9ac-d8bb-4089-b952-7f482ebc41da",
        occupation: "Teacher",
        firstName: "Jane",
        lastName: "Doe",
        birthDate: "31/12/9999",
        userName: "parent@example.com",
        email: "parent@example.com",
        emailConfirmed: true,
        phoneNumber: "555-123-4567",
        phoneNumberConfirmed: false,
        relationshipName: "",
      );
    }

    // Otherwise, fetch from the backend.
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return Profile.fromJson(response.data);
    } else {
      throw Exception("Failed to fetch profile");
    }
  }
}
