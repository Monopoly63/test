import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late int _morningMinutes;
  late int _eveningMinutes;
  late int _fajrMinutes;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _morningMinutes = StorageService.getMorningReminderMinutes();
    _eveningMinutes = StorageService.getEveningReminderMinutes();
    _fajrMinutes = StorageService.getFajrAlarmMinutes();
  }

  TimeOfDay _timeFromMinutes(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  int _minutesFromTime(TimeOfDay time) => time.hour * 60 + time.minute;

  Future<void> _runBusy(Future<void> Function() action) async {
    setState(() => _isBusy = true);
    try {
      await NotificationService.requestPermissions();
      await action();
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _sendGeneralNotification() async {
    await _runBusy(() async {
      await NotificationService.showGeneralDhikrNow();
      _showMessage('تم إرسال إشعار ذكر عام');
    });
  }

  Future<void> _pickMorningTime() async {
    final picked = await _pickTime(_morningMinutes);
    if (picked == null) return;

    final minutes = _minutesFromTime(picked);
    await _runBusy(() async {
      await StorageService.saveMorningReminderMinutes(minutes);
      await NotificationService.scheduleMorningReminder(picked.hour, picked.minute);
      setState(() => _morningMinutes = minutes);
      _showMessage('تم ضبط إشعار أذكار الصباح');
    });
  }

  Future<void> _pickEveningTime() async {
    final picked = await _pickTime(_eveningMinutes);
    if (picked == null) return;

    final minutes = _minutesFromTime(picked);
    await _runBusy(() async {
      await StorageService.saveEveningReminderMinutes(minutes);
      await NotificationService.scheduleEveningReminder(picked.hour, picked.minute);
      setState(() => _eveningMinutes = minutes);
      _showMessage('تم ضبط إشعار أذكار المساء');
    });
  }

  Future<void> _pickFajrTime() async {
    final picked = await _pickTime(_fajrMinutes);
    if (picked == null) return;

    final minutes = _minutesFromTime(picked);
    await _runBusy(() async {
      await StorageService.saveFajrAlarmMinutes(minutes);
      await NotificationService.scheduleFajrAlarm(picked.hour, picked.minute);
      setState(() => _fajrMinutes = minutes);
      _showMessage('تم ضبط منبه الفجر');
    });
  }

  Future<TimeOfDay?> _pickTime(int initialMinutes) {
    return showTimePicker(
      context: context,
      initialTime: _timeFromMinutes(initialMinutes),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }

  Future<void> _cancelAll() async {
    await _runBusy(() async {
      await NotificationService.cancelAll();
      _showMessage('تم إلغاء جميع التنبيهات المجدولة');
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textDirection: TextDirection.rtl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات والمنبهات')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _infoCard(context),
              const SizedBox(height: 14),
              _actionCard(
                context,
                icon: Icons.campaign_outlined,
                title: 'إرسال إشعار ذكر عام',
                subtitle: 'اضغط لإرسال ذكر عام فورًا مع صورة التطبيق واسم تذكر.',
                buttonText: 'إرسال الآن',
                onPressed: _sendGeneralNotification,
              ),
              const SizedBox(height: 12),
              _actionCard(
                context,
                icon: Icons.wb_sunny_outlined,
                title: 'وقت إشعار أذكار الصباح',
                subtitle: 'الوقت الحالي: ${_timeFromMinutes(_morningMinutes).format(context)}',
                buttonText: 'تحديد وقت الصباح',
                onPressed: _pickMorningTime,
              ),
              const SizedBox(height: 12),
              _actionCard(
                context,
                icon: Icons.nights_stay_outlined,
                title: 'وقت إشعار أذكار المساء',
                subtitle: 'الوقت الحالي: ${_timeFromMinutes(_eveningMinutes).format(context)}',
                buttonText: 'تحديد وقت المساء',
                onPressed: _pickEveningTime,
              ),
              const SizedBox(height: 12),
              _actionCard(
                context,
                icon: Icons.alarm_on_outlined,
                title: 'منبه صلاة الفجر',
                subtitle:
                    'الوقت الحالي: ${_timeFromMinutes(_fajrMinutes).format(context)} - قناة المنبه مجهزة لصوت الأذان.',
                buttonText: 'تحديد وقت الفجر',
                onPressed: _pickFajrTime,
                isHighlighted: true,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _cancelAll,
                  icon: const Icon(Icons.notifications_off_outlined),
                  label: const Text('إلغاء جميع التنبيهات'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          if (_isBusy)
            Container(
              color: Colors.black.withOpacity(0.08),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withOpacity(0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'سيستخدم التطبيق صورة 1.jpg في الإشعارات، واسم التطبيق الظاهر سيكون: تذكر.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
    bool isHighlighted = false,
  }) {
    return Card(
      elevation: isHighlighted ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isHighlighted ? AppTheme.gold : Theme.of(context).dividerColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: (isHighlighted ? AppTheme.gold : AppTheme.primary)
                      .withOpacity(0.14),
                  foregroundColor: isHighlighted ? AppTheme.gold : AppTheme.primary,
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.touch_app_outlined),
                label: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  backgroundColor: isHighlighted ? AppTheme.gold : AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
