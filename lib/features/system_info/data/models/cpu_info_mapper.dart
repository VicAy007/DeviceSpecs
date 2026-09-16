import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/utils/sys_value.dart';
import '../../domain/entities/cpu_info.dart';

class CpuInfoMapper {
  const CpuInfoMapper._();

  static CpuInfo fromAndroid({
    required AndroidDeviceInfo info,
    required SysValue<int> numberOfCores,
  }) {
    final abis = info.supportedAbis;
    return CpuInfo(
      architecture: abis.isNotEmpty ? SysValue.available(abis.first) : const SysValue.unavailable(),
      numberOfCores: numberOfCores,
      abi: abis.isNotEmpty ? SysValue.available(abis.first) : const SysValue.unavailable(),
      supportedAbis: abis.isNotEmpty ? SysValue.available(abis) : const SysValue.unavailable(),
    );
  }

  static CpuInfo fromIos({
    required IosDeviceInfo info,
    required SysValue<int> numberOfCores,
  }) {
    final machine = info.utsname.machine;
    return CpuInfo(
      architecture: SysValue.available(machine),
      numberOfCores: numberOfCores,
      abi: SysValue.available(machine),
      supportedAbis: SysValue.available([machine]),
    );
  }
}
