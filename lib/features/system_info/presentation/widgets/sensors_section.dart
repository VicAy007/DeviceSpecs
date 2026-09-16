import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/info_row.dart';
import '../../domain/entities/sensor_info.dart';

class SensorsSection extends StatelessWidget {
  const SensorsSection({super.key, required this.info});

  final SensorInfo info;

  String _presence(bool v) => v ? 'Present' : 'Not detected';

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sensors', style: AppTypography.title),
          const SizedBox(height: 4),
          InfoRow(
            label: 'Accelerometer',
            value: info.hasAccelerometer.display(_presence),
            isPlaceholder: !info.hasAccelerometer.isAvailable,
          ),
          InfoRow(
            label: 'Gyroscope',
            value: info.hasGyroscope.display(_presence),
            isPlaceholder: !info.hasGyroscope.isAvailable,
          ),
          InfoRow(
            label: 'Magnetometer',
            value: info.hasMagnetometer.display(_presence),
            isPlaceholder: !info.hasMagnetometer.isAvailable,
          ),
          InfoRow(
            label: 'Proximity',
            value: info.hasProximity.display(_presence),
            isPlaceholder: !info.hasProximity.isAvailable,
          ),
        ],
      ),
    );
  }
}
