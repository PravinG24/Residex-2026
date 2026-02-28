import 'package:flutter/material.dart';
  import 'package:lucide_icons/lucide_icons.dart';
  import 'package:flutter_animate/flutter_animate.dart';
  import '../../../../core/theme/app_colors.dart';
  import '../../../../core/theme/app_text_styles.dart';
  import '../../../../core/widgets/glass_card.dart';

  /// Property Pulse Screen - Property Health Dashboard
  /// Shows health score, vitals, and AI insights for a property
  class PropertyPulseScreen extends StatefulWidget {
    const PropertyPulseScreen({super.key});

    @override
    State<PropertyPulseScreen> createState() => _PropertyPulseScreenState();
  }

  class _PropertyPulseScreenState extends State<PropertyPulseScreen>
      with SingleTickerProviderStateMixin {

    // State variables
    int healthScore = 87;
    final List<VitalCheck> vitals = [];
    final List<AIInsight> insights = [];

    // Animation controller for score counter
    late AnimationController _animationController;
    late Animation<double> _scoreAnimation;

    @override
    void initState() {
      super.initState();
      _loadMockData();
      _setupAnimation();
    }

    void _setupAnimation() {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      _scoreAnimation = Tween<double>(
        begin: 0,
        end: healthScore.toDouble(),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));

      _animationController.forward();
    }

    void _loadMockData() {
    setState(() {
      vitals.addAll([
        VitalCheck(
          title: 'Bills',
          status: 'All Paid',
          statusType: VitalStatus.ok,
          icon: LucideIcons.checkCircle,
          color: AppColors.emerald500,
        ),
        VitalCheck(
          title: 'Tickets',
          status: '2 Open',
          statusType: VitalStatus.warning,
          icon: LucideIcons.alertCircle,
          color: AppColors.orange500,
        ),
        VitalCheck(
          title: 'Chores',
          status: '92% Done',
          statusType: VitalStatus.ok,
          icon: LucideIcons.checkCircle,
          color: AppColors.emerald500,
        ),
        VitalCheck(
          title: 'Rent',
          status: 'Due In 5d',
          statusType: VitalStatus.ok,
          icon: LucideIcons.clock,
          color: AppColors.blue500,
        ),
      ]);

      insights.addAll([
        AIInsight(
          message: 'Maintenance response time improved by 15% this month',
          type: InsightType.positive,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        AIInsight(
          message: 'Rent collection rate is above average for your area',
          type: InsightType.positive,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        AIInsight(
          message: 'Consider scheduling AC maintenance before summer',
          type: InsightType.neutral,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ]);
    });
  }

    @override
    void dispose() {
      _animationController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.deepSpace,
        body: Stack(
          children: [
            // Gradient background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 400,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      AppColors.blue600.withValues(alpha: 0.3),
                      AppColors.deepSpace,
                      AppColors.deepSpace,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // App bar
                  SliverToBoxAdapter(child: _buildAppBar()),

                  // Content
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Health score card - Step 4.2
                        _buildHealthScoreCard(),

                        const SizedBox(height: 24),

                        // Vitals section - Step 4.3
                        _buildVitalsSection(),

                        const SizedBox(height: 24),

                        // AI Insights section - Step 4.4
                        _buildAIInsightsSection(),

                        const SizedBox(height: 80),
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

    Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),

          const SizedBox(width: 8),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Property Pulse',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'HEALTH DASHBOARD',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.blue400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildHealthScoreCard() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      borderRadius: BorderRadius.circular(32),
      child: Column(
        children: [
          // Circular progress indicator with score
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // Animated progress circle
                AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: _scoreAnimation.value / 100,
                        strokeWidth: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation(
                          _getScoreColor(healthScore),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    );
                  },
                ),

                // Score number
                AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _scoreAnimation.value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: _getScoreColor(healthScore),
                            fontFamily: 'monospace',
                            height: 1,
                          ),
                        ),
                        const Text(
                          '/100',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Label
          Text(
            'PROPERTY HEALTH',
            style: AppTextStyles.sectionLabel.copyWith(
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 8),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getScoreColor(healthScore).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getScoreColor(healthScore).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getScoreLabel(healthScore),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: _getScoreColor(healthScore),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms);
  }

  Color _getScoreColor(int score) {
    if (score >= 80) {
      return AppColors.emerald500;
    } else if (score >= 60) {
      return AppColors.cyan500;
    } else if (score >= 40) {
      return AppColors.orange500;
    } else {
      return AppColors.rose500;
    }
  }

  String _getScoreLabel(int score) {
    if (score >= 80) {
      return 'OPTIMAL';
    } else if (score >= 60) {
      return 'GOOD';
    } else if (score >= 40) {
      return 'NEEDS ATTENTION';
    } else {
      return 'CRITICAL';
    }
  }

    Widget _buildVitalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'VITALS CHECK',
              style: AppTextStyles.sectionLabel.copyWith(
                fontSize: 10,
              ),
            ),
            Text(
              'Last updated: Just now',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Vitals grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: vitals.length,
          itemBuilder: (context, index) {
            return _buildVitalCard(vitals[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildVitalCard(VitalCheck vital, int index) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: vital.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              vital.icon,
              color: vital.color,
              size: 20,
            ),
          ),

          // Title and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vital.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                vital.status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: vital.color,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.2);
  }

    Widget _buildAIInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          'AI INSIGHTS',
          style: AppTextStyles.sectionLabel.copyWith(
            fontSize: 10,
          ),
        ),

        const SizedBox(height: 16),

        // Insights list
        ...insights.map((insight) => _buildInsightCard(insight)).toList(),
      ],
    );
  }

  Widget _buildInsightCard(AIInsight insight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.purple500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                LucideIcons.sparkles,
                color: AppColors.purple500,
                size: 18,
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(insight.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
  }

  // ============================================================================
  // MODELS
  // ============================================================================

  /// Represents a vital check item
  class VitalCheck {
    final String title;
    final String status;
    final VitalStatus statusType;
    final IconData icon;
    final Color color;

    VitalCheck({
      required this.title,
      required this.status,
      required this.statusType,
      required this.icon,
      required this.color,
    });
  }

  /// Status type for vitals
  enum VitalStatus {
    ok,
    warning,
    critical,
  }

  /// Represents an AI insight
  class AIInsight {
    final String message;
    final InsightType type;
    final DateTime timestamp;

    AIInsight({
      required this.message,
      required this.type,
      required this.timestamp,
    });
  }

  /// Type of AI insight
  enum InsightType {
    positive,
    neutral,
    warning,
  }