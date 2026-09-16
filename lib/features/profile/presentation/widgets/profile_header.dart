import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/profile.dart';

/// Avatar + name + email block at the top of the Profile page.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary.withOpacity(0.15),
          backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
          child: profile.avatarUrl == null
              ? Text(
                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                  style: AppTypography.headline.copyWith(color: AppColors.primary),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(profile.name, style: AppTypography.title),
        const SizedBox(height: 2),
        Text(profile.email, style: AppTypography.body.copyWith(color: secondary)),
      ],
    );
  }
}
