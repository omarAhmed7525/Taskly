import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[NotificationService] Background message received: ');
}

/// Service handling Firebase Cloud Messaging setup, permissions, token management,
/// and message listeners.
class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  NotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final StreamController<RemoteMessage> _foregroundMessageController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> _messageOpenedAppController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get onForegroundMessage => _foregroundMessageController.stream;
  Stream<RemoteMessage> get onMessageOpenedApp => _messageOpenedAppController.stream;

  /// Initializes FCM: sets up handlers, requests permissions, and returns the device token.
  Future<String?> initialize() async {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permissions
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('[NotificationService] Permission status: ${settings.authorizationStatus}');

    // Setup foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[NotificationService] Foreground message: ');
      _foregroundMessageController.add(message);
    });

    // Setup tap/open listener from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[NotificationService] Message opened app: ');
      _messageOpenedAppController.add(message);
    });

    // Check if app was opened from terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[NotificationService] App launched from terminated via notification: ');
      _messageOpenedAppController.add(initialMessage);
    }

    return await getToken();
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('[NotificationService] Error getting FCM token: ');
      return null;
    }
  }

  /// Listen for token refreshes
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Store device token under users/{uid}/devices/{deviceId}
  Future<void> saveDeviceToken({
    required String uid,
    required String token,
  }) async {
    try {
      final deviceId = token.hashCode.toString();
      final deviceDoc = _firestore
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(deviceId);

      String platformName = 'web';
      if (!kIsWeb) {
        platformName = Platform.isAndroid
            ? 'android'
            : Platform.isIOS
                ? 'ios'
                : Platform.operatingSystem;
      }

      await deviceDoc.set({
        'token': token,
        'platform': platformName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[NotificationService] Error saving device token: ');
    }
  }

  /// Remove device token on logout
  Future<void> removeDeviceToken({
    required String uid,
    required String token,
  }) async {
    try {
      final deviceId = token.hashCode.toString();
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(deviceId)
          .delete();
    } catch (e) {
      debugPrint('[NotificationService] Error removing device token: ');
    }
  }

  void dispose() {
    _foregroundMessageController.close();
    _messageOpenedAppController.close();
  }
}
