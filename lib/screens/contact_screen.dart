import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String supportEmail = 'support@tazakkar.app';
  static const String appName = 'تذكر';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تواصل معنا')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_outlined,
                      color: AppTheme.primary,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    appName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'يسعدنا استقبال اقتراحاتك وملاحظاتك لتطوير التطبيق.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.68),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEAF5EE),
                    foregroundColor: AppTheme.primary,
                    child: Icon(Icons.email_outlined),
                  ),
                  title: const Text('البريد الإلكتروني'),
                  subtitle: const Text(supportEmail, textDirection: TextDirection.ltr),
                  onTap: () => _openMail(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEAF5EE),
                    foregroundColor: AppTheme.primary,
                    child: Icon(Icons.copy_outlined),
                  ),
                  title: const Text('نسخ بيانات التواصل'),
                  subtitle: const Text('نسخ البريد الإلكتروني إلى الحافظة'),
                  onTap: () => _copyEmail(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openMail(context),
              icon: const Icon(Icons.send_outlined),
              label: const Text('إرسال رسالة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: Uri.encodeFull('subject=ملاحظات حول تطبيق $appName'),
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _copyEmail(context);
    }
  }

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: supportEmail));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ البريد الإلكتروني', textDirection: TextDirection.rtl)),
    );
  }
}
