import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_specs/core/utils/sys_value.dart';
import 'package:device_specs/features/system_info/domain/entities/battery_info.dart';
import 'package:device_specs/features/system_info/domain/entities/cpu_info.dart';
import 'package:device_specs/features/system_info/domain/entities/device_info.dart';
import 'package:device_specs/features/system_info/domain/entities/display_info.dart';
import 'package:device_specs/features/system_info/domain/entities/gpu_info.dart';
import 'package:device_specs/features/system_info/domain/entities/memory_info.dart';
import 'package:device_specs/features/system_info/domain/entities/network_info.dart';
import 'package:device_specs/features/system_info/domain/entities/sensor_info.dart';
import 'package:device_specs/features/system_info/domain/entities/storage_info.dart';
import 'package:device_specs/features/system_info/domain/repositories/system_info_repository.dart';
import 'package:device_specs/features/system_info/presentation/pages/system_info_page.dart';
import 'package:device_specs/features/system_info/presentation/view_models/system_info_view_model.dart';

class FakeSystemInfoRepository implements SystemInfoRepository {
  @override
  Future<DeviceInfo> getDeviceInfo() async => const DeviceInfo(
        manufacturer: SysValue.available('Google'),
        model: SysValue.available('Pixel 8'),
        deviceName: SysValue.available('shiba'),
        osName: SysValue.available('Android'),
        osVersion: SysValue.available('14'),
        isPhysicalDevice: SysValue.available(true),
      );

  @override
  Future<CpuInfo> getCpuInfo() async => const CpuInfo(
        architecture: SysValue.available('arm64-v8a'),
        numberOfCores: SysValue.available(8),
        abi: SysValue.available('arm64-v8a'),
        supportedAbis: SysValue.available(['arm64-v8a']),
      );

  @override
  Future<GpuInfo> getGpuInfo() async => const GpuInfo(
        renderer: SysValue.notSupported(),
        vendor: SysValue.notSupported(),
        graphicsApi: SysValue.notSupported(),
      );

  @override
  Future<MemoryInfo> getMemoryInfo() async =>
      const MemoryInfo(totalBytes: SysValue.notSupported(), availableBytes: SysValue.notSupported());

  @override
  Future<StorageInfo> getStorageInfo() async =>
      const StorageInfo(totalBytes: SysValue.available(1000), freeBytes: SysValue.available(400));

  @override
  Future<BatteryInfo> getBatteryInfo() async => const BatteryInfo(
        level: SysValue.available(87),
        chargeState: SysValue.available(ChargeState.discharging),
        powerSource: SysValue.unavailable(),
        isInBatterySaveMode: SysValue.available(false),
      );

  @override
  Future<DisplayInfo> getDisplayInfo() async => const DisplayInfo(
        widthPx: SysValue.available(1080),
        heightPx: SysValue.available(2400),
        devicePixelRatio: SysValue.available(2.6),
        logicalWidth: SysValue.available(411),
        logicalHeight: SysValue.available(914),
        orientation: SysValue.available('Portrait'),
      );

  @override
  Future<NetworkInfo> getNetworkInfo() async =>
      const NetworkInfo(connectionType: SysValue.available('Wi-Fi'), isConnected: SysValue.available(true));

  @override
  Future<SensorInfo> getSensorInfo() async => const SensorInfo(
        hasAccelerometer: SysValue.available(true),
        hasGyroscope: SysValue.available(true),
        hasMagnetometer: SysValue.unavailable(),
        hasProximity: SysValue.notSupported(),
      );
}

void main() {
  testWidgets('shows a loading state then renders every section', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [systemInfoRepositoryProvider.overrideWithValue(FakeSystemInfoRepository())],
        child: const MaterialApp(home: SystemInfoPage()),
      ),
    );

    // First frame: loading skeletons, no section titles yet.
    expect(find.text('Device'), findsNothing);

    await tester.pumpAndSettle();

    expect(find.text('Device'), findsOneWidget);
    expect(find.text('CPU'), findsOneWidget);
    expect(find.text('GPU'), findsOneWidget);
    expect(find.text('Memory'), findsOneWidget);
    expect(find.text('Storage'), findsOneWidget);
    expect(find.text('Battery'), findsOneWidget);
    expect(find.text('Display'), findsOneWidget);
    expect(find.text('Network'), findsOneWidget);
    expect(find.text('Sensors'), findsOneWidget);

    // Unavailable field renders its explicit placeholder, never a guess.
    expect(find.text('Not supported'), findsWidgets);
  });
}
