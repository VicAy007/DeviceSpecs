import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../../../core/widgets/usage_bar.dart';
import '../../domain/entities/battery_info.dart';

class BatterySection extends StatelessWidget {
  const BatterySection({super.key, required this.info});

  final BatteryInfo info;

  String _stateLabel(ChargeState state) {
    switch (state) {
      case ChargeState.charging:
        return 'Charging';
      case ChargeState.discharging:
        return 'Discharging';
      case ChargeState.full:
        return 'Full';
      case ChargeState.unknown:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Battery', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(label: 'Level', value: info.level.display((v) => '$v%'), isPlaceholder: !info.level.isAvailable),
          InfoRow(label: 'State', value: info.chargeState.display(_stateLabel), isPlaceholder: !info.chargeState.isAvailable),
          InfoRow(label: 'Power source', value: info.powerSource.display(), isPlaceholder: !info.powerSource.isAvailable),
          InfoRow(
            label: 'Battery saver',
            value: info.isInBatterySaveMode.display((v) => v ? 'On' : 'Off'),
            isPlaceholder: !info.isInBatterySaveMode.isAvailable,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (info.level.isAvailable)
            UsageBar(value: info.level.value! / 100, color: AppColors.success)
        ],
      ),
    );
  }
}
