import 'package:flutter/material.dart';

import 'device_performance_page.dart';
import 'intro_page.dart';
import 'network_status_page.dart';
import 'scan_page.dart';
import 'services/network_service.dart';
import 'settings_page.dart';
import 'tests_page.dart';
import 'theme_controller.dart';
import 'widgets/page_route.dart';
import 'widgets/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScanResult? _latestScan;

  @override
  void initState() {
    super.initState();
    _refreshLatestScan();
  }

  Future<void> _refreshLatestScan() async {
    try {
      final result = await loadLatestScanResult();
      if (mounted) setState(() => _latestScan = result);
    } catch (error, stackTrace) {
      debugPrint('Could not load the latest scan: $error\n$stackTrace');
    }
  }

  Future<void> _openScan() async {
    await Navigator.of(context).push(appPageRoute(const ScanPage()));
    await _refreshLatestScan();
  }

  Future<void> _openSettings() async {
    final result = await Navigator.of(context).push<SettingsResult>(
      appPageRoute(
        SettingsPage(
          autoScanUsb: false,
          deepScan: false,
          themeMode: AppTheme.of(context).themeMode,
        ),
      ),
    );
    if (!mounted || result == null) return;
    AppTheme.of(context).setThemeMode(result.themeMode);
  }

  void _toggleTheme() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    AppTheme.of(
      context,
    ).setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.28,
              decoration: BoxDecoration(
                gradient: AppColors.gradientFor(context),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Top bar with back button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back to intro button
                          TextButton.icon(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushReplacement(appPageRoute(const IntroPage())),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withAlpha(30),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.security,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'LindAV',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? 'Switch to light theme'
                                    : 'Switch to dark theme',
                                onPressed: _toggleTheme,
                                icon: Icon(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Icons.light_mode_outlined
                                      : Icons.dark_mode_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              IconButton(
                                tooltip: 'Settings',
                                onPressed: _openSettings,
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Welcome text
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your device is protected',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Positioned(
            top: size.height * 0.24,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: ResponsiveBody(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _FeatureCard(
                        icon: Icons.shield_moon,
                        title: 'Run a Scan',
                        description:
                            'Launch quick, full, or USB scans to detect suspicious activity.',
                        gradient: const LinearGradient(
                          colors: [AppColors.emerald, AppColors.green],
                        ),
                        onTap: _openScan,
                      ),
                      const SizedBox(height: 12),
                      _FeatureCard(
                        icon: Icons.security,
                        title: 'Security Center',
                        description:
                            'Manage account protection, sessions, and privacy settings.',
                        gradient: const LinearGradient(
                          colors: [AppColors.green, AppColors.teal],
                        ),
                        onTap: () => Navigator.of(
                          context,
                        ).push(appPageRoute(const TestsPage())),
                      ),
                      const SizedBox(height: 12),
                      _FeatureCard(
                        icon: Icons.wifi_tethering,
                        title: 'Network Status',
                        description:
                            'Inspect connection, run speed tests, and scan WiFi networks.',
                        gradient: const LinearGradient(
                          colors: [AppColors.teal, AppColors.deepTeal],
                        ),
                        onTap: () => Navigator.of(
                          context,
                        ).push(appPageRoute(const NetworkStatusPage())),
                      ),
                      const SizedBox(height: 12),
                      _FeatureCard(
                        icon: Icons.speed,
                        title: 'Device Performance',
                        description:
                            'Monitor CPU, memory, storage, battery, and network usage.',
                        gradient: const LinearGradient(
                          colors: [AppColors.deepTeal, Color(0xFF0891B2)],
                        ),
                        onTap: () => Navigator.of(
                          context,
                        ).push(appPageRoute(const DevicePerformancePage())),
                      ),
                      const SizedBox(height: 24),
                      _SectionHeading(
                        title: 'Recent Scan',
                        actionLabel: 'View all',
                        onAction: _openScan,
                      ),
                      const SizedBox(height: 12),
                      _RecentScanCard(result: _latestScan, onTap: _openScan),
                      const SizedBox(height: 24),
                      _SectionHeading(
                        title: 'Alerts',
                        actionLabel: 'View scans',
                        onAction: _openScan,
                      ),
                      const SizedBox(height: 12),
                      _AlertsCard(latest: _latestScan, onTap: _openScan),
                      const SizedBox(height: 24),
                      _SectionHeading(
                        title: 'Quick Device Stats',
                        actionLabel: 'Open monitor',
                        onAction: () => Navigator.of(
                          context,
                        ).push(appPageRoute(const DevicePerformancePage())),
                      ),
                      const SizedBox(height: 12),
                      _QuickDeviceStats(
                        latest: _latestScan,
                        onTap: () => Navigator.of(
                          context,
                        ).push(appPageRoute(const DevicePerformancePage())),
                      ),
                      const SizedBox(height: 24),
                      // Status card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withAlpha(20),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.emerald.withAlpha(50),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.emerald.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: AppColors.emerald,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Protection Active',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.emerald,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'All security features are enabled',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.emerald.withAlpha(180),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}

class _RecentScanCard extends StatelessWidget {
  const _RecentScanCard({required this.result, required this.onTap});

  final ScanResult? result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasThreats = (result?.threatsFound ?? 0) > 0;
    final iconColor = hasThreats ? colorScheme.error : AppColors.emerald;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: iconColor.withAlpha(24),
          child: Icon(
            hasThreats ? Icons.warning_amber_rounded : Icons.shield_outlined,
            color: iconColor,
          ),
        ),
        title: Text(result?.type ?? 'No scans yet'),
        subtitle: Text(
          result == null
              ? 'Run a scan to see its summary here.'
              : '${result!.scannedFiles} files checked · ${_formatAge(result!.dateTime)}',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard({required this.latest, required this.onTap});

  final ScanResult? latest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final threatsFound = latest?.threatsFound ?? 0;
    final hasAlerts = threatsFound > 0;
    final color = hasAlerts ? colorScheme.error : AppColors.emerald;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          hasAlerts
              ? Icons.notifications_active_outlined
              : Icons.notifications_none_outlined,
          color: color,
        ),
        title: Text(
          hasAlerts
              ? '$threatsFound threat${threatsFound == 1 ? '' : 's'} found'
              : 'No active alerts',
        ),
        subtitle: Text(
          latest == null
              ? 'Run a scan to check for threats.'
              : hasAlerts
              ? 'Detected in your most recent scan.'
              : 'Your most recent scan found no threats.',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _QuickDeviceStats extends StatelessWidget {
  const _QuickDeviceStats({required this.latest, required this.onTap});

  final ScanResult? latest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder(
            stream: NetworkService().statusStream,
            initialData: NetworkService().currentStatus,
            builder: (context, snapshot) {
              final networkStatus = snapshot.data;
              return Row(
                children: [
                  Expanded(
                    child: _QuickStat(
                      label: 'Files checked',
                      value: latest == null
                          ? '—'
                          : latest!.scannedFiles.toString(),
                      icon: Icons.folder_open_outlined,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickStat(
                      label: 'Threats',
                      value: latest == null
                          ? '—'
                          : latest!.threatsFound.toString(),
                      icon: Icons.shield_outlined,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickStat(
                      label: 'Network',
                      value: networkStatus?.isConnected == true
                          ? 'Online'
                          : 'Offline',
                      icon: networkStatus?.isConnected == true
                          ? Icons.wifi
                          : Icons.wifi_off,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

String _formatAge(DateTime dateTime) {
  final age = DateTime.now().difference(dateTime);
  if (age.inMinutes < 1) return 'Just now';
  if (age.inHours < 1) return '${age.inMinutes}m ago';
  if (age.inDays < 1) return '${age.inHours}h ago';
  if (age.inDays == 1) return 'Yesterday';
  return '${age.inDays}d ago';
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 12,
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
