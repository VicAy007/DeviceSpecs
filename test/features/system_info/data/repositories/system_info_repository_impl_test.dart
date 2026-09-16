import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:device_specs/core/utils/sys_value.dart';
import 'package:device_specs/features/system_info/data/repositories/system_info_repository_impl.dart';
import 'package:device_specs/features/system_info/data/services/battery_service.dart';
import 'package:device_specs/features/system_info/data/services/device_info_service.dart';
import 'package:device_specs/features/system_info/data/services/network_service.dart';
import 'package:device_specs/features/system_info/data/services/sensor_service.dart';
import 'package:device_specs/features/system_info/data/services/storage_service.dart';
import 'package:device_specs/features/system_info/data/services/system_service.dart';
import 'package:device_specs/features/system_info/domain/entities/battery_info.dart';
import 'package:device_specs/features/system_info/domain/entities/device_info.dart';
import 'package:device_specs/features/system_info/domain/entities/storage_info.dart';

class MockDeviceInfoService extends Mock implements DeviceInfoService {}
class MockBatteryService extends Mock implements BatteryService {}
class MockStorageService extends Mock implements StorageService {}
class MockSystemService extends Mock implements SystemService {}
class MockNetworkService extends Mock implements NetworkService {}
class MockSensorService extends Mock implements SensorService {}

void main() {
  late MockDeviceInfoService deviceInfoService;
  late MockBatteryService batteryService;
  late MockStorageService storageService;
  late MockSystemService systemService;
  late MockNetworkService networkService;
  late MockSensorService sensorService;
  late SystemInfoRepositoryImpl repository;

  setUp(() {
    deviceInfoService = MockDeviceInfoService();
    batteryService = MockBatteryService();
    storageService = MockStorageService();
    systemService = MockSystemService();
    networkService = MockNetworkService();
    sensorService = MockSensorService();
    repository = SystemInfoRepositoryImpl(
      deviceInfoService: deviceInfoService,
      batteryService: batteryService,
      storageService: storageService,
      systemService: systemService,
      networkService: networkService,
      sensorService: sensorService,
    );
  });

  test('getDeviceInfo delegates to DeviceInfoService untouched', () async {
    const device = DeviceInfo(
      manufacturer: SysValue.available('Apple'),
      model: SysValue.available('iPhone 15'),
      deviceName: SysValue.available('iPhone'),
      osName: SysValue.available('iOS'),
      osVersion: SysValue.available('17.4'),
      isPhysicalDevice: SysValue.available(true),
    );
    when(() => deviceInfoService.getDeviceInfo()).thenAnswer((_) async => device);

    final result = await repository.getDeviceInfo();

    expect(result, device);
    verify(() => deviceInfoService.getDeviceInfo()).called(1);
  });

  test('getStorageInfo delegates to StorageService untouched', () async {
    const storage = StorageInfo(totalBytes: SysValue.available(1000), freeBytes: SysValue.available(400));
    when(() => storageService.getStorageInfo()).thenAnswer((_) async => storage);

    final result = await repository.getStorageInfo();

    expect(result.usedBytes.display(), '600');
  });

  test('getBatteryInfo delegates to BatteryService untouched', () async {
    const battery = BatteryInfo(
      level: SysValue.available(50),
      chargeState: SysValue.available(ChargeState.charging),
      powerSource: SysValue.available('USB'),
      isInBatterySaveMode: SysValue.notSupported(),
    );
    when(() => batteryService.getBatteryInfo()).thenAnswer((_) async => battery);

    final result = await repository.getBatteryInfo();

    expect(result, battery);
  });

  test('getMemoryInfo honestly reports not supported instead of guessing', () async {
    final result = await repository.getMemoryInfo();

    expect(result.totalBytes.isAvailable, isFalse);
    expect(result.totalBytes.display(), 'Not supported');
  });
}
