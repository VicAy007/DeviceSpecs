import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/system_info_repository_impl.dart';
import '../../data/services/battery_service.dart';
import '../../data/services/device_info_service.dart';
import '../../data/services/network_service.dart';
import '../../data/services/sensor_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/system_service.dart';
import '../../domain/entities/battery_info.dart';
import '../../domain/entities/cpu_info.dart';
import '../../domain/entities/device_info.dart';
import '../../domain/entities/display_info.dart';
import '../../domain/entities/gpu_info.dart';
import '../../domain/entities/memory_info.dart';
import '../../domain/entities/network_info.dart';
import '../../domain/entities/sensor_info.dart';
import '../../domain/entities/storage_info.dart';
import '../../domain/repositories/system_info_repository.dart';
import '../../../../services/native/battery_platform_service.dart';
import '../../../../services/native/device_platform_service.dart';
import '../../../../services/native/storage_platform_service.dart';
import '../../../../services/native/system_platform_service.dart';

/// DI wiring for the feature. Kept close to the ViewModel provider so the
/// whole dependency graph for `system_info` is visible in one place.
final systemInfoRepositoryProvider = Provider<SystemInfoRepository>((ref) {
  return SystemInfoRepositoryImpl(
    deviceInfoService: DeviceInfoService(platformService: DevicePlatformService()),
    batteryService: BatteryService(batteryPlatformService: BatteryPlatformService()),
    storageService: StorageService(storagePlatformService: StoragePlatformService()),
    systemService: SystemService(systemPlatformService: SystemPlatformService()),
    networkService: NetworkService(),
    sensorService: const SensorService(),
  );
});

/// Riverpod 3.x: `StateNotifierProvider`/`StateNotifier` are legacy APIs
/// (moved to `package:flutter_riverpod/legacy.dart`). We use `Notifier` /
/// `NotifierProvider` instead, which is the current, non-deprecated way to
/// expose mutable state with methods.
final systemInfoViewModelProvider =
    NotifierProvider<SystemInfoViewModel, SystemInfoState>(SystemInfoViewModel.new);

/// Immutable UI state for the System Info page. Each section is nullable
/// while loading; once loaded, the entity itself carries the per-field
/// availability status (see [SysValue]) so widgets never see a "hole".
class SystemInfoState {
  const SystemInfoState({
    this.isLoading = true,
    this.errorMessage,
    this.deviceInfo,
    this.cpuInfo,
    this.gpuInfo,
    this.memoryInfo,
    this.storageInfo,
    this.batteryInfo,
    this.displayInfo,
    this.networkInfo,
    this.sensorInfo,
  });

  final bool isLoading;
  final String? errorMessage;
  final DeviceInfo? deviceInfo;
  final CpuInfo? cpuInfo;
  final GpuInfo? gpuInfo;
  final MemoryInfo? memoryInfo;
  final StorageInfo? storageInfo;
  final BatteryInfo? batteryInfo;
  final DisplayInfo? displayInfo;
  final NetworkInfo? networkInfo;
  final SensorInfo? sensorInfo;

  bool get hasError => errorMessage != null;

  SystemInfoState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    DeviceInfo? deviceInfo,
    CpuInfo? cpuInfo,
    GpuInfo? gpuInfo,
    MemoryInfo? memoryInfo,
    StorageInfo? storageInfo,
    BatteryInfo? batteryInfo,
    DisplayInfo? displayInfo,
    NetworkInfo? networkInfo,
    SensorInfo? sensorInfo,
  }) {
    return SystemInfoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      deviceInfo: deviceInfo ?? this.deviceInfo,
      cpuInfo: cpuInfo ?? this.cpuInfo,
      gpuInfo: gpuInfo ?? this.gpuInfo,
      memoryInfo: memoryInfo ?? this.memoryInfo,
      storageInfo: storageInfo ?? this.storageInfo,
      batteryInfo: batteryInfo ?? this.batteryInfo,
      displayInfo: displayInfo ?? this.displayInfo,
      networkInfo: networkInfo ?? this.networkInfo,
      sensorInfo: sensorInfo ?? this.sensorInfo,
    );
  }
}

/// Loads every system_info section in parallel and exposes a single state
/// object. Widgets never call the repository directly — only this
/// ViewModel does, keeping the UI layer free of business/native logic.
class SystemInfoViewModel extends Notifier<SystemInfoState> {
  @override
  SystemInfoState build() {
    // `build()` must stay synchronous and side-effect free — Riverpod
    // throws if `state` is read/written before it returns. The initial
    // load is deferred to a microtask so it only starts once this
    // provider has finished initializing.
    Future.microtask(loadAll);
    return const SystemInfoState();
  }

  SystemInfoRepository get _repository => ref.read(systemInfoRepositoryProvider);

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final device = await _repository.getDeviceInfo();
      final cpu = await _repository.getCpuInfo();
      final gpu = await _repository.getGpuInfo();
      final memory = await _repository.getMemoryInfo();
      final storage = await _repository.getStorageInfo();
      final battery = await _repository.getBatteryInfo();
      final display = await _repository.getDisplayInfo();
      final network = await _repository.getNetworkInfo();
      final sensors = await _repository.getSensorInfo();

      state = state.copyWith(
        isLoading: false,
        deviceInfo: device,
        cpuInfo: cpu,
        gpuInfo: gpu,
        memoryInfo: memory,
        storageInfo: storage,
        batteryInfo: battery,
        displayInfo: display,
        networkInfo: network,
        sensorInfo: sensors,
      );
    } catch (e) {
      // A genuine unexpected failure (not a "field unavailable" case, which
      // is already modelled through SysValue). Surface it so the page can
      // show a retry affordance.
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() => loadAll();
}
