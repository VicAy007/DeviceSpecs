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
import '../services/battery_service.dart';
import '../services/device_info_service.dart';
import '../services/network_service.dart';
import '../services/sensor_service.dart';
import '../services/storage_service.dart';
import '../services/system_service.dart';
import '../../../../core/utils/sys_value.dart';

/// Concrete [SystemInfoRepository]. Pure orchestration: each method
/// delegates to the relevant service and returns its entity untouched. No
/// business/formatting logic lives here — that belongs to the ViewModel or
/// the widgets.
class SystemInfoRepositoryImpl implements SystemInfoRepository {
  SystemInfoRepositoryImpl({
    required DeviceInfoService deviceInfoService,
    required BatteryService batteryService,
    required StorageService storageService,
    required SystemService systemService,
    required NetworkService networkService,
    required SensorService sensorService,
  })  : _deviceInfoService = deviceInfoService,
        _batteryService = batteryService,
        _storageService = storageService,
        _systemService = systemService,
        _networkService = networkService,
        _sensorService = sensorService;

  final DeviceInfoService _deviceInfoService;
  final BatteryService _batteryService;
  final StorageService _storageService;
  final SystemService _systemService;
  final NetworkService _networkService;
  final SensorService _sensorService;

  @override
  Future<DeviceInfo> getDeviceInfo() => _deviceInfoService.getDeviceInfo();

  @override
  Future<CpuInfo> getCpuInfo() => _systemService.getCpuInfo();

  @override
  Future<GpuInfo> getGpuInfo() => _systemService.getGpuInfo();

  @override
  Future<DisplayInfo> getDisplayInfo() => _systemService.getDisplayInfo();

  @override
  Future<BatteryInfo> getBatteryInfo() => _batteryService.getBatteryInfo();

  @override
  Future<StorageInfo> getStorageInfo() => _storageService.getStorageInfo();

  @override
  Future<NetworkInfo> getNetworkInfo() => _networkService.getNetworkInfo();

  @override
  Future<SensorInfo> getSensorInfo() => _sensorService.getSensorInfo();

  @override
  Future<MemoryInfo> getMemoryInfo() async {
    // RAM totals require native introspection on both Android and iOS —
    // `device_info_plus` does not expose them, and no lightweight
    // cross-platform package returns raw total/available bytes reliably.
    // Until the native `com.devicespecs/system` channel implements
    // `getTotalRam` / `getAvailableRam`, we surface this honestly instead
    // of guessing at a value.
    return const MemoryInfo(
      totalBytes: SysValue.notSupported(),
      availableBytes: SysValue.notSupported(),
    );
  }
}
