import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'tenant_score_detail_screen.dart';

/// Tenant Model with Score
class Tenant {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String unitNumber;
  final String propertyName;
  final int score;
  final String avatarInitials;
  final DateTime leaseStartDate;
  final DateTime leaseEndDate;
  final double monthlyRent;
  final int paymentStreak;
  final int maintenanceReports;
  final String tenancyDuration;

  Tenant({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.unitNumber,
    required this.propertyName,
    required this.score,
    required this.avatarInitials,
    required this.leaseStartDate,
    required this.leaseEndDate,
    required this.monthlyRent,
    required this.paymentStreak,
    required this.maintenanceReports,
    required this.tenancyDuration,
  });

  Color get scoreColor {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.blue500;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }

  String get scoreBadge {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Poor';
  }
}

/// Mock Tenant Provider
final tenantsProvider = Provider<List<Tenant>>((ref) {
  return [
    Tenant(
      id: '1',
      name: 'Ali Rahman',
      email: 'ali.rahman@example.com',
      phone: '+60 12-345 6789',
      unitNumber: 'Unit 4-2',
      propertyName: 'Verdi Eco-Dominium',
      score: 95,
      avatarInitials: 'AR',
      leaseStartDate: DateTime(2024, 1, 1),
      leaseEndDate: DateTime(2025, 12, 31),
      monthlyRent: 1800.0,
      paymentStreak: 10,
      maintenanceReports: 1,
      tenancyDuration: '10 months',
    ),
    Tenant(
      id: '2',
      name: 'Sarah Tan',
      email: 'sarah.tan@example.com',
      phone: '+60 16-789 0123',
      unitNumber: 'Block B-12',
      propertyName: 'The Grand Subang',
      score: 72,
      avatarInitials: 'ST',
      leaseStartDate: DateTime(2023, 6, 1),
      leaseEndDate: DateTime(2025, 5, 31),
      monthlyRent: 2200.0,
      paymentStreak: 6,
      maintenanceReports: 3,
      tenancyDuration: '1 year 4 months',
    ),
    Tenant(
      id: '3',
      name: 'Michael Wong',
      email: 'michael.wong@example.com',
      phone: '+60 19-234 5678',
      unitNumber: 'Unit 15-A',
      propertyName: 'Soho Suites KLCC',
      score: 88,
      avatarInitials: 'MW',
      leaseStartDate: DateTime(2023, 3, 1),
      leaseEndDate: DateTime(2025, 2, 28),
      monthlyRent: 3500.0,
      paymentStreak: 22,
      maintenanceReports: 0,
      tenancyDuration: '1 year 9 months',
    ),
  ];
});

/// Tenant List Screen with Score Ranking
class TenantListScreen extends ConsumerWidget {
  final String? propertyId;

  const TenantListScreen({
    super.key,
    this.propertyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tenants = ref.watch(tenantsProvider);

    // Sort by score (highest first)
    tenants = List.from(tenants)..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.textMuted,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TENANT DIRECTORY',
              style: AppTextStyles.heading2.copyWith(
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
            Text(
              '${tenants.length} ACTIVE TENANTS',
              style: AppTextStyles.label.copyWith(
                fontSize: 9,
                color: AppColors.textMuted,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Ambient background
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
                    AppColors.blue600.withValues(alpha: 0.5),
                    AppColors.deepSpace,
                    AppColors.deepSpace,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Tenant list
          ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: tenants.length,
            itemBuilder: (context, index) {
              final tenant = tenants[index];
              final rank = index + 1;
              return _TenantCard(
                tenant: tenant,
                rank: rank,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TenantScoreDetailScreen(tenant: tenant),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Tenant card with AnimatedScale press effect
class _TenantCard extends StatefulWidget {
  final Tenant tenant;
  final int rank;
  final VoidCallback onTap;

  const _TenantCard({
    required this.tenant,
    required this.rank,
    required this.onTap,
  });

  @override
  State<_TenantCard> createState() => _TenantCardState();
}

class _TenantCardState extends State<_TenantCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tenant = widget.tenant;
    final rank = widget.rank;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tenant.scoreColor.withValues(alpha: 0.1),
                      AppColors.blue500.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: tenant.scoreColor.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: tenant.scoreColor.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Rank badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: rank <= 3
                            ? AppColors.warning.withValues(alpha: 0.2)
                            : AppColors.slate800,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: rank <= 3
                              ? AppColors.warning.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '#$rank',
                          style: AppTextStyles.label.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: rank <= 3
                                ? AppColors.warning
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Avatar
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: tenant.scoreColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: tenant.scoreColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tenant.avatarInitials,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: tenant.scoreColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Tenant info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tenant.name,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tenant.propertyName} • ${tenant.unitNumber}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 12,
                                color: tenant.scoreColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${tenant.paymentStreak} months streak',
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 10,
                                  color: tenant.scoreColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Score
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: tenant.scoreColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: tenant.scoreColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '${tenant.score}',
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.w900,
                              color: tenant.scoreColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tenant.scoreBadge,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 9,
                            color: tenant.scoreColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 8),

                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
