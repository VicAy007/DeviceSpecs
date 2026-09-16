import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../services/native/device_platform_service.dart';
import '../../domain/entities/device_info.dart';
import '../models/device_info_mapper.dart';

/// Retrieves device identity information via `device_info_plus`, augmented
/// with the native channel for fields the package does not expose.
class DeviceInfoService {
  DeviceInfoService({
    DeviceInfoPlugin? plugin,
    DevicePlatformService? platformService,
  })  : _plugin = plugin ?? DeviceInfoPlugin(),
        _platformService = platformService ?? DevicePlatformService();

  final DeviceInfoPlugin _plugin;
  final DevicePlatformService _platformService;

  Future<DeviceInfo> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return DeviceInfoMapper.fromAndroid(info);
    }
    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return DeviceInfoMapper.fromIos(info);
    }
    return DeviceInfoMapper.unsupportedPlatform();
  }

  /// Exposed so [SystemService] can build [CpuInfo] without querying
  /// device_info_plus twice.
  DeviceInfoPlugin get plugin => _plugin;

  DevicePlatformService get platformService => _platformService;
}
