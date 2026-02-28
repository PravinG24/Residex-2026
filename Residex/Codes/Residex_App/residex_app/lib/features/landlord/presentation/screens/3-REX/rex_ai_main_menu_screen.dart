import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/glass_card.dart';
import '../../../../../../core/widgets/residex_logo.dart';
import '../../../../../../features/shared/domain/entities/users/app_user.dart';
import 'landlord_rex_ai_screen.dart';

/// Landlord REX tab — tenant Sync Hub aesthetic with landlord function cards.
class RexAIMainMenuScreen extends ConsumerWidget {
  const RexAIMainMenuScreen({super.key});

  void _openChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LandlordRexAIScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: Stack(
        children: [
          // Particle field
          const Positioned.fill(child: _ParticleField()),

          // Blue radial gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 500,
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

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                24,
                16,
                120 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Hero — animated rings + bot core
                  _HeroCore(onTap: () => _openChat(context)),

                  const SizedBox(height: 24),

                  // Status label
                  _buildStatusText(),

                  const SizedBox(height: 32),

                  // Pulsing chat shortcut button
                  _buildChatButton(context),

                  const SizedBox(height: 32),

                  // 2×2 function card grid
                  _buildCardGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Status text
  // ---------------------------------------------------------------------------
  Widget _buildStatusText() {
    return Column(
      children: [
        const Text(
          'SYSTEM ONLINE',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: AppColors.blue500,
            letterSpacing: 4,
            height: 1.0,
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 3.seconds, color: AppColors.blue400),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'A.I. NEURAL CORE',
              style: TextStyle(
                fontSize: 8,
                fontFamily: 'monospace',
                color: Colors.white.withValues(alpha: 0.4),
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Pulsing chat bubble shortcut
  // ---------------------------------------------------------------------------
  Widget _buildChatButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _openChat(context),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.blue500.withValues(alpha: 0.3),
              AppColors.purple.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.blue500.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue500.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: AppColors.blue400,
          size: 28,
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .fadeIn(duration: 2.seconds)
          .then()
          .fadeOut(duration: 2.seconds),
    );
  }

  // ---------------------------------------------------------------------------
  // 2×2 card grid — landlord function cards in tenant _GlassMetricCard style
  // ---------------------------------------------------------------------------
  Widget _buildCardGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _RexCard(
          label: 'REVENUE',
          value: 'RM 14.5k',
          subValue: '+8.4% Projected',
          icon: Icons.trending_up,
          accentColor: AppColors.success,
          progress: 85,
          onTap: () => _openChat(context),
        ),
        _RexCard(
          label: 'MAINTENANCE',
          value: '3 Alerts',
          subValue: 'Action Required',
          icon: Icons.build_outlined,
          accentColor: AppColors.warning,
          progress: 45,
          onTap: () => _openChat(context),
        ),
        _RexCard(
          label: 'LEASE GEN.',
          value: 'Contract',
          subValue: 'AI Draft Tool',
          icon: Icons.description_outlined,
          accentColor: AppColors.purple,
          progress: 100,
          onTap: () => _openChat(context),
        ),
        _RexCard(
          label: 'LAZY LOGGER',
          value: 'Indexer',
          subValue: 'AI Document Scan',
          icon: Icons.document_scanner_outlined,
          accentColor: AppColors.cyan500,
          progress: 100,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lazy Logger — Coming Soon')),
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
// Hero core widget — animated rings + central bot icon
// =============================================================================
class _HeroCore extends StatelessWidget {
  final VoidCallback onTap;
  const _HeroCore({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Deep core pulse glow — matches tenant (nearly invisible against deepSpace)
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.deepSpace.withValues(alpha: 0.2),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .fadeIn(duration: 2.seconds)
              .then()
              .fadeOut(duration: 2.seconds),

          // Ring 1: outer 260px — clockwise 20s
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.blue500.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: 20.seconds, curve: Curves.linear),

          // Ring 2: middle 200px — counter-clockwise 15s
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.blue400.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .rotate(
                duration: 15.seconds,
                curve: Curves.linear,
                begin: 1.0,
                end: 0.0,
              ),

          // Ring 3: inner 140px — pulsing
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.blue400.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .fadeIn(duration: 2.seconds)
              .then()
              .fadeOut(duration: 2.seconds),

          // Central Residex logo — same as tenant SyncHubScreen
          GestureDetector(
            onTap: onTap,
            child: ResidexLogo(
              size: 110,
              animate: true,
              syncState: SyncState.synced,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Function card — mirrors tenant _GlassMetricCard exactly
// =============================================================================
class _RexCard extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;
  final IconData icon;
  final Color accentColor;
  final double progress; // 0–100
  final VoidCallback onTap;

  const _RexCard({
    required this.label,
    required this.value,
    required this.subValue,
    required this.icon,
    required this.accentColor,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        opacity: 0.08,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: icon + blinking status dot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accentColor, size: 26),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .fadeIn(duration: 1.seconds)
                    .then()
                    .fadeOut(duration: 1.seconds),
              ],
            ),

            const Spacer(),

            // Big metric value
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Section label
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            // Sub-value / description
            Text(
              subValue,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Progress bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (progress / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Particle field — mirrored from tenant SyncHubScreen
// =============================================================================
class _ParticleField extends StatefulWidget {
  const _ParticleField();

  @override
  State<_ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<_ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _particles = List.generate(
      200,
      (i) => _Particle(
        angle: (i / 200) * 2 * math.pi,
        radius: 50.0 + (i % 3) * 80.0,
        speed: 0.2 + (i % 5) * 0.1,
        size: 1.0 + (i % 3),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  final double angle;
  final double radius;
  final double speed;
  final double size;

  const _Particle({
    required this.angle,
    required this.radius,
    required this.speed,
    required this.size,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    for (final p in particles) {
      final angle = p.angle + (animationValue * p.speed * 2 * math.pi);
      final x = center.dx + p.radius * math.cos(angle);
      final y = center.dy + p.radius * math.sin(angle);
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}
