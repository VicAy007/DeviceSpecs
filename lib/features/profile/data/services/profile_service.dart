import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/profile.dart';

/// Local persistence for profile preferences (theme, notifications,
/// language). The identity fields (name/email/avatar) are expected to come
/// from the `authentication` feature's session once wired up; here they are
/// cached locally so the Profile page has something to render and to keep
/// this feature independently testable.
class ProfileService {
  ProfileService({SharedPreferences? preferences}) : _preferencesOverride = preferences;

  final SharedPreferences? _preferencesOverride;

  static const _keyId = 'profile.id';
  static const _keyName = 'profile.name';
  static const _keyEmail = 'profile.email';
  static const _keyAvatarUrl = 'profile.avatarUrl';
  static const _keyTheme = 'profile.themePreference';
  static const _keyNotifications = 'profile.notificationsEnabled';
  static const _keyLanguage = 'profile.language';

  Future<SharedPreferences> _prefs() async =>
      _preferencesOverride ?? await SharedPreferences.getInstance();

  Future<Profile> getProfile() async {
    final prefs = await _prefs();
    return Profile(
      id: prefs.getString(_keyId) ?? 'local-user',
      name: prefs.getString(_keyName) ?? 'Utilisateur DeviceSpecs',
      email: prefs.getString(_keyEmail) ?? 'user@devicespecs.app',
      avatarUrl: prefs.getString(_keyAvatarUrl),
      themePreference: AppThemePreferenceX.fromName(prefs.getString(_keyTheme) ?? AppThemePreference.system.name),
      notificationsEnabled: prefs.getBool(_keyNotifications) ?? true,
      language: prefs.getString(_keyLanguage) ?? 'fr',
    );
  }

  Future<void> saveThemePreference(AppThemePreference preference) async {
    final prefs = await _prefs();
    await prefs.setString(_keyTheme, preference.name);
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    final prefs = await _prefs();
    await prefs.setBool(_keyNotifications, enabled);
  }

  Future<void> saveLanguage(String languageCode) async {
    final prefs = await _prefs();
    await prefs.setString(_keyLanguage, languageCode);
  }

  /// Clears locally cached session/preferences data. The actual session
  /// invalidation (tokens, etc.) belongs to the `authentication` feature's
  /// AuthRepository, which should be called alongside this in the
  /// ViewModel/use-case that composes logout.
  Future<void> clearLocalProfileCache() async {
    final prefs = await _prefs();
    await Future.wait([
      prefs.remove(_keyId),
      prefs.remove(_keyName),
      prefs.remove(_keyEmail),
      prefs.remove(_keyAvatarUrl),
    ]);
  }
}
