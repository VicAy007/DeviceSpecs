import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';

/// Notifications toggle + language selector. Kept generic/extensible for
/// future settings entries.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.language,
    required this.onLanguageChanged,
  });

  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final String language;
  final ValueChanged<String> onLanguageChanged;

  static const _availableLanguages = {'fr': 'Français', 'en': 'English'};

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Paramètres', style: AppTypography.title),
          const SizedBox(height: 4),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
            title: Text('Notifications', style: AppTypography.body),
            dense: true,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Langue', style: AppTypography.body),
            trailing: DropdownButton<String>(
              value: language,
              underline: const SizedBox.shrink(),
              items: _availableLanguages.entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (value) {
                if (value != null) onLanguageChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
