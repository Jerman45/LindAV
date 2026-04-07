import 'package:flutter/material.dart';

import 'intro_page.dart';
import 'theme_controller.dart';
import 'widgets/page_route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    _footerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _ctrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppTheme.of(context).setThemeMode(ThemeMode.light);
    });
    _goToHome();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _goToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(appPageRoute(const IntroPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => Container(
          decoration: const BoxDecoration(gradient: AppColors.brandGradient),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Animated logo ──
                Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon.png',
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // ── Animated title ──
                Opacity(
                  opacity: _textOpacity.value,
                  child: Column(
                    children: [
                      Text(
                        'LindAV',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Security Suite',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withAlpha(200),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Protecting your device...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // ── Spinner ──
                Opacity(
                  opacity: _footerOpacity.value,
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // ── Footer ──
                Opacity(
                  opacity: _footerOpacity.value,
                  child: Text(
                    'JERMAN TECHNOLOGY',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withAlpha(150),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
