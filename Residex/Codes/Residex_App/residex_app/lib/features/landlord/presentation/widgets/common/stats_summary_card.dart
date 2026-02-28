import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Two-column stat summary card (e.g., Collected vs Pending)
class StatsSummaryCard extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final IconData leftIcon;
  final Color leftColor;
  final String rightLabel;
  final String rightValue;
  final IconData rightIcon;
  final Color rightColor;

  const StatsSummaryCard({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.leftIcon,
    required this.leftColor,
    required this.rightLabel,
    required this.rightValue,
    required this.rightIcon,
    required this.rightColor,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  label: leftLabel,
                  value: leftValue,
                  icon: leftIcon,
                  color: leftColor,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              Expanded(
                child: _buildStatColumn(
                  label: rightLabel,
                  value: rightValue,
                  icon: rightIcon,
                  color: rightColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 12),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
