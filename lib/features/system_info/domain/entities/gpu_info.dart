import '../../../../core/utils/sys_value.dart';

/// GPU/graphics rendering information. Frequently unavailable/restricted
/// depending on platform and OS sandboxing.
class GpuInfo {
  const GpuInfo({
    required this.renderer,
    required this.vendor,
    required this.graphicsApi,
  });

  final SysValue<String> renderer;
  final SysValue<String> vendor;
  final SysValue<String> graphicsApi;

  factory GpuInfo.loading() => const GpuInfo(
        renderer: SysValue.unknown(),
        vendor: SysValue.unknown(),
        graphicsApi: SysValue.unknown(),
      );
}
