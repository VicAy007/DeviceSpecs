import '../../../../core/utils/sys_value.dart';

enum ChargeState { charging, discharging, full, unknown }

/// Battery status snapshot.
class BatteryInfo {
  const BatteryInfo({
    required this.level,
    required this.chargeState,
    required this.powerSource,
    required this.isInBatterySaveMode,
  });

  /// Percentage, 0-100.
  final SysValue<int> level;
  final SysValue<ChargeState> chargeState;
  final SysValue<String> powerSource;
  final SysValue<bool> isInBatterySaveMode;

  factory BatteryInfo.loading() => const BatteryInfo(
        level: SysValue.unknown(),
        chargeState: SysValue.unknown(),
        powerSource: SysValue.unknown(),
        isInBatterySaveMode: SysValue.unknown(),
      );
}
