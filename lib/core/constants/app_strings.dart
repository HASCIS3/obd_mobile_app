/// Chaînes de caractères de l'application OBD Mobile
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Olympiade de Baco-Djicoroni';
  static const String appNameShort = 'OBD';
  static const String appTagline = 'Courage - Persévérance - Discipline';

  // Auth
  static const String login = 'Connexion';
  static const String logout = 'Déconnexion';
  static const String email = 'Email';
  static const String password = 'Mot de passe';
  static const String forgotPassword = 'Mot de passe oublié ?';
  static const String resetPassword = 'Réinitialiser le mot de passe';
  static const String signIn = 'Se connecter';
  static const String welcomeBack = 'Bienvenue !';
  static const String enterCredentials = 'Entrez vos identifiants pour continuer';

  // Navigation
  static const String home = 'Accueil';
  static const String dashboard = 'Dashboard';
  static const String athletes = 'Athlètes';
  static const String presences = 'Présences';
  static const String paiements = 'Paiements';
  static const String performances = 'Performances';
  static const String disciplines = 'Disciplines';
  static const String profile = 'Profil';
  static const String settings = 'Paramètres';

  // Athletes
  static const String athlete = 'Athlète';
  static const String newAthlete = 'Nouvel athlète';
  static const String editAthlete = 'Modifier l\'athlète';
  static const String athleteDetails = 'Détails de l\'athlète';
  static const String searchAthlete = 'Rechercher un athlète...';
  static const String noAthletes = 'Aucun athlète trouvé';
  static const String activeAthletes = 'Athlètes actifs';
  static const String inactiveAthletes = 'Athlètes inactifs';

  // Athlete fields
  static const String nom = 'Nom';
  static const String prenom = 'Prénom';
  static const String dateNaissance = 'Date de naissance';
  static const String sexe = 'Sexe';
  static const String masculin = 'Masculin';
  static const String feminin = 'Féminin';
  static const String telephone = 'Téléphone';
  static const String adresse = 'Adresse';
  static const String tuteur = 'Tuteur';
  static const String telephoneTuteur = 'Téléphone tuteur';
  static const String dateInscription = 'Date d\'inscription';
  static const String actif = 'Actif';
  static const String inactif = 'Inactif';

  // Categories d'âge
  static const String poussin = 'Poussin';
  static const String benjamin = 'Benjamin';
  static const String minime = 'Minime';
  static const String cadet = 'Cadet';
  static const String junior = 'Junior';
  static const String senior = 'Senior';

  // Presences
  static const String presence = 'Présence';
  static const String pointage = 'Pointage';
  static const String newPointage = 'Nouveau pointage';
  static const String present = 'Présent';
  static const String absent = 'Absent';
  static const String tauxPresence = 'Taux de présence';
  static const String historiquePresences = 'Historique des présences';
  static const String toutPresent = 'Tout présent';
  static const String toutAbsent = 'Tout absent';
  static const String enregistrerPresences = 'Enregistrer les présences';

  // Paiements
  static const String paiement = 'Paiement';
  static const String newPaiement = 'Nouveau paiement';
  static const String arrieres = 'Arriérés';
  static const String montant = 'Montant';
  static const String montantPaye = 'Montant payé';
  static const String resteAPayer = 'Reste à payer';
  static const String modePaiement = 'Mode de paiement';
  static const String especes = 'Espèces';
  static const String virement = 'Virement bancaire';
  static const String mobileMoney = 'Mobile Money';
  static const String paye = 'Payé';
  static const String impaye = 'Impayé';
  static const String partiel = 'Partiel';
  static const String cotisation = 'Cotisation';
  static const String inscription = 'Inscription';
  static const String equipement = 'Équipement';
  static const String fcfa = 'FCFA';

  // Performances
  static const String performance = 'Performance';
  static const String newPerformance = 'Nouvelle évaluation';
  static const String evolution = 'Évolution';
  static const String entrainement = 'Entraînement';
  static const String match = 'Match';
  static const String competition = 'Compétition';
  static const String testPhysique = 'Test physique';
  static const String victoire = 'Victoire';
  static const String defaite = 'Défaite';
  static const String nul = 'Nul';
  static const String notePhysique = 'Note physique';
  static const String noteTechnique = 'Note technique';
  static const String noteComportement = 'Note comportement';
  static const String noteGlobale = 'Note globale';

  // Disciplines
  static const String discipline = 'Discipline';
  static const String tarifMensuel = 'Tarif mensuel';

  // Profile
  static const String monProfil = 'Mon profil';
  static const String modifierProfil = 'Modifier le profil';
  static const String changerMotDePasse = 'Changer le mot de passe';
  static const String motDePasseActuel = 'Mot de passe actuel';
  static const String nouveauMotDePasse = 'Nouveau mot de passe';
  static const String confirmerMotDePasse = 'Confirmer le mot de passe';

  // Actions
  static const String save = 'Enregistrer';
  static const String cancel = 'Annuler';
  static const String delete = 'Supprimer';
  static const String edit = 'Modifier';
  static const String add = 'Ajouter';
  static const String search = 'Rechercher';
  static const String filter = 'Filtrer';
  static const String refresh = 'Actualiser';
  static const String retry = 'Réessayer';
  static const String confirm = 'Confirmer';
  static const String close = 'Fermer';
  static const String seeAll = 'Voir tout';
  static const String seeMore = 'Voir plus';

  // Messages
  static const String loading = 'Chargement...';
  static const String noData = 'Aucune donnée';
  static const String error = 'Erreur';
  static const String success = 'Succès';
  static const String warning = 'Attention';
  static const String info = 'Information';

  // Errors
  static const String errorGeneric = 'Une erreur est survenue';
  static const String errorNetwork = 'Erreur de connexion';
  static const String errorServer = 'Erreur serveur';
  static const String errorUnauthorized = 'Session expirée';
  static const String errorNotFound = 'Ressource non trouvée';
  static const String errorValidation = 'Données invalides';
  static const String errorRequired = 'Ce champ est requis';
  static const String errorInvalidEmail = 'Email invalide';
  static const String errorPasswordTooShort = 'Mot de passe trop court (min. 8 caractères)';
  static const String errorPasswordMismatch = 'Les mots de passe ne correspondent pas';

  // Success messages
  static const String successSaved = 'Enregistré avec succès';
  static const String successDeleted = 'Supprimé avec succès';
  static const String successUpdated = 'Mis à jour avec succès';
  static const String successLogin = 'Connexion réussie';
  static const String successLogout = 'Déconnexion réussie';

  // Dates
  static const String today = 'Aujourd\'hui';
  static const String yesterday = 'Hier';
  static const String thisWeek = 'Cette semaine';
  static const String thisMonth = 'Ce mois';
  static const String thisYear = 'Cette année';

  // Mois
  static const List<String> mois = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
}
