import '../../../../core/utils/sys_value.dart';

/// General information about the physical/virtual device running the app.
class DeviceInfo {
  const DeviceInfo({
    required this.manufacturer,
    required this.model,
    required this.deviceName,
    required this.osName,
    required this.osVersion,
    required this.isPhysicalDevice,
  });

  final SysValue<String> manufacturer;
  final SysValue<String> model;
  final SysValue<String> deviceName;
  final SysValue<String> osName;
  final SysValue<String> osVersion;
  final SysValue<bool> isPhysicalDevice;

  factory DeviceInfo.loading() => const DeviceInfo(
        manufacturer: SysValue.unknown(),
        model: SysValue.unknown(),
        deviceName: SysValue.unknown(),
        osName: SysValue.unknown(),
        osVersion: SysValue.unknown(),
        isPhysicalDevice: SysValue.unknown(),
      );
}
