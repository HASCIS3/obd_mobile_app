import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../router/route_names.dart';

/// Scaffold principal avec bottom navigation
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Athlètes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            activeIcon: Icon(Icons.check_circle),
            label: 'Présences',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            activeIcon: Icon(Icons.payment),
            label: 'Paiements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RouteNames.dashboard)) return 0;
    if (location.startsWith(RouteNames.athletes)) return 1;
    if (location.startsWith(RouteNames.presences)) return 2;
    if (location.startsWith(RouteNames.paiements)) return 3;
    if (location.startsWith(RouteNames.profile)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteNames.dashboard);
        break;
      case 1:
        context.go(RouteNames.athletes);
        break;
      case 2:
        context.go(RouteNames.presences);
        break;
      case 3:
        context.go(RouteNames.paiements);
        break;
      case 4:
        context.go(RouteNames.profile);
        break;
    }
  }
}
