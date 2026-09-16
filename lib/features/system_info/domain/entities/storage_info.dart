import '../../../../core/utils/sys_value.dart';

/// Internal storage usage snapshot.
class StorageInfo {
  const StorageInfo({
    required this.totalBytes,
    required this.freeBytes,
  });

  final SysValue<int> totalBytes;
  final SysValue<int> freeBytes;

  SysValue<int> get usedBytes {
    if (totalBytes.isAvailable && freeBytes.isAvailable) {
      return SysValue.available(totalBytes.value! - freeBytes.value!);
    }
    return const SysValue.unavailable();
  }

  SysValue<double> get usagePercent {
    if (totalBytes.isAvailable && freeBytes.isAvailable && totalBytes.value! > 0) {
      final used = totalBytes.value! - freeBytes.value!;
      return SysValue.available(used / totalBytes.value!);
    }
    return const SysValue.unavailable();
  }

  factory StorageInfo.loading() => const StorageInfo(
        totalBytes: SysValue.unknown(),
        freeBytes: SysValue.unknown(),
      );
}
