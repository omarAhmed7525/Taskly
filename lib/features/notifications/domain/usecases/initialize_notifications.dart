import '../repositories/notification_repository.dart';

class InitializeNotificationsUseCase {
  final NotificationRepository _repository;
  InitializeNotificationsUseCase(this._repository);

  Future<String?> call() {
    return _repository.initialize();
  }
}
