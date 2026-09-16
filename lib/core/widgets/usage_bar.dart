import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Animated horizontal progress bar used for RAM / Storage / Battery
/// usage. Animates from 0 to [value] on first build for a subtle, purposeful
/// micro-interaction (communicates the reading rather than decorating it).
class UsageBar extends StatelessWidget {
  const UsageBar({super.key, required this.value, this.color});

  /// 0.0 - 1.0. Clamped defensively.
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final track = isDark ? Colors.white12 : Colors.black12;
    final fillColor = color ?? AppColors.primary;
    final clamped = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: clamped),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) => LinearProgressIndicator(
          value: animatedValue,
          minHeight: 8,
          backgroundColor: track,
          valueColor: AlwaysStoppedAnimation(fillColor),
        ),
      ),
    );
  }
}
