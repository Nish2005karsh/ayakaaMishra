import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../const/app_colors.dart';
import '../../provider/dashboard_provider.dart';
import 'tabs/home_tab.dart';
import 'tabs/trips_tab.dart';
import 'tabs/documents_tab.dart';
import 'tabs/profile_tab.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _pages = [
    HomeTab(),
    TripsTab(),
    DocumentsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        return PopScope(
          // When back is pressed:
          // • If there's tab history → go back to previous tab, stay in app
          // • If on Home (root) → allow normal back (exit app)
          canPop: !dashboard.canPopTab,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) dashboard.popTab();
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(
                index: dashboard.currentIndex, children: _pages),
            bottomNavigationBar: NavigationBar(
              selectedIndex: dashboard.currentIndex,
              onDestinationSelected: dashboard.setIndex,
              backgroundColor: AppColors.surface,
              indicatorColor: AppColors.primary,
              surfaceTintColor: Colors.transparent,
              shadowColor: AppColors.cardShadow,
              elevation: 8,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                _navDest(Icons.home_outlined, Icons.home_rounded, 'Home'),
                _navDest(Icons.route_outlined, Icons.route_rounded, 'Trips'),
                _navDest(
                    Icons.folder_outlined, Icons.folder_rounded, 'Documents'),
                _navDest(Icons.person_outline_rounded,
                    Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        );
      },
    );
  }

  NavigationDestination _navDest(
      IconData icon, IconData selectedIcon, String label) {
    return NavigationDestination(
      icon: Icon(icon, color: AppColors.textSecondary),
      selectedIcon: Icon(selectedIcon, color: AppColors.primaryDark),
      label: label,
    );
  }
}
