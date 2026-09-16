import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/profile.dart';

/// Light / Dark / System theme switch. Applies immediately across the app
/// through [onChanged] -> ProfileViewModel.setThemePreference ->
/// ThemeViewModel, which the root MaterialApp watches.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AppThemePreference selected;
  final ValueChanged<AppThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Apparence', style: AppTypography.title),
          const SizedBox(height: 8),
          _option(context, AppThemePreference.light, Icons.wb_sunny_outlined, 'Mode clair'),
          _option(context, AppThemePreference.dark, Icons.nightlight_outlined, 'Mode sombre'),
          _option(context, AppThemePreference.system, Icons.smartphone_outlined, 'Mode système'),
        ],
      ),
    );
  }

  Widget _option(BuildContext context, AppThemePreference value, IconData icon, String label) {
    final isSelected = selected == value;
    return RadioListTile<AppThemePreference>(
      value: value,
      groupValue: selected,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.body),
        ],
      ),
      dense: true,
      selected: isSelected,
    );
  }
}
