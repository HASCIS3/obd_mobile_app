/// Endpoints de l'API OBD
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/login';
  static const String logout = '/logout';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String user = '/user';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Athletes
  static const String athletes = '/athletes';
  static String athlete(int id) => '/athletes/$id';
  static String athletePresences(int id) => '/athletes/$id/presences';
  static String athletePaiements(int id) => '/athletes/$id/paiements';
  static String athletePerformances(int id) => '/athletes/$id/performances';

  // Presences
  static const String presences = '/presences';
  static String presence(int id) => '/presences/$id';
  static const String presencesPointageMasse = '/presences/pointage-masse';
  static const String presencesRapportMensuel = '/presences/rapport-mensuel';
  static String presencesAthlete(int athleteId) => '/presences/athlete/$athleteId';

  // Paiements
  static const String paiements = '/paiements';
  static String paiement(int id) => '/paiements/$id';
  static const String paiementsArrieres = '/paiements/arrieres';
  static const String paiementsSuiviAnnuel = '/paiements/suivi-annuel';
  static String paiementRecu(int id) => '/paiements/$id/recu';

  // Performances
  static const String performances = '/performances';
  static String performance(int id) => '/performances/$id';
  static const String performancesDashboard = '/performances/dashboard';
  static String performancesEvolution(int athleteId) => '/performances/evolution/$athleteId';

  // Disciplines
  static const String disciplines = '/disciplines';
  static String discipline(int id) => '/disciplines/$id';

  // Coachs
  static const String coachs = '/coachs';
  static String coach(int id) => '/coachs/$id';

  // Activities
  static const String activities = '/activities';
  static String activity(int id) => '/activities/$id';

  // Profile
  static const String profile = '/profile';
  static const String profilePhoto = '/profile/photo';
  static const String password = '/password';

  // Suivi Scolaire
  static const String suivisScolaires = '/suivis-scolaires';
  static String suiviScolaire(int id) => '/suivis-scolaires/$id';
  static String athleteSuiviScolaire(int athleteId) => '/athletes/$athleteId/suivi-scolaire';

  // Rencontres/Matchs
  static const String rencontres = '/rencontres';
  static String rencontre(int id) => '/rencontres/$id';
  static const String rencontresAVenir = '/rencontres/a-venir';
  static const String rencontresResultats = '/rencontres/resultats';

  // Combats Taekwondo
  static String rencontreCombats(int rencontreId) => '/rencontres/$rencontreId/combats';
  static String combat(int id) => '/combats/$id';
  static String combatScores(int id) => '/combats/$id/scores';
  static String combatTerminer(int id) => '/combats/$id/terminer';

  // Activités (événements)
  static const String activitiesAVenir = '/activities/a-venir';

  // Calendrier
  static const String calendrierEvents = '/calendrier/events';
  static const String calendrierAVenir = '/calendrier/a-venir';

  // Licences
  static String athleteLicence(int athleteId) => '/athletes/$athleteId/licence';
  static const String licencesExpirant = '/licences/expirant';

  // Certificats médicaux
  static String athleteCertificat(int athleteId) => '/athletes/$athleteId/certificat';
  static const String certificatsExpirant = '/certificats/expirant';

  // Stages
  static const String stages = '/stages';
  static String stage(int id) => '/stages/$id';
  static String stageInscription(int id) => '/stages/$id/inscription';
}
