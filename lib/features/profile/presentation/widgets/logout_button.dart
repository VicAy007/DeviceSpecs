import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Destructive logout action. The confirmation dialog lives here since it
/// is pure UI; the actual logout side-effect is delegated to the callback
/// (ProfileViewModel.logout via the page).
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onConfirmedLogout});

  final VoidCallback onConfirmedLogout;

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous devrez vous reconnecter pour accéder à votre compte.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Se déconnecter', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) onConfirmedLogout();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _confirm(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: const BorderSide(color: AppColors.error),
        minimumSize: const Size.fromHeight(48),
      ),
      icon: const Icon(Icons.logout),
      label: const Text('Déconnexion'),
    );
  }
}
