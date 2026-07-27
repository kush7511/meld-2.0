import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/local_cache_service.dart';
import '../services/notification_service.dart';
import '../../firebase_options.dart';
class AppBootstrap {
  const AppBootstrap._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await LocalCacheService.openBoxes();
    await SharedPreferences.getInstance();
    await _initializeFirebase();
    await NotificationService.instance.initialize();
  }

  static Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    } on Object catch (error, stackTrace) {
      // Local UI development can run before platform Firebase files are added.
      debugPrint('Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
