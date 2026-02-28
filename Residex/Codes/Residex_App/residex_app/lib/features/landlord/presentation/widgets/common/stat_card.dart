import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Reusable statistical card with glass morphism effect
class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final String badge;
  final IconData badgeIcon;
  final Color gradientColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.badge,
    required this.badgeIcon,
    required this.gradientColor,
    this.onTap,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
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
              child: Stack(
                children: [
                  // Ambient glow
                  Positioned(
                    top: -24,
                    right: -24,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.gradientColor.withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradientColor.withValues(alpha: 0.3),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.heading1.copyWith(
                                fontSize: 30,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: widget.gradientColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.gradientColor
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.badgeIcon,
                                    size: 12,
                                    color: widget.gradientColor
                                        .withValues(alpha: 0.8),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.badge.toUpperCase(),
                                    style: AppTextStyles.label.copyWith(
                                      color: widget.gradientColor
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
