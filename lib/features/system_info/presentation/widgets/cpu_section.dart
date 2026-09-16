import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../domain/entities/cpu_info.dart';

class CpuSection extends StatelessWidget {
  const CpuSection({super.key, required this.info});

  final CpuInfo info;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CPU', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(label: 'Architecture', value: info.architecture.display(), isPlaceholder: !info.architecture.isAvailable),
          InfoRow(label: 'Cores', value: info.numberOfCores.display(), isPlaceholder: !info.numberOfCores.isAvailable),
          InfoRow(label: 'ABI', value: info.abi.display(), isPlaceholder: !info.abi.isAvailable),
          InfoRow(
            label: 'Supported ABIs',
            value: info.supportedAbis.display((v) => v.join(', ')),
            isPlaceholder: !info.supportedAbis.isAvailable,
          ),
        ],
      ),
    );
  }
}
