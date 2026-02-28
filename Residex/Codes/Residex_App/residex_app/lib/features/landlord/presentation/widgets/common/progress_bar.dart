import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Occupancy or progress bar with glass card and glow effect
class ProgressBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final String? unit;
  final Color? color;

  const ProgressBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.unit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? AppColors.blue500;
    final percentage = value / maxValue;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.blue500.withValues(alpha: 0.1),
                AppColors.blue600.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.blue500.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '$value/$maxValue${unit != null ? ' $unit' : ''}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: progressColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: progressColor.withValues(alpha: 0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
