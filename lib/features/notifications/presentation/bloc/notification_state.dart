import 'package:equatable/equatable.dart';
import '../../domain/entities/app_notification.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<AppNotification> notifications;
  final String? fcmToken;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.fcmToken,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
    String? fcmToken,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      fcmToken: fcmToken ?? this.fcmToken,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, fcmToken, errorMessage];
}
