import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
import 'package:device_specs/features/system_info/presentation/view_models/system_info_view_model.dart';

class MockSystemInfoRepository extends Mock implements SystemInfoRepository {}

/// `SystemInfoViewModel` is a Riverpod 3 `Notifier`: it has no public
/// constructor, so it must be obtained from a `ProviderContainer` (with the
/// repository provider overridden) rather than instantiated directly.
void main() {
  late MockSystemInfoRepository repository;

  const device = DeviceInfo(
    manufacturer: SysValue.available('Google'),
    model: SysValue.available('Pixel 8'),
    deviceName: SysValue.available('shiba'),
    osName: SysValue.available('Android'),
    osVersion: SysValue.available('14'),
    isPhysicalDevice: SysValue.available(true),
  );
  const cpu = CpuInfo(
    architecture: SysValue.available('arm64-v8a'),
    numberOfCores: SysValue.available(8),
    abi: SysValue.available('arm64-v8a'),
    supportedAbis: SysValue.available(['arm64-v8a']),
  );
  const gpu = GpuInfo(
    renderer: SysValue.notSupported(),
    vendor: SysValue.notSupported(),
    graphicsApi: SysValue.notSupported(),
  );
  const memory = MemoryInfo(totalBytes: SysValue.notSupported(), availableBytes: SysValue.notSupported());
  const storage = StorageInfo(totalBytes: SysValue.available(128000000000), freeBytes: SysValue.available(64000000000));
  const battery = BatteryInfo(
    level: SysValue.available(87),
    chargeState: SysValue.available(ChargeState.discharging),
    powerSource: SysValue.unavailable(),
    isInBatterySaveMode: SysValue.available(false),
  );
  const display = DisplayInfo(
    widthPx: SysValue.available(1080),
    heightPx: SysValue.available(2400),
    devicePixelRatio: SysValue.available(2.625),
    logicalWidth: SysValue.available(411.4),
    logicalHeight: SysValue.available(914.3),
    orientation: SysValue.available('Portrait'),
  );
  const network = NetworkInfo(connectionType: SysValue.available('Wi-Fi'), isConnected: SysValue.available(true));
  const sensors = SensorInfo(
    hasAccelerometer: SysValue.available(true),
    hasGyroscope: SysValue.available(true),
    hasMagnetometer: SysValue.unavailable(),
    hasProximity: SysValue.notSupported(),
  );

  void stubHappyPath() {
    when(() => repository.getDeviceInfo()).thenAnswer((_) async => device);
    when(() => repository.getCpuInfo()).thenAnswer((_) async => cpu);
    when(() => repository.getGpuInfo()).thenAnswer((_) async => gpu);
    when(() => repository.getMemoryInfo()).thenAnswer((_) async => memory);
    when(() => repository.getStorageInfo()).thenAnswer((_) async => storage);
    when(() => repository.getBatteryInfo()).thenAnswer((_) async => battery);
    when(() => repository.getDisplayInfo()).thenAnswer((_) async => display);
    when(() => repository.getNetworkInfo()).thenAnswer((_) async => network);
    when(() => repository.getSensorInfo()).thenAnswer((_) async => sensors);
  }

  setUp(() {
    repository = MockSystemInfoRepository();
  });

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [systemInfoRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// `Notifier.build()` schedules its own initial `loadAll()` call in a
  /// microtask (see `SystemInfoViewModel.build`). Draining the microtask
  /// queue with a zero-duration delay lets that chain of awaits fully
  /// resolve before assertions run, without racing an explicit call.
  Future<void> flushMicrotasks() => Future<void>.delayed(Duration.zero);

  test('initial state is loading', () {
    stubHappyPath();
    final container = buildContainer();

    final state = container.read(systemInfoViewModelProvider);

    expect(state.isLoading, isTrue);
  });

  test('loadAll populates every section and clears loading on success', () async {
    stubHappyPath();
    final container = buildContainer();
    container.read(systemInfoViewModelProvider.notifier);

    await flushMicrotasks();

    final state = container.read(systemInfoViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.hasError, isFalse);
    expect(state.deviceInfo, device);
    expect(state.cpuInfo, cpu);
    expect(state.batteryInfo!.level.display(), '87');
    expect(state.gpuInfo!.renderer.isAvailable, isFalse);
    expect(state.gpuInfo!.renderer.display(), 'Not supported');
  });

  test('does not fabricate values for unavailable fields', () async {
    stubHappyPath();
    final container = buildContainer();
    container.read(systemInfoViewModelProvider.notifier);

    await flushMicrotasks();

    final state = container.read(systemInfoViewModelProvider);
    expect(state.memoryInfo!.totalBytes.display(), 'Not supported');
    expect(state.sensorInfo!.hasMagnetometer.display(), 'Unavailable');
    expect(state.sensorInfo!.hasProximity.display(), 'Not supported');
  });

  test('surfaces an unexpected repository failure as an error state', () async {
    when(() => repository.getDeviceInfo()).thenThrow(Exception('channel crash'));
    final container = buildContainer();
    container.read(systemInfoViewModelProvider.notifier);

    await flushMicrotasks();

    final state = container.read(systemInfoViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.hasError, isTrue);
  });

  test('refresh reloads all sections', () async {
    stubHappyPath();
    final container = buildContainer();
    final viewModel = container.read(systemInfoViewModelProvider.notifier);

    // Let the automatic initial load (scheduled by build()) complete — 1st call.
    await flushMicrotasks();

    await viewModel.refresh(); // 2nd call

    verify(() => repository.getDeviceInfo()).called(2);
  });
}
