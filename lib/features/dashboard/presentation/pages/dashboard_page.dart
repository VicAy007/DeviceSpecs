import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../view_models/dashboard_view_model.dart';
import '../widgets/battery_card.dart';
import '../widgets/cpu_frequency_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/device_summary_card.dart';
import '../widgets/memory_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/storage_card.dart';
import '../widgets/wifi_card.dart';

/// Page "Dashboard" de DeviceSpecs — vue d'ensemble santé système.
///
/// Autonome vis-à-vis des autres features (Authentication / System Info /
/// Profile) : elle ne dépend que du thème partagé (`lib/app/theme/`) et
/// d'un widget générique (`lib/core/widgets/gauge_ring_card.dart`).
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  void _handleQuickScan(BuildContext context, WidgetRef ref) {
    ref.read(dashboardViewModelProvider.notifier).runQuickScan();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quick Scan indisponible pour le moment')),
    );
  }

  void _handleSensorCheck(BuildContext context, WidgetRef ref) {
    ref.read(dashboardViewModelProvider.notifier).runSensorCheck();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sensor Check indisponible pour le moment')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const DashboardHeader(),
          Expanded(child: _buildBody(context, ref, state)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, DashboardState state) {
    switch (state.status) {
      case DashboardStatus.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.textPrimary));
      case DashboardStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.textMuted, size: 32),
                const SizedBox(height: 12),
                Text(state.errorMessage ?? 'Une erreur est survenue', textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 12),
                TextButton(onPressed: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
                    child: const Text('Réessayer', style: TextStyle(color: AppColors.textPrimary))),
              ],
            ),
          ),
        );
      case DashboardStatus.loaded:
        final d = state.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DeviceSummaryCard(deviceId: d.deviceId, deviceName: d.deviceName, osVersion: d.osVersion,
                  chipset: d.chipset, buildNumber: d.buildNumber, healthPercent: d.healthPercent),
              const SizedBox(height: 12),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: BatteryCard(percent: d.batteryPercent, temperatureCelsius: d.batteryTempCelsius,
                    chargerLabel: d.chargerLabel, chargeState: d.chargeState, cellHealth: d.cellHealth)),
                const SizedBox(width: 12),
                Expanded(child: MemoryCard(percent: d.ramPercent, ramType: d.ramType, freeGb: d.ramFreeGb,
                    activeHeapGb: d.activeHeapGb, totalGb: d.ramTotalGb, zramSwapGb: d.zramSwapGb)),
              ]),
              const SizedBox(height: 12),
              StorageCard(busLabel: d.storageBus, percent: d.storagePercent, usedGb: d.storageUsedGb,
                  totalGb: d.storageTotalGb, freeGb: d.storageFreeGb),
              const SizedBox(height: 12),
              CpuFrequencyCard(title: d.cpuName, coreLayout: d.cpuCoreLayout, loadPercent: d.cpuLoadPercent,
                  primeGhz: d.cpuFreqPrimeGhz, performanceGhz: d.cpuFreqPerformanceGhz,
                  efficiencyGhz: d.cpuFreqEfficiencyGhz, history: d.cpuLoadHistory),
              const SizedBox(height: 12),
              WifiCard(standard: d.wifiStandard, connected: d.wifiConnected, bandLabel: d.wifiBand,
                  downlinkMbps: d.downlinkMbps, linkPhyMbps: d.linkPhyMbps, latencyMs: d.latencyMs,
                  jitterMs: d.jitterMs, gatewayIp: d.gatewayIp),
              const SizedBox(height: 16),
              QuickActionsCard(onQuickScan: () => _handleQuickScan(context, ref),
                  onSensorCheck: () => _handleSensorCheck(context, ref)),
            ],
          ),
        );
    }
  }
}
