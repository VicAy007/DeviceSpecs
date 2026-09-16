import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_specs/features/profile/domain/entities/profile.dart';
import 'package:device_specs/features/profile/domain/repositories/profile_repository.dart';
import 'package:device_specs/features/profile/presentation/pages/profile_page.dart';
import 'package:device_specs/features/profile/presentation/view_models/profile_view_model.dart';

class FakeProfileRepository implements ProfileRepository {
  Profile _profile = const Profile(id: '1', name: 'Ada Lovelace', email: 'ada@devicespecs.app');
  bool loggedOut = false;

  @override
  Future<Profile> getProfile() async => _profile;

  @override
  Future<void> updateThemePreference(AppThemePreference preference) async {
    _profile = _profile.copyWith(themePreference: preference);
  }

  @override
  Future<void> updateNotificationsEnabled(bool enabled) async {
    _profile = _profile.copyWith(notificationsEnabled: enabled);
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    _profile = _profile.copyWith(language: languageCode);
  }

  @override
  Future<void> logout() async {
    loggedOut = true;
  }
}

void main() {
  testWidgets('renders profile header, theme options and settings', (tester) async {
    final repository = FakeProfileRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: ProfilePage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('ada@devicespecs.app'), findsOneWidget);
    expect(find.text('Mode clair'), findsOneWidget);
    expect(find.text('Mode sombre'), findsOneWidget);
    expect(find.text('Mode système'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
  });

  testWidgets('selecting dark mode persists the new theme preference', (tester) async {
    final repository = FakeProfileRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mode sombre'));
    await tester.pumpAndSettle();

    expect((await repository.getProfile()).themePreference, AppThemePreference.dark);
  });

  testWidgets('confirming logout calls the repository', (tester) async {
    final repository = FakeProfileRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Déconnexion'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Se déconnecter'));
    await tester.pumpAndSettle();

    expect(repository.loggedOut, isTrue);
  });
}
