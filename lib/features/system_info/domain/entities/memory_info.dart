import '../../../../core/utils/sys_value.dart';

/// RAM usage snapshot.
class MemoryInfo {
  const MemoryInfo({
    required this.totalBytes,
    required this.availableBytes,
  });

  final SysValue<int> totalBytes;
  final SysValue<int> availableBytes;

  /// Derived used memory, only available when both totals are known.
  SysValue<int> get usedBytes {
    if (totalBytes.isAvailable && availableBytes.isAvailable) {
      return SysValue.available(totalBytes.value! - availableBytes.value!);
    }
    return const SysValue.unavailable();
  }

  /// Derived usage percentage (0.0 - 1.0).
  SysValue<double> get usagePercent {
    if (totalBytes.isAvailable && availableBytes.isAvailable && totalBytes.value! > 0) {
      final used = totalBytes.value! - availableBytes.value!;
      return SysValue.available(used / totalBytes.value!);
    }
    return const SysValue.unavailable();
  }

  factory MemoryInfo.loading() => const MemoryInfo(
        totalBytes: SysValue.unknown(),
        availableBytes: SysValue.unknown(),
      );
}
