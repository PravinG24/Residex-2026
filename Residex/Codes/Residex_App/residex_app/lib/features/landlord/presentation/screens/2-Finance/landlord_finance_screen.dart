import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../widgets/common/revenue_chart.dart';

/// Landlord Finance Screen — Income & Expense Analytics
class LandlordFinanceScreen extends ConsumerWidget {
  const LandlordFinanceScreen({super.key});

  static const _netIncome = 14250.0;
  static const _collected = 13800.0;
  static const _pending = 450.0;
  static const _revenueChange = 12.5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: Stack(
        children: [
          // Ambient blue radial gradient
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

          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    20, 0, 20,
                    120 + MediaQuery.of(context).padding.bottom,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // 1. Finance Hero Card
                      const _FinanceHeroCard(
                        netIncome: _netIncome,
                        collected: _collected,
                        pending: _pending,
                        changePercentage: _revenueChange,
                        month: 'OCT 2024',
                      ),

                      const SizedBox(height: 20),

                      // 2. Rent Collection list
                      const _RentCollectionWidget(),

                      const SizedBox(height: 20),

                      // 3. Revenue trend chart (kept — already animated)
                      const RevenueChart(
                        monthlyData: [65, 78, 45, 92, 85, 100],
                        months: ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
                      ),

                      const SizedBox(height: 20),

                      // 4. Expense breakdown
                      const _ExpenseBreakdownWidget(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.blue500.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.blue500.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.trending_up, color: AppColors.blue500, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Finance Hub',
                  style:
                      AppTextStyles.heading2.copyWith(letterSpacing: -0.5)),
              Text(
                'INCOME & EXPENSES',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.blue500.withValues(alpha: 0.8),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Finance Hero Card
// Big income number + collected/pending breakdown in one card
// ──────────────────────────────────────────────────────────────────────────────

class _FinanceHeroCard extends StatelessWidget {
  final double netIncome;
  final double collected;
  final double pending;
  final double changePercentage;
  final String month;

  const _FinanceHeroCard({
    required this.netIncome,
    required this.collected,
    required this.pending,
    required this.changePercentage,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercentage >= 0;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue600.withValues(alpha: 0.45),
            AppColors.deepSpace,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.blue500.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
              color: AppColors.blue600.withValues(alpha: 0.3),
              blurRadius: 28),
        ],
      ),
      child: Stack(
        children: [
          // Watermark icon
          Positioned(
            top: -8,
            right: -8,
            child: Icon(Icons.account_balance_wallet_outlined,
                size: 110, color: AppColors.blue500.withValues(alpha: 0.08)),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: label + month badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NET INCOME',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.blue400.withValues(alpha: 0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Text(
                      month,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Big amount
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'RM ',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    '${(netIncome / 1000).toStringAsFixed(1)}k',
                    style: GoogleFonts.inter(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Change badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPositive
                        ? AppColors.success.withValues(alpha: 0.3)
                        : AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 13,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${isPositive ? '+' : ''}${changePercentage.toStringAsFixed(1)}% vs last month',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isPositive
                            ? AppColors.success
                            : AppColors.error,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Divider
              Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.07)),

              const SizedBox(height: 18),

              // Collected + Pending row
              Row(
                children: [
                  Expanded(
                    child: _StatPill(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'COLLECTED',
                      value:
                          'RM ${(collected / 1000).toStringAsFixed(1)}k',
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatPill(
                      icon: Icons.schedule_rounded,
                      label: 'PENDING',
                      value: 'RM ${pending.toStringAsFixed(0)}',
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, curve: Curves.easeOut);
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Rent Collection Widget
// Mini list of tenants with payment status — mirrors the Occupancy widget
// ──────────────────────────────────────────────────────────────────────────────

class _RentCollectionWidget extends StatelessWidget {
  const _RentCollectionWidget();

  static const _tenants = [
    _TenantPayment('Ali Rahman', 'Unit 4-2', _PayStatus.paid, 1800),
    _TenantPayment('Sarah Tan', 'Block B-12', _PayStatus.pending, 2200),
    _TenantPayment('Michael Wong', 'Unit 15-A', _PayStatus.paid, 3500),
  ];

  @override
  Widget build(BuildContext context) {
    const paid = 2;
    const total = 3;
    final percent = (paid / total * 100).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.blue500.withValues(alpha: 0.08),
                AppColors.blue600.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppColors.blue500.withValues(alpha: 0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.payments_outlined,
                            color: AppColors.success, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rent Collection',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'MONTHLY STATUS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '$paid/$total PAID',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.success,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Tenant rows — each in its own bubble
              ..._tenants.map((t) => _TenantPaymentRow(data: t)),

              const SizedBox(height: 10),

              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: paid / total,
                        backgroundColor: AppColors.slate800,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.success),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$percent%',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.success,
                    ),
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

enum _PayStatus { paid, pending, overdue }

class _TenantPayment {
  final String name;
  final String unit;
  final _PayStatus status;
  final double amount;
  const _TenantPayment(this.name, this.unit, this.status, this.amount);
}

class _TenantPaymentRow extends StatelessWidget {
  final _TenantPayment data;
  const _TenantPaymentRow({required this.data});

  Color get _statusColor {
    switch (data.status) {
      case _PayStatus.paid:
        return AppColors.success;
      case _PayStatus.pending:
        return AppColors.warning;
      case _PayStatus.overdue:
        return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (data.status) {
      case _PayStatus.paid:
        return 'PAID';
      case _PayStatus.pending:
        return 'PENDING';
      case _PayStatus.overdue:
        return 'OVERDUE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: _statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: _statusColor.withValues(alpha: 0.5),
                    blurRadius: 5),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Name + unit (left, expanded)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  data.unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Amount + status pill (right, stacked)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'RM ${data.amount.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: _statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: _statusColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Expense Breakdown Widget
// Redesigned with big text, left accent bars, and percentage pills
// ──────────────────────────────────────────────────────────────────────────────

class _ExpenseBreakdownWidget extends StatelessWidget {
  const _ExpenseBreakdownWidget();

  static const _expenses = [
    _ExpenseItem('Maintenance', 2400, 45, AppColors.error),
    _ExpenseItem('Utilities', 1600, 30, AppColors.blue500),
    _ExpenseItem('Insurance', 800, 15, AppColors.warning),
    _ExpenseItem('Services', 530, 10, AppColors.slate400),
  ];

  static const _total = 5330.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.blue500.withValues(alpha: 0.08),
                AppColors.blue600.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppColors.blue500.withValues(alpha: 0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Left: icon + title (takes remaining space)
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(LucideIcons.pieChart,
                              color: AppColors.purple, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expense Breakdown',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'THIS MONTH',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Right: total amount (fixed, measured first)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'RM ${_total.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Expense rows
              ..._expenses.map((e) => _ExpenseRow(item: e)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpenseItem {
  final String label;
  final double amount;
  final double percentage;
  final Color color;
  const _ExpenseItem(this.label, this.amount, this.percentage, this.color);
}

class _ExpenseRow extends StatelessWidget {
  final _ExpenseItem item;
  const _ExpenseRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left accent bar
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                    color: item.color.withValues(alpha: 0.5), blurRadius: 6),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Label + bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'RM ${item.amount.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: item.color.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '${item.percentage.toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: item.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.percentage / 100,
                    backgroundColor: AppColors.slate800,
                    valueColor: AlwaysStoppedAnimation<Color>(item.color),
                    minHeight: 6,
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
