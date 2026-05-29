import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/app_data.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const int morningReminderId = 1001;
  static const int eveningReminderId = 1002;
  static const int fajrAlarmId = 1003;
  static const int generalNowId = 1004;

  static const String _generalChannelId = 'tazakkar_general_reminders';
  static const String _morningEveningChannelId = 'tazakkar_morning_evening';
  static const String _fajrAlarmChannelId = 'tazakkar_fajr_alarm';

  static Future<void> init() async {
    await _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    await requestPermissions();
  }

  static Future<void> requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showGeneralDhikrNow() async {
    final item = _randomGeneralDhikr();
    await _notifications.show(
      generalNowId,
      'تذكر',
      item,
      await _notificationDetails(
        channelId: _generalChannelId,
        channelName: 'أذكار عامة',
        channelDescription: 'تنبيهات فورية للأذكار العامة',
      ),
    );
  }

  static Future<void> scheduleMorningReminder(int hour, int minute) async {
    await _scheduleDaily(
      id: morningReminderId,
      hour: hour,
      minute: minute,
      title: 'تذكر - أذكار الصباح',
      body: 'حان وقت أذكار الصباح، ابدأ يومك بذكر الله.',
      channelId: _morningEveningChannelId,
      channelName: 'أذكار الصباح والمساء',
      channelDescription: 'تنبيهات يومية لأذكار الصباح والمساء',
    );
  }

  static Future<void> scheduleEveningReminder(int hour, int minute) async {
    await _scheduleDaily(
      id: eveningReminderId,
      hour: hour,
      minute: minute,
      title: 'تذكر - أذكار المساء',
      body: 'حان وقت أذكار المساء، اجعل ختام يومك ذكرًا وطمأنينة.',
      channelId: _morningEveningChannelId,
      channelName: 'أذكار الصباح والمساء',
      channelDescription: 'تنبيهات يومية لأذكار الصباح والمساء',
    );
  }

  static Future<void> scheduleFajrAlarm(int hour, int minute) async {
    await _scheduleDaily(
      id: fajrAlarmId,
      hour: hour,
      minute: minute,
      title: 'تذكر - منبه الفجر',
      body: 'حان وقت الاستيقاظ لصلاة الفجر. الصلاة خير من النوم.',
      channelId: _fajrAlarmChannelId,
      channelName: 'منبه صلاة الفجر',
      channelDescription: 'منبه يومي للاستيقاظ لصلاة الفجر',
      isAlarm: true,
    );
  }

  static Future<void> cancelMorningReminder() => _notifications.cancel(morningReminderId);
  static Future<void> cancelEveningReminder() => _notifications.cancel(eveningReminderId);
  static Future<void> cancelFajrAlarm() => _notifications.cancel(fajrAlarmId);
  static Future<void> cancelAll() => _notifications.cancelAll();

  static Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required String channelDescription,
    bool isAlarm = false,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOf(hour, minute),
      await _notificationDetails(
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
        isAlarm: isAlarm,
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<NotificationDetails> _notificationDetails({
    required String channelId,
    required String channelName,
    required String channelDescription,
    bool isAlarm = false,
  }) async {
    final imageBytes = await _loadNotificationImage();
    final largeIcon = imageBytes == null ? null : ByteArrayAndroidBitmap(imageBytes);
    final styleInformation = imageBytes == null
        ? null
        : BigPictureStyleInformation(
            ByteArrayAndroidBitmap(imageBytes),
            largeIcon: largeIcon,
            contentTitle: 'تذكر',
            summaryText: 'أذكار وأدعية',
          );

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: isAlarm ? Importance.max : Importance.high,
      priority: isAlarm ? Priority.max : Priority.high,
      category: isAlarm
          ? AndroidNotificationCategory.alarm
          : AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      largeIcon: largeIcon,
      styleInformation: styleInformation,
      sound: isAlarm ? const RawResourceAndroidNotificationSound('adhan') : null,
      audioAttributesUsage:
          isAlarm ? AudioAttributesUsage.alarm : AudioAttributesUsage.notification,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  static Future<Uint8List?> _loadNotificationImage() async {
    try {
      final data = await rootBundle.load('1.jpg');
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  static String _randomGeneralDhikr() {
    final generalCategory = appData.firstWhere(
      (category) => category.category.contains('أذكار عامة'),
      orElse: () => appData.last,
    );
    final items = generalCategory.items;
    if (items.isEmpty) return 'اذكر الله يذكرك.';
    final index = DateTime.now().millisecondsSinceEpoch % items.length;
    return items[index].text;
  }
}
