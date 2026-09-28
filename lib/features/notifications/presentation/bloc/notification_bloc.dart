import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/initialize_notifications.dart';
import '../../domain/usecases/mark_notification_read.dart';
import '../../domain/usecases/save_fcm_token.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final InitializeNotificationsUseCase _initializeNotificationsUseCase;
  final SaveFcmTokenUseCase _saveFcmTokenUseCase;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;

  StreamSubscription? _notificationsSubscription;

  NotificationBloc({
    required InitializeNotificationsUseCase initializeNotificationsUseCase,
    required SaveFcmTokenUseCase saveFcmTokenUseCase,
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationReadUseCase markNotificationReadUseCase,
  })  : _initializeNotificationsUseCase = initializeNotificationsUseCase,
        _saveFcmTokenUseCase = saveFcmTokenUseCase,
        _getNotificationsUseCase = getNotificationsUseCase,
        _markNotificationReadUseCase = markNotificationReadUseCase,
        super(const NotificationState()) {
    on<NotificationInitRequested>(_onInitRequested);
    on<NotificationSubscribeRequested>(_onSubscribeRequested);
    on<NotificationMarkReadRequested>(_onMarkReadRequested);
  }

  Future<void> _onInitRequested(
    NotificationInitRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final token = await _initializeNotificationsUseCase();
    if (token != null) {
      await _saveFcmTokenUseCase(uid: event.userId, token: token);
      emit(state.copyWith(fcmToken: token));
    }
  }

  Future<void> _onSubscribeRequested(
    NotificationSubscribeRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    await _notificationsSubscription?.cancel();
    await emit.forEach(
      _getNotificationsUseCase(userId: event.userId),
      onData: (notifications) => state.copyWith(
        status: NotificationStatus.success,
        notifications: notifications,
      ),
      onError: (error, _) => state.copyWith(
        status: NotificationStatus.failure,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> _onMarkReadRequested(
    NotificationMarkReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    await _markNotificationReadUseCase(notificationId: event.notificationId);
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
