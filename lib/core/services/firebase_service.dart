import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase initialization service.
/// Fails clearly and explicitly if Firebase options are not configured yet,
/// instructing the developer to run lutterfire configure.
class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      // If firebase_options.dart is generated, DefaultFirebaseOptions.currentPlatform is passed.
      // Firebase.initializeApp() without options will use default platform files (google-services.json / GoogleService-Info.plist).
      await Firebase.initializeApp();
      _isInitialized = true;
      debugPrint('[FirebaseService] Firebase initialized successfully.');
    } catch (e) {
      _isInitialized = false;
      final errorMessage =
          '\n=======================================================\n'
          '[FIREBASE INITIALIZATION ERROR]\n'
          'Firebase failed to initialize or is not configured yet.\n'
          'Details: \n\n'
          'ACTION REQUIRED:\n'
          'Run the FlutterFire CLI to generate credentials:\n'
          '  flutterfire configure\n'
          'This will generate lib/firebase_options.dart and configure native Android/iOS files.\n'
          '=======================================================\n';
      debugPrint(errorMessage);
      // Re-throw descriptive exception to satisfy the requirement:
      // Do not silently fall back when Firebase is not configured.
      throw FirebaseConfigurationException(
        'Firebase is not configured. Please run lutterfire configure to generate firebase_options.dart. Details: ',
      );
    }
  }
}

class FirebaseConfigurationException implements Exception {
  final String message;
  const FirebaseConfigurationException(this.message);

  @override
  String toString() => 'FirebaseConfigurationException: ';
}
