import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/athletes/presentation/pages/athletes_page.dart';
import '../../features/athletes/presentation/pages/athlete_detail_page.dart';
import '../../features/athletes/presentation/pages/athlete_form_page.dart';
import '../../features/presences/presentation/pages/presences_page.dart';
import '../../features/paiements/presentation/pages/paiements_page.dart';
import '../../features/paiements/presentation/pages/paiement_form_page.dart';
import '../../features/performances/presentation/pages/performances_page.dart';
import '../../features/performances/presentation/pages/performance_form_page.dart';
import '../../features/disciplines/presentation/pages/disciplines_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../widgets/main_scaffold.dart';
import 'route_names.dart';

/// Configuration du routeur de l'application
class AppRouter {
  final bool isAuthenticated;

  AppRouter({this.isAuthenticated = false});

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Main app with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: RouteNames.dashboard,
            name: RouteNames.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),

          // Athletes
          GoRoute(
            path: RouteNames.athletes,
            name: RouteNames.athletes,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AthletesPage(),
            ),
            routes: [
              GoRoute(
                path: RouteNames.athleteCreate,
                name: RouteNames.athleteCreate,
                builder: (context, state) => const AthleteFormPage(),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.athleteDetail,
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AthleteDetailPage(athleteId: id);
                },
                routes: [
                  GoRoute(
                    path: RouteNames.athleteEdit,
                    name: RouteNames.athleteEdit,
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return AthleteFormPage(athleteId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Presences
          GoRoute(
            path: RouteNames.presences,
            name: RouteNames.presences,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PresencesPage(),
            ),
          ),

          // Paiements
          GoRoute(
            path: RouteNames.paiements,
            name: RouteNames.paiements,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PaiementsPage(),
            ),
            routes: [
              GoRoute(
                path: RouteNames.paiementCreate,
                name: RouteNames.paiementCreate,
                builder: (context, state) {
                  final athleteId = state.uri.queryParameters['athleteId'];
                  return PaiementFormPage(
                    athleteId: athleteId != null ? int.parse(athleteId) : null,
                  );
                },
              ),
            ],
          ),

          // Performances
          GoRoute(
            path: RouteNames.performances,
            name: RouteNames.performances,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PerformancesPage(),
            ),
            routes: [
              GoRoute(
                path: RouteNames.performanceCreate,
                name: RouteNames.performanceCreate,
                builder: (context, state) {
                  final athleteId = state.uri.queryParameters['athleteId'];
                  return PerformanceFormPage(
                    athleteId: athleteId != null ? int.parse(athleteId) : null,
                  );
                },
              ),
            ],
          ),

          // Disciplines
          GoRoute(
            path: RouteNames.disciplines,
            name: RouteNames.disciplines,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DisciplinesPage(),
            ),
          ),

          // Profile
          GoRoute(
            path: RouteNames.profile,
            name: RouteNames.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.dashboard),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final isLoggingIn = state.matchedLocation == RouteNames.login;
    final isSplash = state.matchedLocation == RouteNames.splash;
    final isForgotPassword = state.matchedLocation == RouteNames.forgotPassword;

    // Ne pas rediriger depuis splash (gestion interne)
    if (isSplash) return null;

    // Si non authentifié et pas sur une page auth, rediriger vers login
    if (!isAuthenticated && !isLoggingIn && !isForgotPassword) {
      return RouteNames.login;
    }

    // Si authentifié et sur login, rediriger vers dashboard
    if (isAuthenticated && isLoggingIn) {
      return RouteNames.dashboard;
    }

    return null;
  }
}
