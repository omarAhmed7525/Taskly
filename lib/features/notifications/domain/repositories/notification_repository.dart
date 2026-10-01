import '../../../../core/errors/result.dart';
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  Future<String?> initialize();
  Future<Result<void>> saveToken({required String uid, required String token});
  Future<Result<void>> removeToken({required String uid, required String token});
  Stream<List<AppNotification>> getNotificationsStream({required String userId});
  Future<Result<void>> markAsRead({required String notificationId});
}
