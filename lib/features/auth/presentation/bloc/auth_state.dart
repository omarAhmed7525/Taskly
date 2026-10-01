import 'package:equatable/equatable.dart';
import '../../domain/entities/app_user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
  passwordResetSent,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated(AppUser user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  factory AuthState.unauthenticated() => const AuthState(
        status: AuthStatus.unauthenticated,
      );

  factory AuthState.failure(String message) => AuthState(
        status: AuthStatus.failure,
        errorMessage: message,
      );

  factory AuthState.passwordResetSent(String message) => AuthState(
        status: AuthStatus.passwordResetSent,
        successMessage: message,
      );

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, successMessage];
}
