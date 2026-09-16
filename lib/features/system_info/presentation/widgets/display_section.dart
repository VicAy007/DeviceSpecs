import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../domain/entities/display_info.dart';

class DisplaySection extends StatelessWidget {
  const DisplaySection({super.key, required this.info});

  final DisplayInfo info;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Display', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(
            label: 'Resolution',
            value: (info.widthPx.isAvailable && info.heightPx.isAvailable)
                ? '${info.widthPx.value} × ${info.heightPx.value} px'
                : info.widthPx.display(),
            isPlaceholder: !(info.widthPx.isAvailable && info.heightPx.isAvailable),
          ),
          InfoRow(
            label: 'Pixel ratio',
            value: info.devicePixelRatio.display((v) => v.toStringAsFixed(2)),
            isPlaceholder: !info.devicePixelRatio.isAvailable,
          ),
          InfoRow(
            label: 'Logical size',
            value: (info.logicalWidth.isAvailable && info.logicalHeight.isAvailable)
                ? '${info.logicalWidth.value!.toStringAsFixed(0)} × ${info.logicalHeight.value!.toStringAsFixed(0)} dp'
                : info.logicalWidth.display(),
            isPlaceholder: !(info.logicalWidth.isAvailable && info.logicalHeight.isAvailable),
          ),
          InfoRow(label: 'Orientation', value: info.orientation.display(), isPlaceholder: !info.orientation.isAvailable),
        ],
      ),
    );
  }
}
