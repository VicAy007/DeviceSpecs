import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../domain/entities/device_info.dart';

class DeviceInfoSection extends StatelessWidget {
  const DeviceInfoSection({super.key, required this.info});

  final DeviceInfo info;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Device', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(label: 'Manufacturer', value: info.manufacturer.display(), isPlaceholder: !info.manufacturer.isAvailable),
          InfoRow(label: 'Model', value: info.model.display(), isPlaceholder: !info.model.isAvailable),
          InfoRow(label: 'Device name', value: info.deviceName.display(), isPlaceholder: !info.deviceName.isAvailable),
          InfoRow(label: 'OS', value: info.osName.display(), isPlaceholder: !info.osName.isAvailable),
          InfoRow(label: 'OS version', value: info.osVersion.display(), isPlaceholder: !info.osVersion.isAvailable),
          InfoRow(
            label: 'Physical device',
            value: info.isPhysicalDevice.display((v) => v ? 'Yes' : 'No (emulator/simulator)'),
            isPlaceholder: !info.isPhysicalDevice.isAvailable,
          ),
        ],
      ),
    );
  }
}
