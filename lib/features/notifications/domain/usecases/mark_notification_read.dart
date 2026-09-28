import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository _repository;
  MarkNotificationReadUseCase(this._repository);

  Future<Result<void>> call({required String notificationId}) {
    return _repository.markAsRead(notificationId: notificationId);
  }
}
