import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/media_service.dart';
import '../services/notification_service.dart';
import '../services/security_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences is provided at bootstrap.'),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService.instance,
);

final mediaServiceProvider = Provider<MediaService>((ref) => MediaService());

final securityServiceProvider = Provider<SecurityService>(
  (ref) => SecurityService(ref.watch(sharedPreferencesProvider)),
);
