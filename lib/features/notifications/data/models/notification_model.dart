import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_notification.dart';

class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    super.isRead,
    super.data,
    super.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return NotificationModel(
      id: doc.id,
      userId: (data['userId'] as String?) ?? '',
      title: (data['title'] as String?) ?? '',
      body: (data['body'] as String?) ?? '',
      isRead: (data['isRead'] as bool?) ?? false,
      data: (data['data'] as Map<String, dynamic>?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'isRead': isRead,
      if (data != null) 'data': data,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  AppNotification toEntity() {
    return AppNotification(
      id: id,
      userId: userId,
      title: title,
      body: body,
      isRead: isRead,
      data: data,
      createdAt: createdAt,
    );
  }
}
