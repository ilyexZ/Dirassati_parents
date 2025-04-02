import 'package:dio/dio.dart';
import 'package:dirassati/features/auth/data/datasources/auth_local.dart';
import 'package:dirassati/features/auth/data/datasources/auth_remote.dart';
import 'package:dirassati/features/auth/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepository(this.remoteDataSource, this.localDataSource);

  Future<UserModel?> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(user.token);
      return user;
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");

      return null;
    }
  }

  Future<void> logout() async {
    await localDataSource.clearToken();
  }

  Future<bool> isLoggedIn() async {
    return await localDataSource.getToken() != null;
  }

  Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  try {
    await remoteDataSource.changePassword(currentPassword, newPassword);
  } on DioException catch (e) {
    debugPrint("❌ DioException occurred: ${e.toString()}");
    debugPrint("📌 Status Code: ${e.response?.statusCode}");
    debugPrint("📌 Response Data: ${e.response?.data}");

    String errorMessage;

    if (e.response?.data is Map<String, dynamic>) {
      // Extract message if the response is JSON
      errorMessage = e.response?.data['message'] ?? "Unknown backend error";
    } else if (e.response?.data is String) {
      // If response is plain text, return it
      errorMessage = e.response?.data;
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Network timeout. Please try again.";
    } else if (e.type == DioExceptionType.badResponse) {
      errorMessage = "Invalid server response. Please try again later.";
    } else {
      errorMessage = e.message ?? "An unknown error occurred";
    }

    throw Exception(errorMessage);
  } catch (e, stacktrace) {
    debugPrint("❌ Unknown error: $e");
    debugPrint("🔍 Stacktrace: $stacktrace");
    throw Exception("Une erreur est survenue");
  }
}

}
