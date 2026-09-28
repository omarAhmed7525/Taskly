import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationInitRequested extends NotificationEvent {
  final String userId;
  const NotificationInitRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class NotificationSubscribeRequested extends NotificationEvent {
  final String userId;
  const NotificationSubscribeRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class NotificationMarkReadRequested extends NotificationEvent {
  final String notificationId;
  const NotificationMarkReadRequested({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}
