import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../../../core/widgets/usage_bar.dart';
import '../../domain/entities/memory_info.dart';

class MemorySection extends StatelessWidget {
  const MemorySection({super.key, required this.info});

  final MemoryInfo info;

  String _formatBytes(int bytes) {
    final gb = bytes / (1024 * 1024 * 1024);
    return '${gb.toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final usage = info.usagePercent;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Memory', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(label: 'Total RAM', value: info.totalBytes.display(_formatBytes), isPlaceholder: !info.totalBytes.isAvailable),
          InfoRow(label: 'Available RAM', value: info.availableBytes.display(_formatBytes), isPlaceholder: !info.availableBytes.isAvailable),
          InfoRow(label: 'Used RAM', value: info.usedBytes.display(_formatBytes), isPlaceholder: !info.usedBytes.isAvailable),
          const SizedBox(height: AppSpacing.sm),
          if (usage.isAvailable)
            UsageBar(value: usage.value!, color: AppColors.primary)
          else
            Text(usage.display(), style: AppTypography.caption),
        ],
      ),
    );
  }
}
