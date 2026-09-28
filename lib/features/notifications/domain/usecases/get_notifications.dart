import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;
  GetNotificationsUseCase(this._repository);

  Stream<List<AppNotification>> call({required String userId}) {
    return _repository.getNotificationsStream(userId: userId);
  }
}
