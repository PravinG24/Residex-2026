import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

class LandlordDashboardScreen extends StatelessWidget {
  const LandlordDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asset Command',
                        style: AppTextStyles.h1,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '4 Properties • 12 Tenants',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.bell),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Property Pulse Hero Card
              _PropertyPulseCard(
                score: 87,
                openIssues: 2,
                collections: 95.5,
              ),

              const SizedBox(height: 20),

              // Reputation Card
              _ReputationCard(
                rating: 4.7,
                totalReviews: 23,
              ),

              const SizedBox(height: 20),

              // Operations Row
              Row(
                children: [
                  Expanded(
                    child: _OperationButton(
                      icon: LucideIcons.wrench,
                      label: 'Maintenance',
                      count: 2,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OperationButton(
                      icon: LucideIcons.users,
                      label: 'Tenants',
                      count: 12,
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Quick Actions Grid
              const Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _QuickActionCard(
                    icon: LucideIcons.brain,
                    label: 'AI Assistant',
                    gradient: AppGradients.primaryButton,
                    onTap: () {},
                  ),
                  _QuickActionCard(
                    icon: LucideIcons.trendingUp,
                    label: 'Financials',
                    gradient: const LinearGradient(
                      colors: [AppColors.emerald500, AppColors.cyan500],
                    ),
                    onTap: () {},
                  ),
                  _QuickActionCard(
                    icon: LucideIcons.fileText,
                    label: 'Documents',
                    gradient: const LinearGradient(
                      colors: [AppColors.orange500, AppColors.rose500],
                    ),
                    onTap: () {},
                  ),
                  _QuickActionCard(
                    icon: LucideIcons.users,
                    label: 'Community',
                    gradient: const LinearGradient(
                      colors: [AppColors.purple500, AppColors.indigo500],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyPulseCard extends StatelessWidget {
  final int score;
  final int openIssues;
  final double collections;

  const _PropertyPulseCard({
    required this.score,
    required this.openIssues,
    required this.collections,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PROPERTY PULSE', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppGradients.synced.createShader(bounds),
                child: Text(
                  score.toString(),
                  style: AppTextStyles.scoreMono.copyWith(
                    fontSize: 56,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '/100',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'OPEN ISSUES',
                  value: openIssues.toString(),
                  color: AppColors.orange500,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'COLLECTIONS',
                  value: '${collections.toStringAsFixed(1)}%',
                  color: AppColors.emerald500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.sectionLabel.copyWith(fontSize: 8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ReputationCard extends StatelessWidget {
  final double rating;
  final int totalReviews;

  const _ReputationCard({
    required this.rating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.cyan500, AppColors.blue600],
              ).scale(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.star,
              color: AppColors.cyan500,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('REPUTATION', style: AppTextStyles.sectionLabel),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      ' / 5.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$totalReviews reviews',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _OperationButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.indigo500, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '$count active',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient.scale(0.15),
          borderRadius: AppRadius.xlRadius,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Gradient {
  Gradient scale(double opacity) {
    if (this is LinearGradient) {
      final linear = this as LinearGradient;
      return LinearGradient(
        colors: linear.colors
            .map((c) => c.withValues(alpha: c.a * opacity))
            .toList(),
        begin: linear.begin,
        end: linear.end,
      );
    }
    return this;
  }
}