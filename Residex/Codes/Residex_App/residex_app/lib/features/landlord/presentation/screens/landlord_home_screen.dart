import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '1-Command/landlord_command_screen.dart';
import '2-Finance/landlord_finance_screen.dart';
import '3-REX/rex_ai_tab_wrapper.dart';
import '4-Portfolio/landlord_portfolio_screen.dart';
import '5-Community/landlord_community_screen.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';

/// Landlord Home Screen with 5-tab bottom navigation
///
/// Navigation Tabs:
/// 1. Command - Dashboard overview and analytics
/// 2. Finance - Rental income and property expenses
/// 3. Rex AI - AI assistant (Lease Generator & Lazy Logger) [CENTER/PROTRUDING]
/// 4. Portfolio - Property management and listings
/// 5. Community - Tenant communication and announcements
class LandlordHomeScreen extends StatefulWidget {
  const LandlordHomeScreen({super.key});

  @override
  State<LandlordHomeScreen> createState() => _LandlordHomeScreenState();
}

class _LandlordHomeScreenState extends State<LandlordHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    LandlordCommandScreen(),
    LandlordFinanceScreen(),
    RexAITabWrapper(),
    LandlordPortfolioScreen(),
    LandlordCommunityScreen(),
  ];

  final List<NavTab> _navTabs = const [
    NavTab(icon: LucideIcons.layoutDashboard, label: 'Command'),
    NavTab(icon: LucideIcons.trendingUp,      label: 'Finance'),
    NavTab(icon: LucideIcons.radio,           label: 'Rex AI'),
    NavTab(icon: LucideIcons.building2,       label: 'Portfolio'),
    NavTab(icon: LucideIcons.users,           label: 'Community'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        tabs: _navTabs,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
