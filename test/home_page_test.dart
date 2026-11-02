import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lindav/home_page.dart';
import 'package:lindav/theme_controller.dart';

void main() {
  testWidgets('dashboard shows scan, alert, and device summaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppTheme(
        themeMode: ThemeMode.light,
        setThemeMode: (_) {},
        child: MaterialApp(theme: AppThemeData.light(), home: const HomePage()),
      ),
    );

    expect(find.text('Recent Scan'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Quick Device Stats'), findsOneWidget);
    expect(find.text('No scans yet'), findsOneWidget);
  });

  testWidgets('dashboard theme toggle switches to dark mode', (tester) async {
    ThemeMode? selectedTheme;
    await tester.pumpWidget(
      AppTheme(
        themeMode: ThemeMode.light,
        setThemeMode: (mode) => selectedTheme = mode,
        child: MaterialApp(theme: AppThemeData.light(), home: const HomePage()),
      ),
    );

    await tester.tap(find.byTooltip('Switch to dark theme'));
    expect(selectedTheme, ThemeMode.dark);
  });
}
