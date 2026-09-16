import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Skeleton/shimmer-style placeholder shown while a section is loading.
/// Kept dependency-free (no external shimmer package) using a simple
/// opacity pulse via [AnimatedOpacity] cycles.
class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key, this.height = 64, this.lines = 1});

  final double height;
  final int lines;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white12 : Colors.black12;
    return FadeTransition(
      opacity: _controller.drive(Tween(begin: 0.4, end: 1.0)),
      child: Column(
        children: List.generate(
          widget.lines,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i == widget.lines - 1 ? 0 : AppSpacing.sm),
            child: Container(
              height: widget.height / widget.lines,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
