import '../../../../core/errors/result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<Result<AppUser>> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
