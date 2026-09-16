import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/profile/presentation/view_models/theme_view_model.dart';
import '../features/system_info/presentation/pages/system_info_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import 'theme/app_colors.dart';

/// Root widget. Demonstrates how `system_info` and `profile` plug into the
/// app shell: [themeViewModelProvider] drives `MaterialApp.themeMode`, so a
/// change from the Profile page's ThemeSelector is reflected everywhere on
/// the very next frame — no restart, no manual propagation.
class DeviceSpecsApp extends ConsumerWidget {
  const DeviceSpecsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeViewModelProvider);

    return MaterialApp(
      title: 'DeviceSpecs',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
      ),
      // Sign Up / Login / Dashboard and the bottom navigation shell are
      // out of scope for this task — wire `home` to the app's router once
      // the `authentication` and `dashboard` features exist.
      home: const _DevPreviewTabs(),
    );
  }
}

/// Temporary two-tab shell purely so `system_info` and `profile` can be
/// previewed together during development, before the real router exists.
class _DevPreviewTabs extends StatefulWidget {
  const _DevPreviewTabs();

  @override
  State<_DevPreviewTabs> createState() => _DevPreviewTabsState();
}

class _DevPreviewTabsState extends State<_DevPreviewTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const DashboardPage(), const SystemInfoPage(), const ProfilePage()];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.memory), label: 'System Info'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
