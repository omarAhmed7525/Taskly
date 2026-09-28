import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../../../core/errors/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges.asyncMap((fbUser) async {
      if (fbUser == null) return null;
      try {
        final profile = await _remoteDataSource.getUserProfile(fbUser.uid);
        return profile?.toEntity() ?? AppUser(
          uid: fbUser.uid,
          name: fbUser.displayName ?? '',
          email: fbUser.email ?? '',
          photoUrl: fbUser.photoURL,
        );
      } catch (_) {
        return AppUser(
          uid: fbUser.uid,
          name: fbUser.displayName ?? '',
          email: fbUser.email ?? '',
          photoUrl: fbUser.photoURL,
        );
      }
    });
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final fbUser = _remoteDataSource.currentUser;
    if (fbUser == null) return null;
    try {
      final profile = await _remoteDataSource.getUserProfile(fbUser.uid);
      return profile?.toEntity() ?? AppUser(
        uid: fbUser.uid,
        name: fbUser.displayName ?? '',
        email: fbUser.email ?? '',
        photoUrl: fbUser.photoURL,
      );
    } catch (_) {
      return AppUser(
        uid: fbUser.uid,
        name: fbUser.displayName ?? '',
        email: fbUser.email ?? '',
        photoUrl: fbUser.photoURL,
      );
    }
  }

  @override
  Future<Result<AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Result.success(userModel.toEntity());
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return Result.success(userModel.toEntity());
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Result.success(null);
    } on fb.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthException(e));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  String _mapFirebaseAuthException(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Wrong password or invalid credentials provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'An authentication error occurred ().';
    }
  }
}
