import 'package:shared_preferences/shared_preferences.dart';

const String backendProviderIp = "192.168.106.145:5080";


class BackendProvider {
  static const _key = 'backend_provider_ip';
  static const String defaultIp = '192.168.106.145:5080';
  static String _ip = defaultIp;

  static String get backendProviderIp => _ip;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _ip = prefs.getString(_key) ?? defaultIp;
  }

  static Future<void> setBackendProviderIp(String newIp) async {
    _ip = newIp;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newIp);
  }
}
