import 'package:flutter/services.dart';
import '../../core/utils/sys_value.dart';

/// Thin wrapper around the native `com.devicespecs/device` MethodChannel.
///
/// This channel is only used for the handful of fields that the
/// `device_info_plus` package does not expose on every platform (e.g. the
/// full list of supported ABIs on iOS, which Apple does not surface through
/// public Dart-side APIs but can be derived natively).
///
/// Native side responsibilities:
/// - Android (Kotlin): implement in MainActivity using `android.os.Build`.
/// - iOS (Swift): implement using `utsname` / `sysctlbyname`.
class DevicePlatformService {
  DevicePlatformService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.devicespecs/device');

  final MethodChannel _channel;

  /// Returns the device's supported ABI list (Android) or CPU architecture
  /// identifiers (iOS), or the appropriate [SysValue] state when the native
  /// implementation is missing or the call fails.
  Future<SysValue<List<String>>> getSupportedAbis() async {
    try {
      final result = await _channel.invokeListMethod<String>('getSupportedAbis');
      if (result == null || result.isEmpty) {
        return const SysValue.unavailable();
      }
      return SysValue.available(result);
    } on MissingPluginException {
      // Native implementation not wired up yet on this platform.
      return const SysValue.notSupported();
    } on PlatformException {
      return const SysValue.unavailable();
    }
  }

  /// Whether the running binary is executing on a physical device or an
  /// emulator/simulator, when not already resolved by device_info_plus.
  Future<SysValue<bool>> isPhysicalDevice() async {
    try {
      final result = await _channel.invokeMethod<bool>('isPhysicalDevice');
      if (result == null) return const SysValue.unknown();
      return SysValue.available(result);
    } on MissingPluginException {
      return const SysValue.notSupported();
    } on PlatformException {
      return const SysValue.unavailable();
    }
  }
}
