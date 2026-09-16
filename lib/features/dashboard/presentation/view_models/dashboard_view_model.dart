import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device_health.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../../system_info/presentation/view_models/system_info_view_model.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    systemInfoRepository: ref.read(systemInfoRepositoryProvider),
  );
});

final dashboardViewModelProvider =
    NotifierProvider<DashboardViewModel, DashboardState>(DashboardViewModel.new);

enum DashboardStatus { loading, loaded, error }

class DashboardState {
  const DashboardState({
    this.status = DashboardStatus.loading,
    this.data,
    this.errorMessage,
  });

  final DashboardStatus status;
  final DeviceHealth? data;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    DeviceHealth? data,
    String? errorMessage,
  }) => DashboardState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: errorMessage,
      );
}

class DashboardViewModel extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future.microtask(load);
    return const DashboardState();
  }

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(status: DashboardStatus.loading, errorMessage: null);
    try {
      final data = await _repository.getDeviceHealth();
      state = DashboardState(status: DashboardStatus.loaded, data: data);
    } catch (e) {
      state = DashboardState(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() => load();

  void runQuickScan() {}
  void runSensorCheck() {}
}
