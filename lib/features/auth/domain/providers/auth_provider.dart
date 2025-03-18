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
  // New debug login method for bypassing actual API call.
  Future<void> debugLogin() async {
    const dummyToken = "debug_dummy_token";
    // Write the dummy token to secure storage.
    await _secureStorage.write(key: 'auth_token', value: dummyToken);
    // Set a static user. Adjust these values as needed.
    state = UserModel(token: dummyToken, firstName: "Debug", lastName: "User");
  }
}


