import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

class ProjectFailure extends Failure {
  const ProjectFailure(super.message, [super.code]);
}

class NotificationFailure extends Failure {
  const NotificationFailure(super.message, [super.code]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again.', super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.', super.code]);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied for this operation.', super.code]);
}
