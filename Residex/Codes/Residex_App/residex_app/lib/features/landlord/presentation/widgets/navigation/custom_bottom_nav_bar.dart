import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';

/// Navigation tab configuration
class NavTab {
  final IconData icon;
  final String label;

  const NavTab({
    required this.icon,
    required this.label,
  });
}

/// Tenant-style bottom navigation bar for the landlord shell.
/// Simple icon-only design — matching ResidexBottomNav aesthetics.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavTab> tabs;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  }) : assert(tabs.length == 5, 'CustomBottomNavBar requires exactly 5 tabs');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.deepSpace,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isActive = currentIndex == index;
            final isCenter = index == 2;

            if (isCenter) {
              return _buildCenterIcon(
                tab: tab,
                isActive: isActive,
                onTap: () => onTap(index),
              );
            }

            return _buildNavIcon(
              tab: tab,
              isActive: isActive,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required NavTab tab,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 80,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.blue500.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            tab.icon,
            size: 26,
            color: isActive ? AppColors.blue500 : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildCenterIcon({
    required NavTab tab,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 80,
        alignment: Alignment.center,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.deepSpace,
            border: Border.all(
              color: isActive
                  ? AppColors.blue500.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.blue500.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            LucideIcons.radio,
            size: 26,
            color: isActive ? AppColors.blue500 : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
