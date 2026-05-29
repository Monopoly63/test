import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_theme.dart';
import 'contact_screen.dart';
import 'notifications_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDark;
  final double fontScale;
  final String fontFamily;
  final VoidCallback onToggleTheme;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<String> onFontFamilyChanged;

  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.fontScale,
    required this.fontFamily,
    required this.onToggleTheme,
    required this.onFontScaleChanged,
    required this.onFontFamilyChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _packageName = 'com.hisnalmuslim.app';
  static const String _shareLink =
      'https://play.google.com/store/apps/details?id=$_packageName';

  late bool _isDark;
  late double _fontScale;
  late String _fontFamily;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
    _fontScale = widget.fontScale;
    _fontFamily = widget.fontFamily;
  }

  void _changeFontScale(double value) {
    setState(() => _fontScale = value);
    widget.onFontScaleChanged(value);
  }

  void _changeFontFamily(String value) {
    setState(() => _fontFamily = value);
    widget.onFontFamilyChanged(value);
  }

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
    widget.onToggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'المظهر'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(_isDark ? Icons.dark_mode : Icons.light_mode),
                  title: const Text('الوضع الليلي'),
                  value: _isDark,
                  onChanged: (_) => _toggleTheme(),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.format_size),
                          const SizedBox(width: 10),
                          const Expanded(child: Text('حجم الخط داخل التطبيق')),
                          Text('${(_fontScale * 100).round()}%'),
                        ],
                      ),
                      Slider(
                        value: _fontScale,
                        min: 0.85,
                        max: 1.45,
                        divisions: 12,
                        label: '${(_fontScale * 100).round()}%',
                        onChanged: _changeFontScale,
                        activeColor: AppTheme.primary,
                      ),
                      Text(
                        'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: AppTheme.supportedFonts.contains(_fontFamily)
                        ? _fontFamily
                        : AppTheme.supportedFonts.first,
                    decoration: InputDecoration(
                      labelText: 'نوع الخط',
                      prefixIcon: const Icon(Icons.font_download_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: AppTheme.supportedFonts
                        .map(
                          (font) => DropdownMenuItem(
                            value: font,
                            child: Text(font),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) _changeFontFamily(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _sectionTitle(context, 'التنبيهات والتواصل'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                _actionTile(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: 'الإشعارات والمنبهات',
                  subtitle: 'أذكار عامة، صباح ومساء، ومنبه الفجر',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  ),
                ),
                const Divider(height: 1),
                _actionTile(
                  context,
                  icon: Icons.support_agent_outlined,
                  title: 'تواصل معنا',
                  subtitle: 'راسل فريق التطبيق أو انسخ بيانات التواصل',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactScreen()),
                  ),
                ),
                const Divider(height: 1),
                _actionTile(
                  context,
                  icon: Icons.star_rate_outlined,
                  title: 'تقييم التطبيق',
                  subtitle: 'ادعمنا بتقييمك على المتجر',
                  onTap: () => _rateApp(context),
                ),
                const Divider(height: 1),
                _actionTile(
                  context,
                  icon: Icons.ios_share_outlined,
                  title: 'مشاركة التطبيق',
                  subtitle: 'أرسل رابط التطبيق للأصدقاء',
                  onTap: _shareApp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      minVerticalPadding: 14,
      leading: CircleAvatar(
        backgroundColor: AppTheme.primary.withOpacity(0.12),
        foregroundColor: AppTheme.primary,
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_left),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    final review = InAppReview.instance;
    try {
      if (await review.isAvailable()) {
        await review.requestReview();
        return;
      }
      await review.openStoreListing();
    } catch (_) {
      final marketUri = Uri.parse('market://details?id=$_packageName');
      final webUri = Uri.parse(_shareLink);
      if (!await launchUrl(marketUri, mode: LaunchMode.externalApplication)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _shareApp() {
    Share.share(
      'حمّل تطبيق تذكر للأذكار والأدعية:\n$_shareLink',
      subject: 'تطبيق تذكر',
    );
  }
}
