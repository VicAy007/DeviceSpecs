import '../../../../core/utils/sys_value.dart';

/// Screen characteristics.
class DisplayInfo {
  const DisplayInfo({
    required this.widthPx,
    required this.heightPx,
    required this.devicePixelRatio,
    required this.logicalWidth,
    required this.logicalHeight,
    required this.orientation,
  });

  final SysValue<int> widthPx;
  final SysValue<int> heightPx;
  final SysValue<double> devicePixelRatio;
  final SysValue<double> logicalWidth;
  final SysValue<double> logicalHeight;
  final SysValue<String> orientation;

  factory DisplayInfo.loading() => const DisplayInfo(
        widthPx: SysValue.unknown(),
        heightPx: SysValue.unknown(),
        devicePixelRatio: SysValue.unknown(),
        logicalWidth: SysValue.unknown(),
        logicalHeight: SysValue.unknown(),
        orientation: SysValue.unknown(),
      );
}
