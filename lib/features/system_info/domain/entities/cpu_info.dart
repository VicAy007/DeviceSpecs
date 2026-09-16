import '../../../../core/utils/sys_value.dart';

/// CPU-related characteristics of the device.
class CpuInfo {
  const CpuInfo({
    required this.architecture,
    required this.numberOfCores,
    required this.abi,
    required this.supportedAbis,
  });

  final SysValue<String> architecture;
  final SysValue<int> numberOfCores;
  final SysValue<String> abi;
  final SysValue<List<String>> supportedAbis;

  factory CpuInfo.loading() => const CpuInfo(
        architecture: SysValue.unknown(),
        numberOfCores: SysValue.unknown(),
        abi: SysValue.unknown(),
        supportedAbis: SysValue.unknown(),
      );
}
