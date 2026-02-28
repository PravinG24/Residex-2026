import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../providers/landlord_command_provider.dart';
import 'sub/landlord_system_health_screen.dart';
import 'sub/landlord_maintenance_screen.dart';

/// Landlord Command Center — Dashboard overview
class LandlordCommandScreen extends ConsumerWidget {
  const LandlordCommandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(landlordCommandProvider);

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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Section: Command Modules ────────────────────
                      _SectionLabel(label: 'COMMAND MODULES'),
                      const SizedBox(height: 12),

                      // Row 1: Maintenance + Ghost Overlay
                      Row(
                        children: [
                          Expanded(
                            child: _CommandToolButton(
                              icon: LucideIcons.wrench,
                              title: 'Maintenance',
                              subtitle: 'ACTIVE TICKETS',
                              iconColor: AppColors.orange,
                              gradientStart: const Color(0xFFC2410C),
                              gradientEnd: const Color(0xFF7C2D12),
                              borderColor: AppColors.orange,
                              subtitleColor: const Color(0xFFFDBA74),
                              badge: '${stats.activeMaintenance}',
                              badgeColor: AppColors.orange,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LandlordMaintenanceScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _CommandToolButton(
                              icon: LucideIcons.scan,
                              title: 'Ghost Overlay',
                              subtitle: 'AR INSPECT',
                              iconColor: AppColors.purple500,
                              gradientStart: const Color(0xFF7C3AED),
                              gradientEnd: const Color(0xFF4C1D95),
                              borderColor: AppColors.purple500,
                              subtitleColor: const Color(0xFFC4B5FD),
                              showPing: true,
                              onTap: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Ghost Overlay — coming soon'),
                              )),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // FairFix Auditor — wide horizontal card
                      _CommandToolButtonWide(
                        icon: Icons.manage_search_rounded,
                        title: 'FairFix Auditor',
                        subtitle: 'AI-POWERED DAMAGE ASSESSMENT',
                        label: 'SCAN READY',
                        iconColor: AppColors.success,
                        gradientStart: const Color(0xFF059669),
                        gradientEnd: const Color(0xFF064E3B),
                        borderColor: AppColors.success,
                        subtitleColor: const Color(0xFF6EE7B7),
                        showPing: true,
                        onTap: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('FairFix Auditor — coming soon'),
                        )),
                      ),

                      const SizedBox(height: 28),

                      // ── Section: Portfolio Status ───────────────────
                      _SectionLabel(label: 'PORTFOLIO STATUS'),
                      const SizedBox(height: 12),

                      // Occupancy mini-list
                      _OccupancyWidget(
                        occupied: stats.occupiedUnits,
                        total: stats.totalUnits,
                      ),

                      const SizedBox(height: 12),

                      // System Health
                      _SystemHealthWidget(
                        score: stats.systemHealthScore,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LandlordSystemHealthScreen(
                              healthScore: stats.systemHealthScore,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.blue500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.blue500.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.blue600.withValues(alpha: 0.2),
                        blurRadius: 12),
                  ],
                ),
                child: Icon(Icons.dashboard_outlined,
                    color: AppColors.blue400, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Asset Command',
                      style: AppTextStyles.heading2
                          .copyWith(letterSpacing: -0.5)),
                  Text(
                    'PORTFOLIO OVERVIEW',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.blue400.withValues(alpha: 0.8),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.blue500.withValues(alpha: 0.3),
                          width: 2),
                    ),
                    child: const Center(
                      child: Text('LO',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Landlord Owner',
                          style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5)),
                      Text('PROPERTY OWNER',
                          style: AppTextStyles.label
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary, size: 18),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Section Label
// ──────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: AppColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Command Tool Button — compact square card (Maintenance, Ghost Overlay)
// Mirrors the _ToolkitButton pattern from the tenant dashboard
// ──────────────────────────────────────────────────────────────────────────────

class _CommandToolButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color gradientStart;
  final Color gradientEnd;
  final Color borderColor;
  final Color subtitleColor;
  final bool showPing;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _CommandToolButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.gradientStart,
    required this.gradientEnd,
    required this.borderColor,
    required this.subtitleColor,
    this.showPing = false,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  State<_CommandToolButton> createState() => _CommandToolButtonState();
}

class _CommandToolButtonState extends State<_CommandToolButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.gradientStart.withValues(alpha: 0.22),
                widget.gradientEnd.withValues(alpha: 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: widget.borderColor.withValues(alpha: 0.25), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon + badge row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: widget.iconColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.iconColor
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(widget.icon,
                                    color: Colors.white, size: 20),
                              ),
                              if (widget.showPing)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  )
                                      .animate(
                                          onPlay: (c) => c.repeat())
                                      .fadeIn(duration: 1.seconds)
                                      .then()
                                      .fadeOut(duration: 1.seconds)
                                      .scale(
                                        begin: const Offset(1.0, 1.0),
                                        end: const Offset(1.25, 1.25),
                                        duration: 2.seconds,
                                      ),
                                ),
                            ],
                          ),
                          if (widget.badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: widget.badgeColor!
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: widget.badgeColor!
                                        .withValues(alpha: 0.35)),
                              ),
                              child: Text(
                                widget.badge!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: widget.badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const Spacer(),

                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: widget.subtitleColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 16,
                  right: 16,
                  child: Icon(LucideIcons.chevronRight,
                      size: 14, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Command Tool Button Wide — horizontal full-width card (FairFix Auditor)
// ──────────────────────────────────────────────────────────────────────────────

class _CommandToolButtonWide extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String label;
  final Color iconColor;
  final Color gradientStart;
  final Color gradientEnd;
  final Color borderColor;
  final Color subtitleColor;
  final bool showPing;
  final VoidCallback onTap;

  const _CommandToolButtonWide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.iconColor,
    required this.gradientStart,
    required this.gradientEnd,
    required this.borderColor,
    required this.subtitleColor,
    this.showPing = false,
    required this.onTap,
  });

  @override
  State<_CommandToolButtonWide> createState() => _CommandToolButtonWideState();
}

class _CommandToolButtonWideState extends State<_CommandToolButtonWide> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.gradientStart.withValues(alpha: 0.22),
                widget.gradientEnd.withValues(alpha: 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: widget.borderColor.withValues(alpha: 0.25), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Row(
                    children: [
                      // Icon with optional ping
                      Stack(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: widget.iconColor,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      widget.iconColor.withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(widget.icon,
                                color: Colors.white, size: 22),
                          ),
                          if (widget.showPing)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              )
                                  .animate(onPlay: (c) => c.repeat())
                                  .fadeIn(duration: 1.seconds)
                                  .then()
                                  .fadeOut(duration: 1.seconds)
                                  .scale(
                                    begin: const Offset(1.0, 1.0),
                                    end: const Offset(1.25, 1.25),
                                    duration: 2.seconds,
                                  ),
                            ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      // Title + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: widget.subtitleColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.iconColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  widget.iconColor.withValues(alpha: 0.35)),
                        ),
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: widget.iconColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      Icon(LucideIcons.chevronRight,
                          size: 14, color: AppColors.textTertiary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Occupancy Mini-List Widget
// ──────────────────────────────────────────────────────────────────────────────

class _OccupancyWidget extends StatelessWidget {
  final int occupied;
  final int total;

  const _OccupancyWidget({required this.occupied, required this.total});

  static const _units = [
    _UnitData('Verdi Eco-Dominium', 'Unit 4-2', true),
    _UnitData('The Grand Subang', 'Block B-12', true),
    _UnitData('Soho Suites KLCC', 'Unit 15-A', true),
    _UnitData('Palm Heights', 'Studio 2', false),
  ];

  @override
  Widget build(BuildContext context) {
    final percent = (occupied / total * 100).round();

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
                          color: AppColors.blue500.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.apartment_outlined,
                            color: AppColors.blue400, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Occupancy',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'UNIT STATUS',
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
                      '$occupied/$total OCCUPIED',
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

              // Unit rows — each in its own bubble
              ..._units.map((u) => _UnitRow(data: u)),

              const SizedBox(height: 10),

              // Progress bar + percentage
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: occupied / total,
                        backgroundColor: AppColors.slate800,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.success),
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

class _UnitRow extends StatelessWidget {
  final _UnitData data;
  const _UnitRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final statusColor = data.isOccupied ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.18),
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
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: statusColor.withValues(alpha: 0.5),
                    blurRadius: 5),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Property name
          Expanded(
            child: Text(
              data.propertyName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Unit number
          Text(
            data.unitNumber,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(width: 8),
          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              data.isOccupied ? 'OCCUPIED' : 'VACANT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: statusColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitData {
  final String propertyName;
  final String unitNumber;
  final bool isOccupied;
  const _UnitData(this.propertyName, this.unitNumber, this.isOccupied);
}

// ──────────────────────────────────────────────────────────────────────────────
// System Health Widget — score circle + category bar indicators
// ──────────────────────────────────────────────────────────────────────────────

class _SystemHealthWidget extends StatelessWidget {
  final int score;
  final VoidCallback onTap;

  const _SystemHealthWidget({required this.score, required this.onTap});

  static const _categories = [
    _HealthCategory('PLUMBING', 0.90, AppColors.blue500),
    _HealthCategory('ELECTRICAL', 0.82, AppColors.success),
    _HealthCategory('HVAC', 0.75, AppColors.warning),
    _HealthCategory('STRUCTURE', 0.96, AppColors.blue400),
  ];

  Color get _scoreColor {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String get _scoreBadge {
    if (score >= 80) return 'OPTIMAL';
    if (score >= 60) return 'FAIR';
    return 'CRITICAL';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
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
                            color: _scoreColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.monitor_heart_outlined,
                              color: _scoreColor, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'System Health',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'ASSET DIAGNOSTICS',
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
                    Icon(LucideIcons.chevronRight,
                        size: 16, color: AppColors.textTertiary),
                  ],
                ),

                const SizedBox(height: 18),

                // Score circle + category bars
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Score circle
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _scoreColor.withValues(alpha: 0.4),
                            width: 3),
                        color: _scoreColor.withValues(alpha: 0.08),
                        boxShadow: [
                          BoxShadow(
                              color: _scoreColor.withValues(alpha: 0.25),
                              blurRadius: 20),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$score',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                              height: 1,
                            ),
                          ),
                          Text(
                            '/100',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge
                          Text(
                            _scoreBadge,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: _scoreColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Bar indicators
                          ..._categories
                              .map((c) => _CategoryBar(category: c)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final _HealthCategory category;
  const _CategoryBar({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              category.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.textMuted,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: category.value,
                backgroundColor: AppColors.slate800,
                valueColor:
                    AlwaysStoppedAnimation<Color>(category.color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${(category.value * 100).round()}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthCategory {
  final String label;
  final double value;
  final Color color;
  const _HealthCategory(this.label, this.value, this.color);
}
