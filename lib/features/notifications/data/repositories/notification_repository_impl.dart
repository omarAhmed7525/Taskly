import 'package:firebase_core/firebase_core.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({required NotificationRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<String?> initialize() {
    return _remoteDataSource.initialize();
  }

  @override
  Future<Result<void>> saveToken({required String uid, required String token}) async {
    try {
      await _remoteDataSource.saveToken(uid: uid, token: token);
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to save token');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> removeToken({required String uid, required String token}) async {
    try {
      await _remoteDataSource.removeToken(uid: uid, token: token);
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to remove token');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Stream<List<AppNotification>> getNotificationsStream({required String userId}) {
    return _remoteDataSource
        .getNotificationsStream(userId: userId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<void>> markAsRead({required String notificationId}) async {
    try {
      await _remoteDataSource.markAsRead(notificationId: notificationId);
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to mark notification as read');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
