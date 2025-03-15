import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String email, String password) async {
    debugPrint("$email $password");
    final response = await dio.post(
      'http://192.168.1.8:5080/api/parent/auth/login',
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
            print(data);
        return UserModel.fromJson(data);
      } else {
        
        throw Exception("Missing required fields in response: $data");
        
      }
    } else {
      throw Exception("Login failed");
    }
  }
}


// class AuthRemoteDataSource {
//   final Dio dio;

//   AuthRemoteDataSource(this.dio);

//   Future<UserModel> login(String email, String password) async {
// //     // For local testing: simulate a correct and incorrect login.
// //     if (email == "test@example.com" && password == "password123") {
// //       // Simulated correct login:
// //       return UserModel(token: "dummy_token", email: email);
// //     } else {
// //       // Simulated wrong credentials:
// //       throw Exception("Login failed: Invalid credentials");
// //     }
    
//     // When ready to test with Docker, comment out the above code and use:
    
//     //'/api/parents' /api/parent/auth/login
//     final response = await dio.post('http://localhost:5080/api/parent/auth/login', data: {
//       'email': email,
//       'password': password,
//     });
//     print("Response data: ${response.data}");
//     if (response.statusCode == 200) {
//       return UserModel.fromJson(response.data);
//     } else {
//       throw Exception("Login failed");
//     }
    
//   }
// }
