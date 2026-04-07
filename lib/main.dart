import 'package:flutter/material.dart';

import 'services/network_service.dart';
import 'splash_page.dart';
import 'theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetworkService().initialize();
  final savedTheme = await ThemePrefs.load();
  runApp(LindavSecurityApp(initialTheme: savedTheme));
}

class LindavSecurityApp extends StatefulWidget {
  const LindavSecurityApp({super.key, this.initialTheme = ThemeMode.light});
  final ThemeMode initialTheme;

  @override
  State<LindavSecurityApp> createState() => _LindavSecurityAppState();
}

class _LindavSecurityAppState extends State<LindavSecurityApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialTheme;
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    ThemePrefs.save(mode);
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      themeMode: _themeMode,
      setThemeMode: _setThemeMode,
      child: MaterialApp(
        title: 'Lindav Security',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.light(),
        darkTheme: AppThemeData.dark(),
        themeMode: _themeMode,
        home: const SplashPage(),
      ),
    );
  }
}
