import '../../domain/entities/device_health.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../system_info/domain/repositories/system_info_repository.dart';
import '../../../system_info/domain/entities/battery_info.dart';

/// Real Dashboard repository. It reuses the existing system_info repository
/// instead of collecting or inventing system data a second time.
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({required SystemInfoRepository systemInfoRepository})
      : _systemInfoRepository = systemInfoRepository;

  final SystemInfoRepository _systemInfoRepository;

  @override
  Future<DeviceHealth> getDeviceHealth() async {
    final results = await Future.wait([
      _systemInfoRepository.getDeviceInfo(),
      _systemInfoRepository.getCpuInfo(),
      _systemInfoRepository.getMemoryInfo(),
      _systemInfoRepository.getStorageInfo(),
      _systemInfoRepository.getBatteryInfo(),
      _systemInfoRepository.getNetworkInfo(),
    ]);

    final device = results[0];
    final cpu = results[1];
    final memory = results[2];
    final storage = results[3];
    final battery = results[4];
    final network = results[5];

    final d = device as dynamic;
    final c = cpu as dynamic;
    final m = memory as dynamic;
    final s = storage as dynamic;
    final b = battery as dynamic;
    final n = network as dynamic;

    final ramTotal = _gb(m.totalBytes);
    final ramFree = _gb(m.availableBytes);
    final ramUsed = _gb(m.usedBytes);
    final storageTotal = _gb(s.totalBytes);
    final storageFree = _gb(s.freeBytes);
    final storageUsed = _gb(s.usedBytes);

    return DeviceHealth(
      deviceId: _text(d.model),
      deviceName: _text(d.deviceName),
      osVersion: '${_text(d.osName)} ${_text(d.osVersion)}'.trim(),
      chipset: _text(c.architecture),
      buildNumber: _text(c.abi),
      healthPercent: 0,
      batteryPercent: _int(b.level),
      batteryTempCelsius: 0,
      chargeState: _chargeState(b.chargeState),
      cellHealth: 'Unavailable',
      chargerLabel: _text(b.powerSource),
      ramPercent: _percent(m.usagePercent),
      ramUsedGb: ramUsed,
      ramTotalGb: ramTotal,
      ramFreeGb: ramFree,
      ramType: 'Unavailable',
      activeHeapGb: 0,
      zramSwapGb: 0,
      storagePercent: _percent(s.usagePercent),
      storageUsedGb: storageUsed.round(),
      storageTotalGb: storageTotal.round(),
      storageFreeGb: storageFree.round(),
      storageBus: 'Unavailable',
      cpuName: 'CPU (${_text(c.architecture)})',
      cpuCoreLayout: '${_text(c.numberOfCores)} cores',
      cpuLoadPercent: 0,
      cpuFreqPrimeGhz: 0,
      cpuFreqPerformanceGhz: 0,
      cpuFreqEfficiencyGhz: 0,
      cpuLoadHistory: const [],
      wifiStandard: _text(n.connectionType),
      wifiConnected: _bool(n.isConnected),
      wifiBand: _text(n.connectionType),
      downlinkMbps: 0,
      linkPhyMbps: 0,
      latencyMs: 0,
      jitterMs: 0,
      gatewayIp: 'Unavailable',
    );
  }

  String _text(dynamic sysValue) =>
      sysValue != null && sysValue.isAvailable ? '${sysValue.value}' : 'Unavailable';

  int _int(dynamic sysValue) =>
      sysValue != null && sysValue.isAvailable ? (sysValue.value as int) : 0;

  bool _bool(dynamic sysValue) =>
      sysValue != null && sysValue.isAvailable ? sysValue.value as bool : false;

  int _percent(dynamic sysValue) {
    if (sysValue == null || !sysValue.isAvailable) return 0;
    return ((sysValue.value as double) * 100).round();
  }

  double _gb(dynamic sysValue) {
    if (sysValue == null || !sysValue.isAvailable) return 0;
    return (sysValue.value as int) / (1024 * 1024 * 1024);
  }

  String _chargeState(dynamic sysValue) {
    if (sysValue == null || !sysValue.isAvailable) return 'Unavailable';
    final value = sysValue.value as ChargeState;
    switch (value) {
      case ChargeState.charging:
        return 'Charging';
      case ChargeState.discharging:
        return 'Discharging';
      case ChargeState.full:
        return 'Full';
      case ChargeState.unknown:
        return 'Unavailable';
    }
  }
}
