import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../providers/landlord_community_provider.dart';

/// Community post card for feed, events, and marketplace
class CommunityPostCard extends StatefulWidget {
  final CommunityPost post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const CommunityPostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: ClipRRect(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Author info and post type badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Author avatar and name
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _getAvatarGradient(widget.post.author),
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _getAvatarGradient(widget.post.author)[0]
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(widget.post.author),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.author,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.post.timeAgo,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Post type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeBadgeColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getTypeBadgeColor().withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.post.type == PostType.market)
                                Icon(
                                  Icons.local_offer,
                                  size: 10,
                                  color: _getTypeBadgeColor(),
                                ),
                              if (widget.post.type == PostType.market)
                                const SizedBox(width: 4),
                              Text(
                                widget.post.type.name.toUpperCase(),
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 9,
                                  color: _getTypeBadgeColor(),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Post content
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.title,
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.post.description,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Price tag (for marketplace items)
                        if (widget.post.price != null) ...[
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              widget.post.price!,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Footer actions
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.favorite_border,
                            count: widget.post.likes,
                            color: AppColors.error,
                            onTap: widget.onLike,
                          ),
                          const SizedBox(width: 20),
                          _buildActionButton(
                            icon: Icons.chat_bubble_outline,
                            count: widget.post.comments,
                            color: AppColors.purple,
                            onTap: widget.onComment,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: widget.onShare,
                            icon: Icon(
                              Icons.share_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
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
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: AppTextStyles.bodySmall
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  List<Color> _getAvatarGradient(String name) {
    final index = name.hashCode.abs() % AppColors.avatarGradients.length;
    return AppColors.avatarGradients[index];
  }

  Color _getTypeBadgeColor() {
    switch (widget.post.type) {
      case PostType.alert:
        return AppColors.error;
      case PostType.event:
        return AppColors.success;
      case PostType.market:
        return AppColors.warning;
      case PostType.announcement:
        return AppColors.blue500;
    }
  }
}
