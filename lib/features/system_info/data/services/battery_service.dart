import 'package:battery_plus/battery_plus.dart';
import '../../../../core/utils/sys_value.dart';
import '../../../../services/native/battery_platform_service.dart';
import '../../domain/entities/battery_info.dart';

class BatteryService {
  BatteryService({
    Battery? battery,
    BatteryPlatformService? batteryPlatformService,
  })  : _battery = battery ?? Battery(),
        _batteryPlatformService = batteryPlatformService ?? BatteryPlatformService();

  final Battery _battery;
  final BatteryPlatformService _batteryPlatformService;

  Future<BatteryInfo> getBatteryInfo() async {
    final level = await _tryLevel();
    final chargeState = await _tryChargeState();
    final saveMode = await _trySaveMode();
    final powerSource = await _batteryPlatformService.getPowerSource();

    return BatteryInfo(
      level: level,
      chargeState: chargeState,
      powerSource: powerSource,
      isInBatterySaveMode: saveMode,
    );
  }

  Future<SysValue<int>> _tryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      if (level < 0) return const SysValue.unavailable();
      return SysValue.available(level);
    } catch (_) {
      return const SysValue.unavailable();
    }
  }

  Future<SysValue<ChargeState>> _tryChargeState() async {
    try {
      final state = await _battery.batteryState;
      return SysValue.available(_mapState(state));
    } catch (_) {
      return const SysValue.unavailable();
    }
  }

  Future<SysValue<bool>> _trySaveMode() async {
    try {
      final isSaving = await _battery.isInBatterySaveMode;
      return SysValue.available(isSaving);
    } catch (_) {
      // Battery saver reporting is Android-only in battery_plus.
      return const SysValue.notSupported();
    }
  }

  ChargeState _mapState(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return ChargeState.charging;
      case BatteryState.discharging:
      case BatteryState.connectedNotCharging:
        return ChargeState.discharging;
      case BatteryState.full:
        return ChargeState.full;
      case BatteryState.unknown:
        return ChargeState.unknown;
    }
  }
}
