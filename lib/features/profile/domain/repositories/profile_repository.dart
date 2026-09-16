import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  Future<void> updateThemePreference(AppThemePreference preference);
  Future<void> updateNotificationsEnabled(bool enabled);
  Future<void> updateLanguage(String languageCode);
  Future<void> logout();
}
