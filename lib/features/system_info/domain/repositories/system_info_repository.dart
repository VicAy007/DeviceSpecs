import '../entities/battery_info.dart';
import '../entities/cpu_info.dart';
import '../entities/device_info.dart';
import '../entities/display_info.dart';
import '../entities/gpu_info.dart';
import '../entities/memory_info.dart';
import '../entities/network_info.dart';
import '../entities/sensor_info.dart';
import '../entities/storage_info.dart';

/// Contract exposed to the presentation layer. Implementations are
/// responsible for orchestrating packages and native services, and must
/// never throw for "missing data" — that is represented via [SysValue]
/// states inside each entity. Implementations may throw only for genuine
/// unexpected failures (e.g. a corrupted platform channel response).
abstract class SystemInfoRepository {
  Future<DeviceInfo> getDeviceInfo();
  Future<CpuInfo> getCpuInfo();
  Future<GpuInfo> getGpuInfo();
  Future<MemoryInfo> getMemoryInfo();
  Future<StorageInfo> getStorageInfo();
  Future<BatteryInfo> getBatteryInfo();
  Future<DisplayInfo> getDisplayInfo();
  Future<NetworkInfo> getNetworkInfo();
  Future<SensorInfo> getSensorInfo();
}
