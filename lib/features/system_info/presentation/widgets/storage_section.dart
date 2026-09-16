import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../../../core/widgets/usage_bar.dart';
import '../../domain/entities/storage_info.dart';

class StorageSection extends StatelessWidget {
  const StorageSection({super.key, required this.info});

  final StorageInfo info;

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
          Text('Storage', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(label: 'Total', value: info.totalBytes.display(_formatBytes), isPlaceholder: !info.totalBytes.isAvailable),
          InfoRow(label: 'Free', value: info.freeBytes.display(_formatBytes), isPlaceholder: !info.freeBytes.isAvailable),
          InfoRow(label: 'Used', value: info.usedBytes.display(_formatBytes), isPlaceholder: !info.usedBytes.isAvailable),
          const SizedBox(height: AppSpacing.sm),
          if (usage.isAvailable)
            UsageBar(value: usage.value!, color: AppColors.secondary)
          else
            Text(usage.display(), style: AppTypography.caption),
        ],
      ),
    );
  }
}
