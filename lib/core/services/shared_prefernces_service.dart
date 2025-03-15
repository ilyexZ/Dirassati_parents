import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _onboardingKey = "seenOnboarding";

  // Static helper to get an instance of SharedPreferences.
  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> getSeenOnboarding() async {
    final prefs = await getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setSeenOnboarding(bool seen) async {
    final prefs = await getInstance();
    await prefs.setBool(_onboardingKey, seen);
  }
}
