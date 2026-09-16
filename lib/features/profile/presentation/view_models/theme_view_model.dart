import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile.dart';
import 'profile_view_model.dart' show profileRepositoryProvider;

/// Exposes the *effective* [ThemeMode] for the whole app (e.g. consumed by
/// `MaterialApp(themeMode: ref.watch(themeViewModelProvider))`). Kept
/// separate from [ProfileViewModel] so any widget in the tree can react to
/// theme changes without depending on the rest of the profile state.
///
/// Riverpod 3.x: `StateNotifierProvider`/`StateNotifier` are legacy APIs
/// (moved to `package:flutter_riverpod/legacy.dart`); we use `Notifier` /
/// `NotifierProvider` instead.
final themeViewModelProvider = NotifierProvider<ThemeViewModel, ThemeMode>(ThemeViewModel.new);

class ThemeViewModel extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // build() must stay synchronous — defer the repository read to a
    // microtask so it runs only once this provider has finished
    // initializing (see SystemInfoViewModel.build for the same pattern).
    Future.microtask(_loadInitial);
    return ThemeMode.system;
  }

  Future<void> _loadInitial() async {
    final profile = await ref.read(profileRepositoryProvider).getProfile();
    state = profile.themePreference.toThemeMode();
  }

  /// Persists the preference and immediately updates [state], which
  /// propagates the new theme across the whole app on the next frame.
  Future<void> setThemePreference(AppThemePreference preference) async {
    state = preference.toThemeMode();
    await ref.read(profileRepositoryProvider).updateThemePreference(preference);
  }
}
