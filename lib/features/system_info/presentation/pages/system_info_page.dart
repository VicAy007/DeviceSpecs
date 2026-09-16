import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_models/system_info_view_model.dart';
import '../widgets/battery_section.dart';
import '../widgets/cpu_section.dart';
import '../widgets/device_info_section.dart';
import '../widgets/display_section.dart';
import '../widgets/gpu_section.dart';
import '../widgets/memory_section.dart';
import '../widgets/network_section.dart';
import '../widgets/sensors_section.dart';
import '../widgets/storage_section.dart';

/// System Info screen — orchestrates section widgets against a single
/// [SystemInfoViewModel]. The page itself contains no business logic: it
/// only reads state and renders loading/error/content for each section.
class SystemInfoPage extends ConsumerWidget {
  const SystemInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemInfoViewModelProvider);
    final viewModel = ref.read(systemInfoViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('System Info')),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: _buildBody(state, viewModel),
      ),
    );
  }

  Widget _buildBody(SystemInfoState state, SystemInfoViewModel viewModel) {
    if (state.hasError) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppErrorWidget(message: state.errorMessage!, onRetry: viewModel.refresh),
        ],
      );
    }

    if (state.isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: 9,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, __) => const LoadingWidget(height: 100, lines: 4),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        DeviceInfoSection(info: state.deviceInfo!),
        const SizedBox(height: AppSpacing.md),
        CpuSection(info: state.cpuInfo!),
        const SizedBox(height: AppSpacing.md),
        GpuSection(info: state.gpuInfo!),
        const SizedBox(height: AppSpacing.md),
        MemorySection(info: state.memoryInfo!),
        const SizedBox(height: AppSpacing.md),
        StorageSection(info: state.storageInfo!),
        const SizedBox(height: AppSpacing.md),
        BatterySection(info: state.batteryInfo!),
        const SizedBox(height: AppSpacing.md),
        DisplaySection(info: state.displayInfo!),
        const SizedBox(height: AppSpacing.md),
        NetworkSection(info: state.networkInfo!),
        const SizedBox(height: AppSpacing.md),
        SensorsSection(info: state.sensorInfo!),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
