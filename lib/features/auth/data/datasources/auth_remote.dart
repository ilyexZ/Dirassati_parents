import 'package:dio/dio.dart';
import 'package:dirassati/core/shared_constants.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String email, String password) async {
    debugPrint("$email $password");
    final response = await dio.post(
      'http://$backendProviderIp/api/parent/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    debugPrint("Response data: ${response.data}"); // Debug print

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
      throw Exception("Login failed");
    }
  }
  // New method for changing password.
  Future<void> changePassword(String currentPassword, String newPassword) async {
    const endpoint = "http://$backendProviderIp/api/parent/"; // Replace with your endpoint
    final response = await dio.post(endpoint, data: {
      "current_password": currentPassword,
      "new_password": newPassword,
    });
    if (response.statusCode != 200) {
      // You might want to inspect response.data for more error details.
      throw Exception("Password change failed");
    }
  }
  
}



