import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // or your secure storage wrapper
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repo_impl.dart'; // Use this version
import '../../data/datasources/auth_remote.dart';
import '../../data/datasources/auth_local.dart'; // if needed
import 'package:dio/dio.dart';

final dioProvider = Provider((ref) => Dio());
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final authRemoteDataSourceProvider = Provider((ref) => AuthRemoteDataSource(ref.read(dioProvider)));
final authLocalDataSourceProvider = Provider((ref) => AuthLocalDataSource(ref.read(secureStorageProvider)));

final authRepositoryProvider = Provider((ref) => AuthRepository(
  ref.read(authRemoteDataSourceProvider),
  ref.read(authLocalDataSourceProvider),
));

final authStateProvider = StateNotifierProvider<AuthStateNotifier, UserModel?>((ref) {
  return AuthStateNotifier(ref.read(authRepositoryProvider), ref.read(secureStorageProvider));
});

class AuthStateNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;

  AuthStateNotifier(this._authRepository, this._secureStorage) : super(null);

  Future<void> login(String email, String password) async {
    final user = await _authRepository.login(email, password);
    if (user == null) {
      throw Exception("Invalid credentials");
    }
    await _secureStorage.write(key: 'auth_token', value: user.token);
    state = user;
    print(user);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    state = null;
  }
}


// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/storage/secure_storage.dart';
// import '../../data/models/user_model.dart';
// import '../../data/repositories/auth_repo_impl.dart';
// import '../../../../core/services/auth_service.dart';

// final authServiceProvider = Provider((ref) => AuthService());
// final authRepositoryProvider = Provider((ref) => AuthRepository(ref.read(authServiceProvider)));
// final secureStorageProvider = Provider((ref) => SecureStorage());

// final authStateProvider = StateNotifierProvider<AuthStateNotifier, UserModel?>((ref) {
//   return AuthStateNotifier(ref.read(authRepositoryProvider), ref.read(secureStorageProvider));
// });

// class AuthStateNotifier extends StateNotifier<UserModel?> {
//   final AuthRepository _authRepository;
//   final SecureStorage _secureStorage;

//   AuthStateNotifier(this._authRepository, this._secureStorage) : super(null);

//   Future<void> login(String email, String password) async {
//     final user = await _authRepository.login(email, password);
//     if (user != null) {
//       await _secureStorage.saveToken(user.token);
//       state = user;
//     }
//   }

//   Future<void> logout() async {
//     await _secureStorage.deleteToken();
//     state = null;
//   }
// }
