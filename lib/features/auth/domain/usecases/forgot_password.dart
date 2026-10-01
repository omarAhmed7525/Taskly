import '../../../../core/errors/result.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;
  ForgotPasswordUseCase(this._repository);

  Future<Result<void>> call({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
