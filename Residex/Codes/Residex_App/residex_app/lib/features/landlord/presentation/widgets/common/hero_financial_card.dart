import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';

class HeroFinancialCard extends StatelessWidget {
  final double amount;
  final String currency;
  final double changePercentage;
  final String period;
  final String? title;
  final String? subtitle;

  const HeroFinancialCard({
    super.key,
    required this.amount,
    required this.currency,
    required this.changePercentage,
    required this.period,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercentage >= 0;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue600.withValues(alpha: 0.4),
            AppColors.deepSpace,
            AppColors.deepSpace,
          ],
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: AppColors.blue500.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue600.withValues(alpha: 0.3),
            blurRadius: 24,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Wallet icon watermark
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.wallet_outlined,
              size: 120,
              color: AppColors.blue500.withValues(alpha: 0.1),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                (title ?? 'Projected Revenue').toUpperCase(),
                style: AppTextStyles.label.copyWith(
                  color: AppColors.blue400.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              // Amount
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currency,
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 18,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    amount.toStringAsFixed(2),
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Change badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPositive
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.error.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositive ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${isPositive ? '+' : ''}${changePercentage.toStringAsFixed(1)}% vs ${subtitle ?? period}',
                      style: AppTextStyles.label.copyWith(
                        color: isPositive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, curve: Curves.easeOut);
  }
}
