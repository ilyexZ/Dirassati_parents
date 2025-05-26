import 'package:dio/dio.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:dirassati/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final SecureStorage secureStorage = SecureStorage();
String get backendUrl => BackendProvider.backendProviderIp;


  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String email, String password) async {
  debugPrint("$email $password");
  clog("r", backendUrl);

  final data = {
    'email': email,
    'password': password,
  };

  final response = await dio.post(
    'http://$backendUrl/api/parent/auth/login',
    data: data,
    options: Options(
      followRedirects: false, // We will handle 307 manually
      validateStatus: (status) => status != null && status < 400,
    ),
  );

  // Handle 307 Temporary Redirect manually
  if (response.statusCode == 307) {
    final redirectedUrl = response.headers.value('location');
    if (redirectedUrl != null) {
      final redirectedResponse = await dio.post(
        redirectedUrl,
        data: data,
      );
      return _parseLoginResponse(redirectedResponse);
    } else {
      throw Exception("Redirected, but no Location header found.");
    }
  }

  return _parseLoginResponse(response);
}

// Helper to parse the login response
UserModel _parseLoginResponse(Response response) {
  debugPrint("Response data: ${response.data}");

  if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
    final data = response.data as Map<String, dynamic>;
    if (data.containsKey('token') &&
        data.containsKey('firstName') &&
        data.containsKey('lastName')) {
      return UserModel.fromJson(data);
    } else {
      throw Exception("Missing required fields in response: $data");
    }
  } else {
    throw Exception("Login failed with status ${response.statusCode}");
  }
}

  // New method for changing password.
  // Future<void> changePassword(String currentPassword, String newPassword) async {
  // final response = await dio.post(
  //   'http://$backendUrl/api/parent/change-password',
  //   data: {
  //     "currentPassword": currentPassword,
  //     "newPassword": newPassword,
  //   },
  // );

  // if (response.statusCode != 200) {
  //   final errorMessage = response.data['message'] ?? "Password change failed";
  //   throw Exception(errorMessage);
  // }
// }
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    // Retrieve the token from secure storage
    final SecureStorage storage = SecureStorage();
    final String? token = await storage.getToken();
    clog("g", "$token");
    if (token == null) {
      throw Exception("No token found. Please log in again.");
    }
    clog("g", "Current Password Length: ${currentPassword.length}");
    clog("g", "New Password Length: ${newPassword.length}");

    final response = await dio.post(
      'http://$backendUrl/api/Accounts/change-password',
      data: {
        "oldPassword": currentPassword,
        "newPassword": newPassword,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token', // Include the token here
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
      ),
    );

    if (response.statusCode != 200) {
      final errorMessage = response.data['message'] ?? "Password change failed";
      throw Exception(errorMessage);
    }
  }
}
