import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const HisnAlMuslimApp());
}

class HisnAlMuslimApp extends StatefulWidget {
  const HisnAlMuslimApp({super.key});

  @override
  State<HisnAlMuslimApp> createState() => _HisnAlMuslimAppState();
}

class _HisnAlMuslimAppState extends State<HisnAlMuslimApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = StorageService.getDarkMode();
  }

  void toggleTheme() {
    setState(() {
      _isDark = !_isDark;
      StorageService.saveDarkMode(_isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حصن المسلم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: HomeScreen(
        isDark: _isDark,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}