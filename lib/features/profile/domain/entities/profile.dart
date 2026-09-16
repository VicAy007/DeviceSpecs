import 'package:flutter/material.dart';

/// User-facing theme preference. Distinct from Flutter's [ThemeMode] so the
/// domain layer has no Flutter dependency — mapped at the presentation
/// boundary.
enum AppThemePreference { light, dark, system }

extension AppThemePreferenceX on AppThemePreference {
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }

  static AppThemePreference fromName(String name) {
    return AppThemePreference.values.firstWhere(
      (e) => e.name == name,
      orElse: () => AppThemePreference.system,
    );
  }
}

/// User profile and app-level preferences.
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.themePreference = AppThemePreference.system,
    this.notificationsEnabled = true,
    this.language = 'fr',
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final AppThemePreference themePreference;
  final bool notificationsEnabled;
  final String language;

  Profile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    AppThemePreference? themePreference,
    bool? notificationsEnabled,
    String? language,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      themePreference: themePreference ?? this.themePreference,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}
