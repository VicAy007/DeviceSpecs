import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:device_specs/features/profile/domain/entities/profile.dart';
import 'package:device_specs/features/profile/domain/repositories/profile_repository.dart';
import 'package:device_specs/features/profile/presentation/view_models/profile_view_model.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late ProviderContainer container;

  const profile = Profile(id: '1', name: 'Ada Lovelace', email: 'ada@devicespecs.app');

  setUpAll(() {
    registerFallbackValue(AppThemePreference.system);
  });

  setUp(() {
    repository = MockProfileRepository();
    when(() => repository.getProfile()).thenAnswer((_) async => profile);
    when(() => repository.updateThemePreference(any())).thenAnswer((_) async {});
    when(() => repository.updateNotificationsEnabled(any())).thenAnswer((_) async {});
    when(() => repository.updateLanguage(any())).thenAnswer((_) async {});
    when(() => repository.logout()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  test('load populates the profile from the repository', () async {
    final viewModel = container.read(profileViewModelProvider.notifier);
    await viewModel.load();

    final state = container.read(profileViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.profile, profile);
  });

  test('setNotificationsEnabled optimistically updates state and persists', () async {
    final viewModel = container.read(profileViewModelProvider.notifier);
    await viewModel.load();

    await viewModel.setNotificationsEnabled(false);

    expect(container.read(profileViewModelProvider).profile!.notificationsEnabled, isFalse);
    verify(() => repository.updateNotificationsEnabled(false)).called(1);
  });

  test('logout clears session and flips isLoggedOut', () async {
    final viewModel = container.read(profileViewModelProvider.notifier);
    await viewModel.load();

    await viewModel.logout();

    expect(container.read(profileViewModelProvider).isLoggedOut, isTrue);
    verify(() => repository.logout()).called(1);
  });
}
