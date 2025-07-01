import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static final String _tokenKey = dotenv.env['PREF_KEY']!;
  static const String _onboardingKey = 'onboarding_done';
  static const String _isCurrentAccess = 'current_access';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setCurrentAccess(String currentAccess) async {
    await _prefs.setString(_isCurrentAccess, currentAccess);
  }

  static String? getCurrentAccess() {
    return _prefs.getString(_isCurrentAccess);
  }

  static Future<void> clearCurrentAccess() async {
    await _prefs.remove(_isCurrentAccess);
  }


  static Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  static bool isLoggedIn() {
    return _prefs.containsKey(_tokenKey);
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingKey, completed);
  }

  static bool hasCompletedOnboarding() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }
}
