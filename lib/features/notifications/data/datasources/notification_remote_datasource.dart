import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/notification_service.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<String?> initialize();
  Future<void> saveToken({required String uid, required String token});
  Future<void> removeToken({required String uid, required String token});
  Stream<List<NotificationModel>> getNotificationsStream({required String userId});
  Future<void> markAsRead({required String notificationId});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NotificationService _notificationService;
  final FirebaseFirestore _firestore;

  NotificationRemoteDataSourceImpl({
    required NotificationService notificationService,
    FirebaseFirestore? firestore,
  })  : _notificationService = notificationService,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('notifications');

  @override
  Future<String?> initialize() {
    return _notificationService.initialize();
  }

  @override
  Future<void> saveToken({required String uid, required String token}) {
    return _notificationService.saveDeviceToken(uid: uid, token: token);
  }

  @override
  Future<void> removeToken({required String uid, required String token}) {
    return _notificationService.removeDeviceToken(uid: uid, token: token);
  }

  @override
  Stream<List<NotificationModel>> getNotificationsStream({required String userId}) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> markAsRead({required String notificationId}) async {
    await _notificationsCollection.doc(notificationId).update({'isRead': true});
  }
}
