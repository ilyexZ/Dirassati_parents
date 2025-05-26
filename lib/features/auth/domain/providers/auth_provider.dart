// lib/features/auth/domain/providers/auth_provider.dart
import 'package:dirassati/core/core_providers.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/core/services/signalr_service.dart';
import 'package:dirassati/core/services/auth_notification_integration.dart'; // Add this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../../data/datasources/auth_remote.dart';
import '../../data/datasources/auth_local.dart';
import '../../domain/usecases/change_password_usecase.dart';

final authRemoteDataSourceProvider = Provider((ref) => AuthRemoteDataSource(ref.read(dioProvider)));
final authLocalDataSourceProvider = Provider((ref) => AuthLocalDataSource(ref.read(secureStorageProvider)));

final authRepositoryProvider = Provider((ref) => AuthRepository(
  ref.read(authRemoteDataSourceProvider),
  ref.read(authLocalDataSourceProvider),
));

final authStateProvider = StateNotifierProvider<AuthStateNotifier, UserModel?>((ref) {
  return AuthStateNotifier(
    ref.read(authRepositoryProvider), 
    ref.read(secureStorageProvider),
    ref.read(authNotificationIntegrationProvider), // Add this line
  );
});

class AuthStateNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;
  final AuthNotificationIntegration _notificationIntegration; // Add this field

  late final SignalRService _signalRService;

  AuthStateNotifier(
    this._authRepository, 
    this._secureStorage,
    this._notificationIntegration, // Add this parameter
  ) : _signalRService = SignalRService(),
      super(null);

  Future<void> login(String email, String password) async {
    try {
      final user = await _authRepository.login(email, password);
      if (user == null) {
        throw Exception("Invalid credentials");
      }
      
      // Store the token
      await _secureStorage.write(key: 'auth_token', value: user.token);
      
      // Update the state
      state = user;
      
      // Start SignalR connection (your existing code)
      await _signalRService.startConnection();
      
      // 🔥 IMPORTANT: Initialize notification system after successful login
      await _notificationIntegration.onUserLoggedIn(user.token);
      
      clog('g', '✅ Login successful and notifications initialized');
    } catch (e) {
      clog('r', '❌ Login failed: $e');
      rethrow; // Re-throw to let the UI handle the error
    }
  }

  Future<void> logout() async {
    try {
      // 🔥 IMPORTANT: Cleanup notification system before logout
      await _notificationIntegration.onUserLoggedOut();
      
      // Your existing logout logic
      await _secureStorage.delete(key: 'auth_token');
      await _signalRService.stopConnection();
      
      // Clear the state
      state = null;
      
      clog('g', '✅ Logout successful and notifications cleaned up');
    } catch (e) {
      clog('r', '❌ Logout cleanup failed: $e');
    }
  }
  
  Future<void> debugLogin() async {
    try {
      const dummyToken = "debug_dummy_token";
      
      // Write the dummy token to secure storage
      await _secureStorage.write(key: 'auth_token', value: dummyToken);
      
      // Set a static user
      state = UserModel(token: dummyToken, firstName: "Debug", lastName: "User");
      
      // Initialize notifications for debug mode too
      await _notificationIntegration.onUserLoggedIn(dummyToken);
      
      clog("g", "🐛 DEBUG LOGIN with notifications initialized");
    } catch (e) {
      clog('r', '❌ Debug login failed: $e');
    }
  }

  // New method to check notification status
  bool get isNotificationSystemReady {
    return _notificationIntegration.isNotificationSystemReady;
  }

  // New method to force reconnect notifications
  Future<void> reconnectNotifications() async {
    if (state?.token != null) {
      await _notificationIntegration.reconnectNotifications(state!.token);
    }
  }
}

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return ChangePasswordUseCase(repository);
});