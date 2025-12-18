# Spécifications Fonctionnelles — Application Mobile OBD

**Version:** 1.0  
**Date:** 18 Décembre 2025  
**Auteur:** Agent 1 — Product Owner / Coordination

---

## 📋 Sommaire

1. [Contexte et Objectifs](#contexte-et-objectifs)
2. [Rôles Utilisateurs](#rôles-utilisateurs)
3. [Fonctionnalités MVP](#fonctionnalités-mvp)
4. [Modèles de Données](#modèles-de-données)
5. [Écrans et Navigation](#écrans-et-navigation)
6. [Contrat API Laravel ↔ Flutter](#contrat-api-laravel--flutter)
7. [Règles Métier](#règles-métier)
8. [Design System](#design-system)
9. [Évolutions Futures](#évolutions-futures)

---

## 1. Contexte et Objectifs

### 1.1 Contexte

L'application **OBD (Organisation Basket Développement)** est un système de gestion pour un centre sportif au Mali. La version web Laravel existe déjà et gère :
- Les athlètes et leurs inscriptions
- Les disciplines sportives (Basket, Volley, Taekwondo, etc.)
- Les coachs et leurs affectations
- Les paiements et cotisations
- Les présences aux entraînements
- Les performances sportives
- Le suivi scolaire des athlètes

### 1.2 Objectifs de l'Application Mobile

- **Accessibilité terrain** : Permettre aux coachs de gérer les présences directement sur le terrain
- **Suivi parents** : Offrir aux parents un accès aux informations de leurs enfants
- **Consultation athlètes** : Permettre aux athlètes de consulter leurs performances
- **Notifications** : Alerter sur les absences, paiements en retard, performances

### 1.3 Public Cible

| Utilisateur | Besoin Principal |
|-------------|------------------|
| **Admin** | Supervision globale, gestion complète |
| **Coach** | Pointage présences, saisie performances |
| **Parent** | Suivi enfant (présences, paiements, notes) |
| **Athlète** | Consultation de son profil et performances |

---

## 2. Rôles Utilisateurs

### 2.1 Admin (`role = 'admin'`)

**Permissions complètes :**
- Gestion des athlètes (CRUD)
- Gestion des coachs (CRUD)
- Gestion des disciplines (CRUD)
- Gestion des paiements (CRUD + génération mensuelle)
- Gestion des présences
- Gestion des performances
- Gestion du suivi scolaire
- Accès au dashboard complet
- Gestion des activités/actualités

### 2.2 Coach (`role = 'coach'`)

**Permissions limitées :**
- Consultation des athlètes de ses disciplines
- Création d'athlètes
- Enregistrement des présences
- Saisie des performances
- Consultation des paiements
- Consultation des disciplines

### 2.3 Athlète (`athlete_id != null`)

**Permissions consultation :**
- Consultation de son profil
- Consultation de ses présences
- Consultation de ses performances
- Consultation de ses paiements
- Consultation de son suivi scolaire

### 2.4 Parent (via compte athlète mineur)

**Permissions consultation :**
- Mêmes accès que l'athlète pour son/ses enfant(s)
- Notifications sur absences et paiements

---

## 3. Fonctionnalités MVP

### 3.1 Authentification

| Fonctionnalité | Priorité | Description |
|----------------|----------|-------------|
| Login | P0 | Connexion email/mot de passe |
| Logout | P0 | Déconnexion sécurisée |
| Mot de passe oublié | P1 | Réinitialisation par email |
| Session persistante | P0 | Token stocké de manière sécurisée |

### 3.2 Dashboard

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Stats globales | P0 | Admin | Nb athlètes, revenus, présences |
| Stats coach | P0 | Coach | Athlètes suivis, présences du jour |
| Stats athlète | P0 | Athlète | Taux présence, arriérés, performances |

### 3.3 Gestion des Athlètes

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Liste athlètes | P0 | Admin/Coach | Liste avec recherche et filtres |
| Détail athlète | P0 | Tous | Profil complet avec stats |
| Créer athlète | P1 | Admin/Coach | Formulaire d'inscription |
| Modifier athlète | P1 | Admin | Édition du profil |
| Filtrer par discipline | P0 | Admin/Coach | Filtre par sport |
| Filtrer par statut | P0 | Admin/Coach | Actif/Inactif |

### 3.4 Gestion des Présences

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Pointage rapide | P0 | Coach | Sélection multiple présent/absent |
| Historique présences | P0 | Tous | Liste des présences par date |
| Stats présence athlète | P0 | Tous | Taux de présence mensuel |
| Rapport mensuel | P1 | Admin/Coach | Synthèse par discipline |

### 3.5 Gestion des Paiements

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Liste paiements | P0 | Admin/Coach | Tous les paiements avec filtres |
| Détail paiement | P0 | Tous | Montant, statut, période |
| Enregistrer paiement | P1 | Admin/Coach | Nouveau paiement |
| Arriérés | P0 | Admin | Liste des impayés |
| Suivi annuel | P1 | Admin | Tableau récapitulatif |
| Générer reçu | P2 | Admin/Coach | PDF du reçu |

### 3.6 Gestion des Performances

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Liste performances | P0 | Tous | Historique des évaluations |
| Saisir performance | P1 | Coach | Formulaire d'évaluation |
| Évolution athlète | P0 | Tous | Graphique de progression |
| Stats matchs | P1 | Tous | Victoires/Défaites/Nuls |
| Médailles | P1 | Tous | Palmarès compétitions |

### 3.7 Disciplines

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Liste disciplines | P0 | Tous | Sports disponibles |
| Détail discipline | P0 | Tous | Tarif, coachs, athlètes |
| Gérer discipline | P2 | Admin | CRUD disciplines |

### 3.8 Activités / Actualités

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Liste activités | P1 | Tous | Actualités du centre |
| Détail activité | P1 | Tous | Contenu avec médias |

### 3.9 Profil Utilisateur

| Fonctionnalité | Priorité | Rôle | Description |
|----------------|----------|------|-------------|
| Voir profil | P0 | Tous | Informations personnelles |
| Modifier profil | P1 | Tous | Édition des infos |
| Changer photo | P2 | Tous | Upload photo de profil |
| Changer mot de passe | P1 | Tous | Modification sécurisée |

---

## 4. Modèles de Données

### 4.1 User (Utilisateur)

```dart
class User {
  int id;
  int? athleteId;
  String name;
  String email;
  String role; // 'admin', 'coach'
  String? photo;
  DateTime? emailVerifiedAt;
}
```

### 4.2 Athlete (Athlète)

```dart
class Athlete {
  int id;
  String nom;
  String prenom;
  DateTime? dateNaissance;
  String sexe; // 'M', 'F'
  String? telephone;
  String? email;
  String? adresse;
  String? photo;
  String? nomTuteur;
  String? telephoneTuteur;
  DateTime dateInscription;
  bool actif;
  
  // Computed
  String get nomComplet => '$prenom $nom';
  int? get age;
  String get categorieAge; // Poussin, Benjamin, Minime, Cadet, Junior, Senior
  double get tauxPresence;
  double get arrieres;
}
```

### 4.3 Discipline

```dart
class Discipline {
  int id;
  String nom;
  String? description;
  double tarifMensuel;
  bool actif;
  
  // Relations
  List<Coach> coachs;
  List<Athlete> athletes;
}
```

### 4.4 Coach

```dart
class Coach {
  int id;
  int userId;
  String? telephone;
  String? adresse;
  String? specialite;
  String? photo;
  DateTime? dateEmbauche;
  bool actif;
  
  // Via User
  String get nomComplet;
  String get email;
  
  // Relations
  List<Discipline> disciplines;
}
```

### 4.5 Presence

```dart
class Presence {
  int id;
  int athleteId;
  int disciplineId;
  int? coachId;
  DateTime date;
  bool present;
  String? remarque;
  
  // Relations
  Athlete athlete;
  Discipline discipline;
  Coach? coach;
}
```

### 4.6 Paiement

```dart
class Paiement {
  int id;
  int athleteId;
  String typePaiement; // 'cotisation', 'inscription', 'equipement'
  double? fraisInscription;
  String? typeEquipement;
  double? fraisEquipement;
  double montant;
  double montantPaye;
  int mois;
  int annee;
  DateTime? datePaiement;
  String? modePaiement; // 'especes', 'virement', 'mobile_money'
  String statut; // 'paye', 'impaye', 'partiel'
  String? reference;
  String? remarque;
  
  // Computed
  double get resteAPayer => montant - montantPaye;
  String get periode; // "Janvier 2025"
  bool get estEnRetard;
}
```

### 4.7 Performance

```dart
class Performance {
  int id;
  int athleteId;
  int disciplineId;
  DateTime dateEvaluation;
  String? typeEvaluation;
  String contexte; // 'entrainement', 'match', 'competition', 'test_physique'
  String? resultatMatch; // 'victoire', 'defaite', 'nul'
  int? pointsMarques;
  int? pointsEncaisses;
  double? score;
  String? unite;
  String? observations;
  String? competition;
  String? adversaire;
  String? lieu;
  int? classement;
  String? medaille; // 'or', 'argent', 'bronze'
  int? notePhysique; // 1-20
  int? noteTechnique; // 1-20
  int? noteComportement; // 1-20
  double? noteGlobale;
  
  // Relations
  Athlete athlete;
  Discipline discipline;
}
```

### 4.8 SuiviScolaire

```dart
class SuiviScolaire {
  int id;
  int athleteId;
  String? etablissement;
  String? classe;
  String anneeScolaire;
  double? moyenneGenerale;
  int? rang;
  String? observations;
  String? bulletinPath;
  
  // Computed
  String get niveau; // Excellent, Très bien, Satisfaisant, Passable, Insuffisant
  bool get estEligible;
}
```

### 4.9 Activity (Activité/Actualité)

```dart
class Activity {
  int id;
  String titre;
  String? contenu;
  String? image;
  DateTime datePublication;
  bool actif;
  
  List<ActivityMedia> medias;
}
```

---

## 5. Écrans et Navigation

### 5.1 Structure de Navigation

```
App
├── SplashScreen
├── AuthFlow
│   ├── LoginScreen
│   └── ForgotPasswordScreen
│
└── MainFlow (authentifié)
    ├── BottomNavigationBar
    │   ├── DashboardTab
    │   ├── AthletesTab
    │   ├── PresencesTab
    │   └── ProfileTab
    │
    ├── Athletes
    │   ├── AthleteListScreen
    │   ├── AthleteDetailScreen
    │   ├── AthleteCreateScreen
    │   └── AthleteEditScreen
    │
    ├── Presences
    │   ├── PresenceListScreen
    │   ├── PresenceCreateScreen (pointage)
    │   └── PresenceAthleteScreen (stats)
    │
    ├── Paiements
    │   ├── PaiementListScreen
    │   ├── PaiementDetailScreen
    │   ├── PaiementCreateScreen
    │   └── ArrieresScreen
    │
    ├── Performances
    │   ├── PerformanceListScreen
    │   ├── PerformanceDetailScreen
    │   ├── PerformanceCreateScreen
    │   └── EvolutionAthleteScreen
    │
    ├── Disciplines
    │   ├── DisciplineListScreen
    │   └── DisciplineDetailScreen
    │
    ├── Activities
    │   ├── ActivityListScreen
    │   └── ActivityDetailScreen
    │
    └── Profile
        ├── ProfileScreen
        ├── ProfileEditScreen
        └── ChangePasswordScreen
```

### 5.2 Écrans par Rôle

| Écran | Admin | Coach | Athlète |
|-------|-------|-------|---------|
| Dashboard | ✅ Complet | ✅ Limité | ✅ Personnel |
| Liste Athlètes | ✅ Tous | ✅ Ses disciplines | ❌ |
| Détail Athlète | ✅ | ✅ | ✅ Son profil |
| Créer Athlète | ✅ | ✅ | ❌ |
| Modifier Athlète | ✅ | ❌ | ❌ |
| Pointage Présences | ✅ | ✅ | ❌ |
| Liste Présences | ✅ | ✅ | ✅ Ses présences |
| Liste Paiements | ✅ | ✅ | ✅ Ses paiements |
| Créer Paiement | ✅ | ✅ | ❌ |
| Arriérés | ✅ | ❌ | ❌ |
| Liste Performances | ✅ | ✅ | ✅ Ses perfs |
| Saisir Performance | ✅ | ✅ | ❌ |
| Disciplines | ✅ | ✅ | ✅ |
| Activités | ✅ | ✅ | ✅ |
| Profil | ✅ | ✅ | ✅ |

---

## 6. Contrat API Laravel ↔ Flutter

### 6.1 Authentification

```
POST /api/login
Body: { email, password }
Response: { user, token }

POST /api/logout
Headers: Authorization: Bearer {token}

POST /api/forgot-password
Body: { email }

POST /api/reset-password
Body: { token, email, password, password_confirmation }
```

### 6.2 Dashboard

```
GET /api/dashboard
Response: { stats selon rôle }
```

### 6.3 Athlètes

```
GET /api/athletes
Query: ?discipline_id=&actif=&search=
Response: { data: Athlete[], meta: pagination }

GET /api/athletes/{id}
Response: { athlete, disciplines, stats }

POST /api/athletes
Body: { nom, prenom, date_naissance, sexe, ... }

PUT /api/athletes/{id}
Body: { ... }

DELETE /api/athletes/{id}
```

### 6.4 Présences

```
GET /api/presences
Query: ?date=&discipline_id=&athlete_id=

POST /api/presences
Body: { presences: [{ athlete_id, discipline_id, date, present, remarque }] }

GET /api/presences/athlete/{id}
Response: { presences, stats }

GET /api/presences/rapport-mensuel
Query: ?mois=&annee=&discipline_id=
```

### 6.5 Paiements

```
GET /api/paiements
Query: ?athlete_id=&statut=&mois=&annee=

GET /api/paiements/{id}

POST /api/paiements
Body: { athlete_id, type_paiement, montant, ... }

PUT /api/paiements/{id}

GET /api/paiements/arrieres

GET /api/paiements/suivi-annuel
Query: ?annee=
```

### 6.6 Performances

```
GET /api/performances
Query: ?athlete_id=&discipline_id=&contexte=

GET /api/performances/{id}

POST /api/performances
Body: { athlete_id, discipline_id, date_evaluation, contexte, ... }

PUT /api/performances/{id}

GET /api/performances/evolution/{athlete_id}
Query: ?discipline_id=
```

### 6.7 Disciplines

```
GET /api/disciplines
Query: ?actif=

GET /api/disciplines/{id}
Response: { discipline, coachs, athletes, stats }
```

### 6.8 Activités

```
GET /api/activities
Query: ?actif=

GET /api/activities/{id}
```

### 6.9 Profil

```
GET /api/profile

PUT /api/profile
Body: { name, email, ... }

POST /api/profile/photo
Body: FormData { photo }

PUT /api/password
Body: { current_password, password, password_confirmation }
```

---

## 7. Règles Métier

### 7.1 Athlètes

- **Catégories d'âge** :
  - Poussin : < 10 ans
  - Benjamin : 10-12 ans
  - Minime : 13-14 ans
  - Cadet : 15-17 ans
  - Junior : 18-20 ans
  - Senior : > 20 ans

- **Éligibilité** : Un athlète avec plus de 50 000 FCFA d'arriérés n'est pas éligible aux compétitions

- **Mineur** : Athlète < 18 ans, nécessite un tuteur

### 7.2 Paiements

- **Types** :
  - Cotisation mensuelle
  - Frais d'inscription
  - Équipement (maillot, dobok)

- **Statuts** :
  - Payé : montant_paye >= montant
  - Partiel : 0 < montant_paye < montant
  - Impayé : montant_paye = 0

- **Modes** :
  - Espèces
  - Virement bancaire
  - Mobile Money

- **Tarifs équipements** :
  - Maillot : 4 000 FCFA
  - Dobok Enfant : 5 000 FCFA
  - Dobok Junior : 6 000 - 7 000 FCFA
  - Dobok Senior : 8 000 - 10 000 FCFA

### 7.3 Présences

- **Taux de présence** : (présences / total séances) × 100
- **Alerte** : Notification si taux < 70%

### 7.4 Performances

- **Contextes** :
  - Entraînement
  - Match (victoire/défaite/nul)
  - Compétition (classement, médaille)
  - Test physique

- **Notes** : 1-20 pour physique, technique, comportement
- **Note globale** : Moyenne des 3 notes

### 7.5 Suivi Scolaire

- **Niveaux** :
  - Excellent : >= 17/20
  - Très bien : >= 14/20
  - Satisfaisant : >= 12/20
  - Passable : >= 10/20
  - Insuffisant : < 10/20

- **Éligibilité scolaire** : Moyenne >= 10/20

---

## 8. Design System

### 8.1 Couleurs Mali

```dart
// Couleurs principales (drapeau Mali)
const Color primaryGreen = Color(0xFF14B53A);   // Vert
const Color primaryYellow = Color(0xFFFCD116);  // Jaune/Or
const Color primaryRed = Color(0xFFCE1126);     // Rouge

// Couleurs secondaires
const Color backgroundLight = Color(0xFFF5F5F5);
const Color backgroundDark = Color(0xFF1A1A1A);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);

// Couleurs sémantiques
const Color success = Color(0xFF4CAF50);
const Color warning = Color(0xFFFF9800);
const Color error = Color(0xFFF44336);
const Color info = Color(0xFF2196F3);
```

### 8.2 Typographie

```dart
// Titres
headline1: 24sp, Bold
headline2: 20sp, SemiBold
headline3: 18sp, Medium

// Corps
body1: 16sp, Regular
body2: 14sp, Regular

// Labels
caption: 12sp, Regular
button: 14sp, Medium, UPPERCASE
```

### 8.3 Composants UI

- **Cards** : Coins arrondis 12px, ombre légère
- **Buttons** : Coins arrondis 8px, hauteur 48px
- **Inputs** : Bordure 1px, coins arrondis 8px
- **Bottom Navigation** : 4 items max, icônes + labels
- **FAB** : Actions principales (pointage, ajout)

### 8.4 Icônes

Utiliser **Lucide Icons** ou **Material Icons** :
- Dashboard : `home` / `dashboard`
- Athlètes : `users` / `people`
- Présences : `check-circle` / `event_available`
- Paiements : `credit-card` / `payments`
- Performances : `trending-up` / `insights`
- Disciplines : `activity` / `sports`
- Profil : `user` / `person`

---

## 9. Évolutions Futures

### Phase 2 (Post-MVP)

| Fonctionnalité | Description |
|----------------|-------------|
| Notifications Push | FCM pour alertes absences, paiements |
| Mode Hors-ligne | Sync des présences en différé |
| QR Code Présence | Scan pour pointage rapide |
| Export PDF | Rapports et reçus |
| Multi-langue | Français + Bambara |

### Phase 3

| Fonctionnalité | Description |
|----------------|-------------|
| Chat | Messagerie coach-parent |
| Calendrier | Planning des entraînements |
| Statistiques avancées | Graphiques et analytics |
| Paiement en ligne | Intégration Orange Money / Wave |

---

## 📎 Annexes

### A. Endpoints API à créer côté Laravel

Le backend Laravel actuel utilise des routes web. Il faudra créer des routes API :

```php
// routes/api.php
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'api']);
    Route::apiResource('athletes', AthleteController::class);
    Route::apiResource('presences', PresenceController::class);
    Route::apiResource('paiements', PaiementController::class);
    Route::apiResource('performances', PerformanceController::class);
    Route::apiResource('disciplines', DisciplineController::class);
    Route::apiResource('activities', ActivityController::class);
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']);
});
```

### B. Dépendances Flutter recommandées

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.3
  # ou
  flutter_riverpod: ^2.4.0
  
  # HTTP & API
  dio: ^5.3.0
  retrofit: ^4.0.0
  
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.0
  
  # Navigation
  go_router: ^12.0.0
  
  # UI
  flutter_svg: ^2.0.7
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  
  # Utils
  intl: ^0.18.0
  equatable: ^2.0.5
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  
  # Notifications (Phase 2)
  firebase_messaging: ^14.6.0
  flutter_local_notifications: ^15.0.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  retrofit_generator: ^8.0.0
```

---

**Fin du document de spécifications fonctionnelles**

*Document validé par Agent 1 — Product Owner / Coordination*
