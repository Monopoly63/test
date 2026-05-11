import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Map<String, int> getState() {
    final str = _prefs?.getString('hisn_state') ?? '{}';
    try {
      final decoded = jsonDecode(str) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveState(Map<String, int> state) async {
    await _prefs?.setString('hisn_state', jsonEncode(state));
  }

  static Map<String, bool> getFavs() {
    final str = _prefs?.getString('hisn_favs') ?? '{}';
    try {
      final decoded = jsonDecode(str) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as bool));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveFavs(Map<String, bool> favs) async {
    await _prefs?.setString('hisn_favs', jsonEncode(favs));
  }

  static bool getDarkMode() {
    return _prefs?.getBool('hisn_dark') ?? false;
  }

  static Future<void> saveDarkMode(bool value) async {
    await _prefs?.setBool('hisn_dark', value);
  }
}