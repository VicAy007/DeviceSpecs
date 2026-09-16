import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_models/profile_view_model.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_selector.dart';

/// Profile screen. Listens for [ProfileState.isLoggedOut] to trigger
/// navigation back to the authentication flow — the actual route name is
/// left to the app's router (see `app/router/route_names.dart`).
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key, this.onLoggedOut});

  /// Called once logout completes, so the host app can navigate to
  /// `/login` without this feature depending on the router directly.
  final VoidCallback? onLoggedOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.isLoggedOut && previous?.isLoggedOut != true) {
        onLoggedOut?.call();
      }
    });

    final state = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: _buildBody(context, state, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state, ProfileViewModel viewModel) {
    if (state.hasError) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [AppErrorWidget(message: state.errorMessage!, onRetry: viewModel.load)],
      );
    }

    if (state.isLoading || state.profile == null) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: const [
          LoadingWidget(height: 96, lines: 1),
          SizedBox(height: AppSpacing.md),
          LoadingWidget(height: 140, lines: 3),
          SizedBox(height: AppSpacing.md),
          LoadingWidget(height: 100, lines: 2),
        ],
      );
    }

    final profile = state.profile!;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        ProfileHeader(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ThemeSelector(
          selected: profile.themePreference,
          onChanged: viewModel.setThemePreference,
        ),
        const SizedBox(height: AppSpacing.md),
        SettingsSection(
          notificationsEnabled: profile.notificationsEnabled,
          onNotificationsChanged: viewModel.setNotificationsEnabled,
          language: profile.language,
          onLanguageChanged: viewModel.setLanguage,
        ),
        const SizedBox(height: AppSpacing.lg),
        LogoutButton(onConfirmedLogout: viewModel.logout),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
