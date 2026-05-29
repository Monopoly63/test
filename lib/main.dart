import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const TazakkarApp());
}

class TazakkarApp extends StatefulWidget {
  const TazakkarApp({super.key});

  @override
  State<TazakkarApp> createState() => _TazakkarAppState();
}

class _TazakkarAppState extends State<TazakkarApp> {
  late bool _isDark;
  late double _fontScale;
  late String _fontFamily;

  @override
  void initState() {
    super.initState();
    _isDark = StorageService.getDarkMode();
    _fontScale = StorageService.getFontScale();
    _fontFamily = StorageService.getFontFamily();
  }

  void toggleTheme() {
    setState(() {
      _isDark = !_isDark;
      StorageService.saveDarkMode(_isDark);
    });
  }

  void changeFontScale(double value) {
    setState(() => _fontScale = value);
    StorageService.saveFontScale(value);
  }

  void changeFontFamily(String value) {
    setState(() => _fontFamily = value);
    StorageService.saveFontFamily(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تذكر',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(fontFamily: _fontFamily),
      darkTheme: AppTheme.darkTheme(fontFamily: _fontFamily),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaleFactor: _fontScale),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
      home: HomeScreen(
        isDark: _isDark,
        fontScale: _fontScale,
        fontFamily: _fontFamily,
        onToggleTheme: toggleTheme,
        onFontScaleChanged: changeFontScale,
        onFontFamilyChanged: changeFontFamily,
      ),
    );
  }
}