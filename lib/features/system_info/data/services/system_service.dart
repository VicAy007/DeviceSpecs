import 'dart:io';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/utils/sys_value.dart';
import '../../../../services/native/system_platform_service.dart';
import '../../domain/entities/cpu_info.dart';
import '../../domain/entities/display_info.dart';
import '../../domain/entities/gpu_info.dart';
import '../models/cpu_info_mapper.dart';

/// Covers CPU, GPU and Display — the three sections that mix a Dart-only
/// source (dart:io / dart:ui) with native-channel-only data (GPU renderer,
/// precise ABI confirmation).
class SystemService {
  SystemService({
    DeviceInfoPlugin? deviceInfoPlugin,
    SystemPlatformService? systemPlatformService,
  })  : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin(),
        _systemPlatformService = systemPlatformService ?? SystemPlatformService();

  final DeviceInfoPlugin _deviceInfoPlugin;
  final SystemPlatformService _systemPlatformService;

  Future<CpuInfo> getCpuInfo() async {
    // Number of logical cores is always available through the Dart runtime.
    final cores = SysValue.available(Platform.numberOfProcessors);

    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      return CpuInfoMapper.fromAndroid(info: info, numberOfCores: cores);
    }
    if (Platform.isIOS) {
      final info = await _deviceInfoPlugin.iosInfo;
      return CpuInfoMapper.fromIos(info: info, numberOfCores: cores);
    }
    return CpuInfo(
      architecture: const SysValue.notSupported(),
      numberOfCores: cores,
      abi: const SysValue.notSupported(),
      supportedAbis: const SysValue.notSupported(),
    );
  }

  Future<GpuInfo> getGpuInfo() async {
    // GPU details have no Dart-only API on either platform: they require
    // the native channel (GLES / Metal introspection). See
    // SystemPlatformService for the native implementation notes.
    final renderer = await _systemPlatformService.getGpuRenderer();
    final vendor = await _systemPlatformService.getGpuVendor();
    final api = await _systemPlatformService.getGraphicsApi();
    return GpuInfo(renderer: renderer, vendor: vendor, graphicsApi: api);
  }

  Future<DisplayInfo> getDisplayInfo() async {
    try {
      final view = ui.PlatformDispatcher.instance.views.first;
      final physicalSize = view.physicalSize;
      final pixelRatio = view.devicePixelRatio;
      final logicalWidth = physicalSize.width / pixelRatio;
      final logicalHeight = physicalSize.height / pixelRatio;
      final orientation = physicalSize.width >= physicalSize.height ? 'Landscape' : 'Portrait';

      return DisplayInfo(
        widthPx: SysValue.available(physicalSize.width.round()),
        heightPx: SysValue.available(physicalSize.height.round()),
        devicePixelRatio: SysValue.available(pixelRatio),
        logicalWidth: SysValue.available(logicalWidth),
        logicalHeight: SysValue.available(logicalHeight),
        orientation: SysValue.available(orientation),
      );
    } catch (_) {
      // No attached view (e.g. running headless in a test) — report as
      // unavailable rather than fabricating numbers.
      return const DisplayInfo(
        widthPx: SysValue.unavailable(),
        heightPx: SysValue.unavailable(),
        devicePixelRatio: SysValue.unavailable(),
        logicalWidth: SysValue.unavailable(),
        logicalHeight: SysValue.unavailable(),
        orientation: SysValue.unavailable(),
      );
    }
  }
}
