import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Brand colors ──────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color emerald = Color(0xFF059669);
  static const Color green = Color(0xFF10B981);
  static const Color teal = Color(0xFF14B8A6);
  static const Color deepTeal = Color(0xFF0D9488);
  static const Color deepEmerald = Color(0xFF047857);
  static const Color darkEmerald = Color(0xFF065F46);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emerald, green, teal],
  );

  static const LinearGradient darkBrandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF0D6E5F)],
  );

  /// Returns the appropriate brand gradient for the current brightness.
  static LinearGradient gradientFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBrandGradient
        : brandGradient;
  }
}

// ── Theme builder ─────────────────────────────────────────────────────
class AppThemeData {
  AppThemeData._();

  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    return GoogleFonts.interTextTheme(base);
  }

  static ThemeData light() {
    final textTheme = _textTheme(Brightness.light);
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.emerald,
        brightness: Brightness.light,
      ),
      textTheme: textTheme,
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  static ThemeData dark() {
    final textTheme = _textTheme(Brightness.dark);
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.emerald,
        brightness: Brightness.dark,
      ),
      textTheme: textTheme,
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

// ── Theme persistence ─────────────────────────────────────────────────
class ThemePrefs {
  static const _key = 'theme_mode';

  static Future<ThemeMode> load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index == null || index < 0 || index >= ThemeMode.values.length) {
      return ThemeMode.light;
    }
    return ThemeMode.values[index];
  }

  static Future<void> save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, mode.index);
  }
}

// ── InheritedWidget (unchanged API) ───────────────────────────────────
class AppTheme extends InheritedWidget {
  const AppTheme({
    super.key,
    required super.child,
    required this.themeMode,
    required this.setThemeMode,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> setThemeMode;

  static AppTheme of(BuildContext context) {
    final AppTheme? result = context
        .dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(result != null, 'AppTheme is not available in the current context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) =>
      themeMode != oldWidget.themeMode;
}
