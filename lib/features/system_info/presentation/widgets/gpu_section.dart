import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../domain/entities/gpu_info.dart';

class GpuSection extends StatelessWidget {
  const GpuSection({super.key, required this.info});

  final GpuInfo info;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GPU', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(label: 'Renderer', value: info.renderer.display(), isPlaceholder: !info.renderer.isAvailable),
          InfoRow(label: 'Vendor', value: info.vendor.display(), isPlaceholder: !info.vendor.isAvailable),
          InfoRow(label: 'Graphics API', value: info.graphicsApi.display(), isPlaceholder: !info.graphicsApi.isAvailable),
        ],
      ),
    );
  }
}
