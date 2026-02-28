import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../landlord/domain/entities/property.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../features/shared/domain/entities/groups/app_group.dart';                                                                                                                                                                                                      


  class GroupActionModal extends StatefulWidget {
    final AppGroup group;
    final VoidCallback onEditGroup;
    final VoidCallback onViewBills;

    const GroupActionModal({
      super.key,
      required this.group,
      required this.onEditGroup,
      required this.onViewBills,
    });

    @override
    State<GroupActionModal> createState() => _GroupActionModalState();
  }

  class _GroupActionModalState extends State<GroupActionModal>
      with SingleTickerProviderStateMixin {
    late AnimationController _animController;
    late Animation<double> _slideAnimation;
    late Animation<double> _fadeAnimation;

    @override
    void initState() {
      super.initState();
      _animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _slideAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ));
      _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOut,
      ));
      _animController.forward();
    }

    @override
    void dispose() {
      _animController.dispose();
      super.dispose();
    }

    void _close() {
      _animController.reverse().then((_) => Navigator.pop(context));
    }

    void _handleAction(VoidCallback action) {
      _animController.reverse().then((_) {
        Navigator.pop(context);
        action();
      });
    }

    @override
    Widget build(BuildContext context) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: _close,
          child: Container(
            color: Colors.black.withValues(alpha: 0.7),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        0, MediaQuery.of(context).size.height * _slideAnimation.value),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {}, // Prevent tap from closing
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E293B),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(32)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(32)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildHandle(),
                                  _buildHeader(),
                                  const SizedBox(height: 24),
                                  _buildActionButtons(),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildHandle() {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }

    Widget _buildHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            // Group icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Color(widget.group.colorValue),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.group.emoji,
                  style: const TextStyle(
                    fontSize: 28,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Group info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.group.tenantIds.length} ${widget.group.tenantIds.length == 1 ? 'member' : 'members'}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.group.tenantIds.length} ${widget.group.tenantIds.length == 1 ? 'member' : 'members'}',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

   Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // View Bills Button - Cyan Gradient (matches New Bill button)
          _buildGradientActionButton(
            icon: Icons.receipt_long,
            label: "View Group's Bills",
            gradient: const LinearGradient(
              colors: [
                Color(0xFF22D3EE), // cyan-400
                Color(0xFF3B82F6), // blue-500
                Color(0xFF2563EB), // blue-600
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shadowColor: const Color(0xFF22D3EE),
            onTap: () => _handleAction(widget.onViewBills),
          ),
          const SizedBox(height: 12),
          // Edit Group Button - Purple Gradient (matches My Bills button)
          _buildGradientActionButton(
            icon: Icons.edit,
            label: 'Edit Group',
            gradient: const LinearGradient(
              colors: [
                Color(0xFFA855F7), // purple-500
                Color(0xFF9333EA), // purple-600
                Color(0xFFD946EF), // fuchsia-500
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shadowColor: const Color(0xFFA855F7),
            onTap: () => _handleAction(widget.onEditGroup),
          ),
        ],
      ),
    );
  }

    Widget _buildGradientActionButton({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.7),
              size: 16,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }
      }
  Future<void> showGroupActionModal({
    required BuildContext context,
    required AppGroup group,
    required VoidCallback onEditGroup,
    required VoidCallback onViewBills,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Group Actions',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return GroupActionModal(
          group: group,
          onEditGroup: onEditGroup,
          onViewBills: onViewBills,
        );
      },
    );
  }