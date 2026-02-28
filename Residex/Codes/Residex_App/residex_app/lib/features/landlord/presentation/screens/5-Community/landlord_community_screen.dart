import 'dart:ui';                                                                                                                                                                                                                                                          
  import 'package:flutter/material.dart';                                                                                                                                                                                                                                    
  import 'package:flutter_riverpod/flutter_riverpod.dart';  
  import 'package:lucide_icons/lucide_icons.dart';
  import 'package:google_fonts/google_fonts.dart';
  import '../../../../../core/theme/app_theme.dart';
  import '../../../../../core/widgets/glass_card.dart';
  import '../../providers/landlord_community_provider.dart';

  class LandlordCommunityScreen extends ConsumerStatefulWidget {
    const LandlordCommunityScreen({super.key});

    @override
    ConsumerState<LandlordCommunityScreen> createState() =>
        _LandlordCommunityScreenState();
  }

  class _LandlordCommunityScreenState
      extends ConsumerState<LandlordCommunityScreen> {
    CommunityTab _currentTab = CommunityTab.feed;

    @override
    Widget build(BuildContext context) {
      final posts = ref.watch(filteredCommunityPostsProvider(_currentTab));

      return Scaffold(
        backgroundColor: AppColors.deepSpace,
        body: Stack(
          children: [
            // Blue radial gradient
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

            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: posts.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              24,
                              24,
                              24,
                              120 + MediaQuery.of(context).padding.bottom,
                            ),
                            itemCount: posts.length + 1,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              if (index == posts.length) {
                                return _buildEndOfFeed();
                              }
                              return _buildPostCard(posts[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFAB(),
      );
    }

    // ---------------------------------------------------------------------------
    // Header + Tabs
    // ---------------------------------------------------------------------------
    Widget _buildHeader() {
      return Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 16, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.blue500.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.blue500.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue500.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(LucideIcons.users,
                      size: 20, color: AppColors.blue400),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'DIGITAL BOARD',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue400,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tab pill wrapper
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  _buildTab(
                      CommunityTab.feed, 'Feed', LucideIcons.megaphone),
                  _buildTab(
                      CommunityTab.events, 'Events', LucideIcons.calendar),
                  _buildTab(
                      CommunityTab.market, 'Market', LucideIcons.shoppingBag),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildTab(CommunityTab tab, String label, IconData icon) {
      final isActive = _currentTab == tab;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _currentTab = tab),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.blue500 : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.blue500.withValues(alpha: 0.25),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 13,
                  color: isActive ? Colors.white : AppColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.textTertiary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // Post card — mirrors tenant CommunityBoardScreen._buildPostCard exactly,
    // blue accents instead of indigo.
    // ---------------------------------------------------------------------------
    Widget _buildPostCard(CommunityPost post) {
      final avatarColor = _avatarColor(post.author);
      final typeColor = _typeColor(post.type);
      final typeLabel = _typeLabel(post.type);

      return GlassCard(
        padding: const EdgeInsets.all(24),
        borderRadius: BorderRadius.circular(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: author avatar + name + type badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar circle with solid colour + glow
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: avatarColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: avatarColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _initials(post.author),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          post.timeAgo,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Type badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: typeColor.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (post.type == PostType.market) ...[
                        Icon(LucideIcons.tag, size: 9, color: typeColor),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        typeLabel,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: typeColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Title + price pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    post.title,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ),
                if (post.price != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: Text(
                      post.price!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              post.description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),

            const SizedBox(height: 20),

            // Footer: like + comment + share
            Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05), width: 1),
                ),
              ),
              child: Row(
                children: [
                  _buildAction(LucideIcons.heart,
                      post.likes.toString(), AppColors.rose500),
                  const SizedBox(width: 20),
                  _buildAction(LucideIcons.messageSquare,
                      post.comments.toString(), AppColors.blue500),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showCommentsSheet(context, post),
                    child: Icon(LucideIcons.share2,
                        size: 18, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildAction(IconData icon, String count, Color color) {
      return GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // FAB — blue gradient (matches portfolio FAB pattern)
    // ---------------------------------------------------------------------------
    Widget _buildFAB() {
      return Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue500, AppColors.blue600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue500.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Post — Coming Soon')),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'New Post',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // Empty state
    // ---------------------------------------------------------------------------
    Widget _buildEmptyState() {
      final icon = _currentTab == CommunityTab.market
          ? LucideIcons.shoppingBag
          : _currentTab == CommunityTab.events
              ? LucideIcons.calendar
              : LucideIcons.megaphone;

      final label = _currentTab == CommunityTab.feed
          ? 'No Active Announcements'
          : _currentTab == CommunityTab.events
              ? 'No Active Events'
              : 'No Active Listings';

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // End of feed
    // ---------------------------------------------------------------------------
    Widget _buildEndOfFeed() {
      final label = _currentTab == CommunityTab.feed
          ? 'End of Feed'
          : _currentTab == CommunityTab.events
              ? 'End of Events'
              : 'End of Listings';

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary.withValues(alpha: 0.4),
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // Comments bottom sheet — glass style
    // ---------------------------------------------------------------------------
    void _showCommentsSheet(BuildContext context, CommunityPost post) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.blue500.withValues(alpha: 0.12),
                    AppColors.deepSpace.withValues(alpha: 0.95),
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
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textMuted.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      post.title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${post.comments} Comments',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Comments feature coming soon...',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Close button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.blue500, AppColors.blue600],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(ctx),
                            borderRadius: BorderRadius.circular(14),
                            child: Center(
                              child: Text(
                                'Close',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                        height: MediaQuery.of(ctx).padding.bottom + 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------------------
    String _initials(String name) {
      final parts = name.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return (name.length >= 2 ? name.substring(0, 2) : name).toUpperCase();
    }

    Color _avatarColor(String name) {
      final colors = [
        AppColors.blue500,
        AppColors.purple,
        AppColors.emerald500,
        AppColors.amber500,
      ];
      return colors[name.hashCode.abs() % colors.length];
    }

    Color _typeColor(PostType type) {
      switch (type) {
        case PostType.alert:        return AppColors.rose500;
        case PostType.event:        return AppColors.emerald500;
        case PostType.market:       return AppColors.amber500;
        case PostType.announcement: return AppColors.blue400;
      }
    }

    String _typeLabel(PostType type) {
      switch (type) {
        case PostType.alert:        return 'ALERT';
        case PostType.event:        return 'EVENT';
        case PostType.market:       return 'MARKET';
        case PostType.announcement: return 'FEED';
      }
    }
  }