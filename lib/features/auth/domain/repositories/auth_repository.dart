import '../../../../core/errors/result.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  Future<AppUser?> getCurrentUser();
  Future<Result<AppUser>> login({required String email, required String password});
  Future<Result<AppUser>> register({required String name, required String email, required String password});
  Future<Result<void>> logout();
  Future<Result<void>> forgotPassword({required String email});
}
