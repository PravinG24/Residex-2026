import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Reusable ambient background for all landlord screens.
/// Renders deepSpace bg + radial gradient accent at top center.
///
/// Usage:
/// ```dart
/// AmbientBackground(
///   child: YourContent(),
/// )
/// // With custom accent (e.g. purple for REX screen):
/// AmbientBackground(
///   accentColor: AppColors.purple500,
///   child: YourContent(),
/// )
/// ```
class AmbientBackground extends StatelessWidget {
  final Color accentColor;
  final double accentAlpha;
  final Widget? child;

  const AmbientBackground({
    super.key,
    this.accentColor = AppColors.blue600,
    this.accentAlpha = 0.5,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deepSpace,
      child: Stack(
        children: [
          // Radial gradient accent at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 600,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    accentColor.withValues(alpha: accentAlpha),
                    AppColors.deepSpace.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Content
          if (child != null) child!,
        ],
      ),
    );
  }
}
