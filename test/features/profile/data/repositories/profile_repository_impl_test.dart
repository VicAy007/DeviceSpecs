import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:device_specs/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:device_specs/features/profile/data/services/profile_service.dart';
import 'package:device_specs/features/profile/domain/entities/profile.dart';

class MockProfileService extends Mock implements ProfileService {}

void main() {
  late MockProfileService service;
  late ProfileRepositoryImpl repository;

  const profile = Profile(id: '1', name: 'Ada', email: 'ada@devicespecs.app');

  setUp(() {
    service = MockProfileService();
    repository = ProfileRepositoryImpl(profileService: service);
  });

  test('getProfile delegates to ProfileService', () async {
    when(() => service.getProfile()).thenAnswer((_) async => profile);

    final result = await repository.getProfile();

    expect(result, profile);
  });

  test('updateThemePreference persists through the service', () async {
    when(() => service.saveThemePreference(any())).thenAnswer((_) async {});

    await repository.updateThemePreference(AppThemePreference.dark);

    verify(() => service.saveThemePreference(AppThemePreference.dark)).called(1);
  });

  test('logout clears the local profile cache', () async {
    when(() => service.clearLocalProfileCache()).thenAnswer((_) async {});

    await repository.logout();

    verify(() => service.clearLocalProfileCache()).called(1);
  });
}
