import 'package:flutter/services.dart';
import '../../core/utils/sys_value.dart';

/// Native `com.devicespecs/battery` channel for battery details that the
/// `battery_plus` package does not expose (precise power source such as
/// AC / USB / Wireless, only available through `BatteryManager` on Android
/// and IOKit-derived heuristics on iOS).
class BatteryPlatformService {
  BatteryPlatformService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.devicespecs/battery');

  final MethodChannel _channel;

  Future<SysValue<String>> getPowerSource() async {
    try {
      final result = await _channel.invokeMethod<String>('getPowerSource');
      if (result == null || result.isEmpty) return const SysValue.unknown();
      return SysValue.available(result);
    } on MissingPluginException {
      return const SysValue.notSupported();
    } on PlatformException {
      return const SysValue.unavailable();
    }
  }
}
