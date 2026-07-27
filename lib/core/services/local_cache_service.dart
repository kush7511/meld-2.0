import 'package:hive_flutter/hive_flutter.dart';

class LocalCacheService {
  const LocalCacheService._();

  static const conversationsBox = 'conversations_cache';
  static const messagesBox = 'messages_cache';
  static const profilesBox = 'profiles_cache';
  static const queueBox = 'offline_queue';
  static const secureBox = 'secure_preferences';

  static Future<void> openBoxes() async {
    await Future.wait([
      Hive.openBox<Map<dynamic, dynamic>>(conversationsBox),
      Hive.openBox<Map<dynamic, dynamic>>(messagesBox),
      Hive.openBox<Map<dynamic, dynamic>>(profilesBox),
      Hive.openBox<Map<dynamic, dynamic>>(queueBox),
      Hive.openBox<String>(secureBox),
    ]);
  }
}
