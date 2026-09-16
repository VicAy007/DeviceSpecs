import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../services/profile_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileService profileService}) : _profileService = profileService;

  final ProfileService _profileService;

  @override
  Future<Profile> getProfile() => _profileService.getProfile();

  @override
  Future<void> updateThemePreference(AppThemePreference preference) =>
      _profileService.saveThemePreference(preference);

  @override
  Future<void> updateNotificationsEnabled(bool enabled) =>
      _profileService.saveNotificationsEnabled(enabled);

  @override
  Future<void> updateLanguage(String languageCode) => _profileService.saveLanguage(languageCode);

  @override
  Future<void> logout() => _profileService.clearLocalProfileCache();
}
