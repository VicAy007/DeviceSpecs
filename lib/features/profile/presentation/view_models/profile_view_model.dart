import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/services/profile_service.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'theme_view_model.dart';

final profileServiceProvider = Provider<ProfileService>((ref) => ProfileService());

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(profileService: ref.watch(profileServiceProvider));
});

/// Riverpod 3.x: `StateNotifierProvider`/`StateNotifier` are legacy APIs
/// (moved to `package:flutter_riverpod/legacy.dart`); we use `Notifier` /
/// `NotifierProvider` instead.
final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);

class ProfileState {
  const ProfileState({
    this.isLoading = true,
    this.errorMessage,
    this.profile,
    this.isLoggedOut = false,
  });

  final bool isLoading;
  final String? errorMessage;
  final Profile? profile;
  final bool isLoggedOut;

  bool get hasError => errorMessage != null;

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    Profile? profile,
    bool? isLoggedOut,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      profile: profile ?? this.profile,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }
}

/// Handles the user-info + settings side of the Profile page. Theme changes
/// are delegated to [ThemeViewModel] (via [ref]) so the app-wide theme
/// updates immediately, while this ViewModel keeps its own copy of the
/// profile in sync for the UI (e.g. the selected radio in ThemeSelector).
class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    // build() must stay synchronous and side-effect free — the initial
    // load is deferred to a microtask (see SystemInfoViewModel.build for
    // the same pattern and rationale).
    Future.microtask(load);
    return const ProfileState();
  }

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> setThemePreference(AppThemePreference preference) async {
    final current = state.profile;
    if (current == null) return;
    // Optimistic update for a snappy UI, then persist through the repo.
    state = state.copyWith(profile: current.copyWith(themePreference: preference));
    await ref.read(themeViewModelProvider.notifier).setThemePreference(preference);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final current = state.profile;
    if (current == null) return;
    state = state.copyWith(profile: current.copyWith(notificationsEnabled: enabled));
    await _repository.updateNotificationsEnabled(enabled);
  }

  Future<void> setLanguage(String languageCode) async {
    final current = state.profile;
    if (current == null) return;
    state = state.copyWith(profile: current.copyWith(language: languageCode));
    await _repository.updateLanguage(languageCode);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(isLoggedOut: true);
  }
}
