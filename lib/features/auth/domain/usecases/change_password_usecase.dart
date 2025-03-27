// lib/features/auth/domain/usecases/change_password_usecase.dart
import '../../data/repositories/auth_repo_impl.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> execute({
    required String currentPassword,
    required String newPassword,
  }) async {
    // Business logic or additional validations can be added here.
    await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
