import 'package:shared_preferences/shared_preferences.dart';

class SecurityService {
  SecurityService(this._preferences);

  static const _appLockKey = 'security.app_lock_enabled';
  static const _sessionHistoryKey = 'security.session_history';

  final SharedPreferences _preferences;

  bool get isAppLockEnabled => _preferences.getBool(_appLockKey) ?? false;

  Future<void> setAppLockEnabled(bool value) {
    return _preferences.setBool(_appLockKey, value);
  }

  List<String> get sessionHistory {
    return _preferences.getStringList(_sessionHistoryKey) ?? const [];
  }

  Future<void> recordSession(String deviceLabel) {
    final updated = [...sessionHistory, deviceLabel];
    return _preferences.setStringList(_sessionHistoryKey, updated);
  }
}
