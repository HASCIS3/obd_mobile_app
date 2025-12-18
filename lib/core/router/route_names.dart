/// Noms des routes de l'application
class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';

  // Main
  static const String dashboard = '/dashboard';
  
  // Athletes
  static const String athletes = '/athletes';
  static const String athleteDetail = 'athlete-detail';
  static const String athleteCreate = 'athlete-create';
  static const String athleteEdit = 'athlete-edit';

  // Presences
  static const String presences = '/presences';
  static const String presenceCreate = 'presence-create';

  // Paiements
  static const String paiements = '/paiements';
  static const String paiementDetail = 'paiement-detail';
  static const String paiementCreate = 'paiement-create';

  // Performances
  static const String performances = '/performances';
  static const String performanceDetail = 'performance-detail';
  static const String performanceCreate = 'performance-create';

  // Disciplines
  static const String disciplines = '/disciplines';
  static const String disciplineDetail = 'discipline-detail';

  // Profile
  static const String profile = '/profile';
  static const String profileEdit = 'profile-edit';
  static const String changePassword = 'change-password';

  // Activities
  static const String activities = '/activities';
  static const String activityDetail = 'activity-detail';
}
