
import 'package:dirassati/features/auth/data/datasources/auth_local.dart';
import 'package:dirassati/features/auth/data/datasources/auth_remote.dart';
import 'package:dirassati/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
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
    debugPrint("LOGGGGGGGGGGGGGGINNNNNNNNNNNNERRRRRRRRRRRRRRRRRR88");
    print(e);
    return null;
  }
  }

  Future<void> logout() async {
    await localDataSource.clearToken();
  }

  Future<bool> isLoggedIn() async {
    return await localDataSource.getToken() != null;
  }
}
