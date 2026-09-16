import 'package:flutter/services.dart';
import '../../core/utils/sys_value.dart';

/// Native `com.devicespecs/storage` channel exposing total/free internal
/// storage in bytes.
///
/// Native side responsibilities:
/// - Android (Kotlin): `StatFs(Environment.getDataDirectory().path)`.
/// - iOS (Swift): `URL.resourceValues(forKeys:)` with
///   `.volumeAvailableCapacityForImportantUsageKey` /
///   `.volumeTotalCapacityKey`.
class StoragePlatformService {
  StoragePlatformService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.devicespecs/storage');

  final MethodChannel _channel;

  Future<SysValue<int>> getTotalStorageBytes() => _invokeInt('getTotalStorageBytes');

  Future<SysValue<int>> getFreeStorageBytes() => _invokeInt('getFreeStorageBytes');

  Future<SysValue<int>> _invokeInt(String method) async {
    try {
      final result = await _channel.invokeMethod<int>(method);
      if (result == null || result < 0) return const SysValue.unavailable();
      return SysValue.available(result);
    } on MissingPluginException {
      return const SysValue.notSupported();
    } on PlatformException {
      return const SysValue.unavailable();
    }
  }
}
