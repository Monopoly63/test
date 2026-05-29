import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static const String defaultFontFamily = 'Amiri';
  static const double defaultFontScale = 1.0;
  static const int defaultMorningReminder = 7 * 60;
  static const int defaultEveningReminder = 18 * 60;
  static const int defaultFajrAlarm = 4 * 60 + 30;

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

  static double getFontScale() {
    return _prefs?.getDouble('hisn_font_scale') ?? defaultFontScale;
  }

  static Future<void> saveFontScale(double value) async {
    await _prefs?.setDouble('hisn_font_scale', value.clamp(0.8, 1.6));
  }

  static String getFontFamily() {
    return _prefs?.getString('hisn_font_family') ?? defaultFontFamily;
  }

  static Future<void> saveFontFamily(String value) async {
    await _prefs?.setString('hisn_font_family', value);
  }

  static int getMorningReminderMinutes() {
    return _prefs?.getInt('hisn_morning_reminder') ?? defaultMorningReminder;
  }

  static Future<void> saveMorningReminderMinutes(int value) async {
    await _prefs?.setInt('hisn_morning_reminder', value);
  }

  static int getEveningReminderMinutes() {
    return _prefs?.getInt('hisn_evening_reminder') ?? defaultEveningReminder;
  }

  static Future<void> saveEveningReminderMinutes(int value) async {
    await _prefs?.setInt('hisn_evening_reminder', value);
  }

  static int getFajrAlarmMinutes() {
    return _prefs?.getInt('hisn_fajr_alarm') ?? defaultFajrAlarm;
  }

  static Future<void> saveFajrAlarmMinutes(int value) async {
    await _prefs?.setInt('hisn_fajr_alarm', value);
  }
}