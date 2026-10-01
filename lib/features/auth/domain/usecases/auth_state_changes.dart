import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class AuthStateChangesUseCase {
  final AuthRepository _repository;
  AuthStateChangesUseCase(this._repository);

  Stream<AppUser?> call() {
    return _repository.authStateChanges;
  }
}
