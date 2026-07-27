import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      await _messaging.requestPermission();
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    } on Object catch (error) {
      debugPrint('FCM setup skipped: $error');
    }
  }

  Future<String?> getToken() async {
    try {
      return _messaging.getToken();
    } on Object catch (_) {
      return null;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground notification: ${message.messageId}');
  }
}
