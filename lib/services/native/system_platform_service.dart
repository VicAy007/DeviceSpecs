import 'package:flutter/services.dart';
import '../../core/utils/sys_value.dart';

/// Native `com.devicespecs/system` channel for CPU/GPU details that have no
/// cross-platform Dart package: GPU renderer/vendor and the OS-reported
/// graphics API in use.
///
/// Native side responsibilities:
/// - Android (Kotlin): query `GLES20` renderer/vendor strings through a
///   throwaway `GLSurfaceView` / `EGL` context, or `Build.SOC_MODEL` (API 31+)
///   for the SoC model.
/// - iOS (Swift): `MTLCreateSystemDefaultDevice()?.name` for the GPU name;
///   Metal is always the graphics API on supported devices.
class SystemPlatformService {
  SystemPlatformService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.devicespecs/system');

  final MethodChannel _channel;

  Future<SysValue<String>> getGpuRenderer() => _invokeString('getGpuRenderer');

  Future<SysValue<String>> getGpuVendor() => _invokeString('getGpuVendor');

  Future<SysValue<String>> getGraphicsApi() => _invokeString('getGraphicsApi');

  Future<SysValue<String>> getCpuAbi() => _invokeString('getCpuAbi');

  Future<SysValue<String>> _invokeString(String method) async {
    try {
      final result = await _channel.invokeMethod<String>(method);
      if (result == null || result.isEmpty) return const SysValue.unavailable();
      return SysValue.available(result);
    } on MissingPluginException {
      return const SysValue.notSupported();
    } on PlatformException {
      return const SysValue.unavailable();
    }
  }
}
