import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/utils/sys_value.dart';
import '../../domain/entities/device_info.dart';

/// Maps raw `device_info_plus` platform objects to the [DeviceInfo] entity.
///
/// There is no wire/JSON format to model here (data comes straight from the
/// native SDK objects), so a mapper class is used instead of a duplicated
/// "Model extends Entity" DTO — it keeps the translation logic isolated in
/// the data layer without adding a redundant class hierarchy.
class DeviceInfoMapper {
  const DeviceInfoMapper._();

  static DeviceInfo fromAndroid(AndroidDeviceInfo info) {
    return DeviceInfo(
      manufacturer: SysValue.available(info.manufacturer),
      model: SysValue.available(info.model),
      deviceName: SysValue.available(info.device),
      osName: const SysValue.available('Android'),
      osVersion: SysValue.available(info.version.release),
      isPhysicalDevice: SysValue.available(info.isPhysicalDevice),
    );
  }

  static DeviceInfo fromIos(IosDeviceInfo info) {
    return DeviceInfo(
      manufacturer: const SysValue.available('Apple'),
      model: SysValue.available(info.utsname.machine),
      deviceName: SysValue.available(info.name),
      osName: SysValue.available(info.systemName),
      osVersion: SysValue.available(info.systemVersion),
      isPhysicalDevice: SysValue.available(info.isPhysicalDevice),
    );
  }

  static DeviceInfo unsupportedPlatform() => const DeviceInfo(
        manufacturer: SysValue.notSupported(),
        model: SysValue.notSupported(),
        deviceName: SysValue.notSupported(),
        osName: SysValue.notSupported(),
        osVersion: SysValue.notSupported(),
        isPhysicalDevice: SysValue.notSupported(),
      );
}
