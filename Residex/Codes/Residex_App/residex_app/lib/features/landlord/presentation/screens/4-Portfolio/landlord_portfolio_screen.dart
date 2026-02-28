import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../providers/landlord_portfolio_provider.dart';
import '../../widgets/common/property_card.dart';
import 'sub/tenant_list_screen.dart';

/// Landlord Portfolio Screen — Property Management
class LandlordPortfolioScreen extends ConsumerStatefulWidget {
  const LandlordPortfolioScreen({super.key});

  @override
  ConsumerState<LandlordPortfolioScreen> createState() =>
      _LandlordPortfolioScreenState();
}

class _LandlordPortfolioScreenState
    extends ConsumerState<LandlordPortfolioScreen> {
  PropertyFilter _currentFilter = PropertyFilter.all;

  @override
  Widget build(BuildContext context) {
    final properties = ref.watch(portfolioPropertiesProvider);
    final stats = ref.watch(portfolioStatsProvider);

    final filteredProperties = properties.where((p) {
      switch (_currentFilter) {
        case PropertyFilter.occupied:
          return p.status == PropertyStatus.occupied;
        case PropertyFilter.vacant:
          return p.status == PropertyStatus.vacant;
        case PropertyFilter.all:
          return true;
      }
    }).toList();

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
                SliverToBoxAdapter(child: _buildHeader(context)),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    20, 0, 20,
                    120 + MediaQuery.of(context).padding.bottom,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Portfolio summary hero card
                      _PortfolioSummaryWidget(stats: stats),

                      const SizedBox(height: 28),

                      // Filter bar
                      _buildFilterBar(filteredProperties.length),

                      const SizedBox(height: 16),

                      // Property list
                      ...filteredProperties.map((property) => PropertyCard(
                            propertyName: property.name,
                            unitNumber: property.unitNumber,
                            address: property.address,
                            status: property.status,
                            tenantName: property.tenantName,
                            rentStatus: property.rentStatus,
                            monthlyRent: property.monthlyRent,
                            onTap: () =>
                                _showPropertyDetails(context, property),
                          )),

                      if (filteredProperties.isEmpty) _buildEmptyState(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddPropertyButton(),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            child: Icon(Icons.business_outlined,
                color: AppColors.blue400, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Asset Portfolio',
                    style:
                        AppTextStyles.heading2.copyWith(letterSpacing: -0.5)),
                Text(
                  'PROPERTY MANAGEMENT',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.blue400.withValues(alpha: 0.8),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          // Tenant Directory button
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TenantListScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.people_outline,
                  color: AppColors.success, size: 20),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildFilterBar(int propertyCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'PROPERTIES',
              style: AppTextStyles.label.copyWith(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.blue500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.blue500.withValues(alpha: 0.3)),
              ),
              child: Text(
                '$propertyCount',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.blue500,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildFilterChip('All', PropertyFilter.all),
            const SizedBox(width: 8),
            _buildFilterChip('Occupied', PropertyFilter.occupied),
            const SizedBox(width: 8),
            _buildFilterChip('Vacant', PropertyFilter.vacant),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, PropertyFilter filter) {
    final isActive = _currentFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _currentFilter = filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.blue500.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.blue500.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isActive ? AppColors.blue400 : AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 56,
            color: AppColors.textMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text('No Properties Found',
              style: AppTextStyles.titleLarge
                  .copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Text(
            'Add your first property to get started',
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textMuted.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPropertyButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue500, AppColors.blue600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.blue500.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Property — Coming Soon')),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'ADD UNIT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPropertyDetails(BuildContext context, Property property) {
    final statusColor = property.status == PropertyStatus.occupied
        ? AppColors.success
        : AppColors.blue400;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.blue500.withValues(alpha: 0.12),
                  AppColors.spaceBase,
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(
                  color: AppColors.blue500.withValues(alpha: 0.2)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Property name + status badge
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(property.name,
                                style: AppTextStyles.heading2),
                            const SizedBox(height: 4),
                            Text(
                              '${property.unitNumber} · ${property.address}',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          property.status == PropertyStatus.occupied
                              ? 'OCCUPIED'
                              : 'VACANT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: statusColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Detail rows as bubbles
                  _buildDetailRow(
                    Icons.payments_outlined,
                    'Monthly Rent',
                    'RM ${property.monthlyRent.toStringAsFixed(0)}',
                  ),
                  if (property.tenantName != null)
                    _buildDetailRow(
                      Icons.person_outline,
                      'Current Tenant',
                      property.tenantName!,
                    ),
                  if (property.rentStatus != null)
                    _buildDetailRow(
                      Icons.receipt_long_outlined,
                      'Payment Status',
                      property.rentStatus == RentStatus.paid
                          ? 'Paid'
                          : 'Pending',
                      valueColor: property.rentStatus == RentStatus.paid
                          ? AppColors.success
                          : AppColors.warning,
                    ),

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(LucideIcons.pencil,
                              size: 14, color: AppColors.blue400),
                          label: Text(
                            'EDIT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.blue400,
                              letterSpacing: 1,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color:
                                    AppColors.blue500.withValues(alpha: 0.3)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_forward,
                              size: 14, color: Colors.white),
                          label: const Text(
                            'VIEW FULL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue500,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Portfolio Summary Hero Card
// Big revenue number + occupancy breakdown + progress bar
// ──────────────────────────────────────────────────────────────────────────────

class _PortfolioSummaryWidget extends StatelessWidget {
  final PortfolioStats stats;
  const _PortfolioSummaryWidget({required this.stats});

  @override
  Widget build(BuildContext context) {
    final occupancyPercent = stats.occupancyRate.round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.blue600.withValues(alpha: 0.45),
                AppColors.deepSpace,
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border:
                Border.all(color: AppColors.blue500.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.blue600.withValues(alpha: 0.25),
                  blurRadius: 28),
            ],
          ),
          child: Stack(
            children: [
              // Watermark icon
              Positioned(
                top: -10,
                right: -10,
                child: Icon(
                  Icons.business_outlined,
                  size: 110,
                  color: AppColors.blue500.withValues(alpha: 0.07),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.blue500.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.business_outlined,
                            color: AppColors.blue400, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Portfolio Summary',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'ASSET OVERVIEW',
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

                  const SizedBox(height: 18),

                  // Revenue hero number
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'RM ',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '${(stats.totalMonthlyRevenue / 1000).toStringAsFixed(1)}k',
                        style: GoogleFonts.inter(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -2,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '/mo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Stat chips row
                  Row(
                    children: [
                      _StatChip(
                        value: '${stats.totalProperties}',
                        label: 'UNITS',
                        color: AppColors.blue400,
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        value: '${stats.occupiedUnits}',
                        label: 'OCCUPIED',
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        value: '${stats.vacantUnits}',
                        label: 'VACANT',
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Occupancy progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: stats.occupancyRate / 100,
                            backgroundColor: AppColors.slate800,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.blue400),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$occupancyPercent% OCCUPIED',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.blue400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, curve: Curves.easeOut);
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Property filter options
enum PropertyFilter { all, occupied, vacant }
