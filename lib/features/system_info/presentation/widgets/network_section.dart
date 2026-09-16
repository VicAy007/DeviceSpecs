import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../domain/entities/network_info.dart';

class NetworkSection extends StatelessWidget {
  const NetworkSection({super.key, required this.info});

  final NetworkInfo info;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Network', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(label: 'Connection type', value: info.connectionType.display(), isPlaceholder: !info.connectionType.isAvailable),
          InfoRow(
            label: 'Connected',
            value: info.isConnected.display((v) => v ? 'Yes' : 'No'),
            isPlaceholder: !info.isConnected.isAvailable,
          ),
        ],
      ),
    );
  }
}
