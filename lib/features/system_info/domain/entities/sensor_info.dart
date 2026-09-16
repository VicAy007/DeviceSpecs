import '../../../../core/utils/sys_value.dart';

/// Availability of common hardware sensors.
class SensorInfo {
  const SensorInfo({
    required this.hasAccelerometer,
    required this.hasGyroscope,
    required this.hasMagnetometer,
    required this.hasProximity,
  });

  final SysValue<bool> hasAccelerometer;
  final SysValue<bool> hasGyroscope;
  final SysValue<bool> hasMagnetometer;
  final SysValue<bool> hasProximity;

  factory SensorInfo.loading() => const SensorInfo(
        hasAccelerometer: SysValue.unknown(),
        hasGyroscope: SysValue.unknown(),
        hasMagnetometer: SysValue.unknown(),
        hasProximity: SysValue.unknown(),
      );
}
