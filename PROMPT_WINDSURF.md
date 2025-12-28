# Prompt Windsurf — Développement Application Mobile Flutter OBD

## 🎯 Contexte du Projet

Tu travailles sur l'application mobile **Flutter** pour le centre sportif **OBD (Olympiade de Baco-Djicoroni)** au Mali. Cette application est le compagnon mobile du backend **Laravel** existant.

### Backend Laravel (déjà fonctionnel)
- **URL API** : `http://127.0.0.1:8000/api` (dev) ou `https://obd.ml/api` (prod)
- **Authentification** : Laravel Sanctum avec tokens Bearer
- **Base de données** : MySQL avec les tables suivantes :
  - `users` (id, name, email, password, role, athlete_id)
  - `athletes` (id, nom, prenom, date_naissance, sexe, telephone, email, adresse, photo, actif, etc.)
  - `disciplines` (id, nom, description, couleur)
  - `athlete_discipline` (pivot many-to-many)
  - `presences` (id, athlete_id, date, present, motif_absence)
  - `paiements` (id, athlete_id, montant, date_paiement, statut, mode_paiement)
  - `performances` (id, athlete_id, date_evaluation, note, observations)
  - `suivi_scolaires` (id, athlete_id, periode, moyenne_generale, etablissement, classe)
  - `evenements` (id, titre, description, date_debut, date_fin, lieu, type)
  - `parents` (id, user_id, nom, prenom, telephone, email, adresse)
  - `athlete_parent` (pivot many-to-many avec lien familial)
  - `certificats_medicaux` (id, athlete_id, date_emission, date_expiration, statut)

### Rôles utilisateurs
| Rôle | Description | Accès |
|------|-------------|-------|
| `admin` | Administrateur | Accès complet à tout |
| `coach` | Entraîneur | Gestion présences, performances, consultation athlètes |
| `athlete` | Athlète | Consultation de son profil, présences, paiements, performances |
| `parent` | Parent | Consultation des infos de ses enfants |

---

## 📱 État Actuel du Projet Flutter

### Structure existante
```
lib/
├── core/
│   ├── config/          # Configuration app (vide)
│   ├── constants/       # Constantes (vide)
│   ├── di/              # Injection de dépendances (vide)
│   ├── errors/          # Gestion des erreurs (vide)
│   ├── models/          # Modèles Dart (vide)
│   ├── network/         # DioClient configuré ✅
│   ├── router/          # GoRouter (vide)
│   ├── services/        # LocalStorage, SyncService ✅
│   ├── theme/           # AppTheme configuré ✅
│   ├── utils/           # Utilitaires (vide)
│   └── widgets/         # Widgets réutilisables (vide)
├── features/
│   ├── auth/            # Authentification (bloc créé, pages vides)
│   ├── dashboard/       # Dashboard (vide)
│   ├── athletes/        # Gestion athlètes (vide)
│   ├── presences/       # Gestion présences (vide)
│   ├── paiements/       # Gestion paiements (vide)
│   ├── performances/    # Gestion performances (vide)
│   ├── disciplines/     # Disciplines (vide)
│   ├── profile/         # Profil utilisateur (vide)
│   └── splash/          # Splash screen (vide)
└── main.dart            # Point d'entrée configuré ✅
```

### Dépendances installées (pubspec.yaml)
- **State Management** : flutter_bloc, equatable
- **Navigation** : go_router
- **Network** : dio, pretty_dio_logger, connectivity_plus
- **Storage** : flutter_secure_storage, shared_preferences, hive, hive_flutter
- **Utils** : intl, logger, get_it, injectable, dartz
- **UI** : flutter_svg, cached_network_image, shimmer, flutter_spinkit, table_calendar
- **Forms** : formz
- **Code Gen** : freezed, json_serializable, build_runner

### Fichiers déjà implémentés
1. `lib/main.dart` - Configuration de l'app avec Bloc, locales FR
2. `lib/core/network/dio_client.dart` - Client HTTP avec interceptors auth/error
3. `lib/core/services/local_storage_service.dart` - Stockage Hive
4. `lib/core/services/sync_service.dart` - Synchronisation
5. `lib/core/theme/app_theme.dart` - Thème avec couleurs Mali
6. `lib/features/auth/presentation/bloc/auth_bloc.dart` - Bloc auth

---

## 🎨 Design System

### Couleurs du drapeau Mali
```dart
// Vert (primaire)
static const Color primaryGreen = Color(0xFF14B53A);

// Jaune (accent)
static const Color accentYellow = Color(0xFFFCD116);

// Rouge (alerte)
static const Color alertRed = Color(0xFFCE1126);
```

### Typographie
- Police : Figtree (Google Fonts)
- Titres : Bold, 18-24px
- Corps : Regular, 14-16px
- Labels : Medium, 12px

---

## 🔌 Endpoints API Laravel

### Authentification
```
POST /api/login          → { email, password } → { user, token }
POST /api/logout         → (auth) → { message }
GET  /api/user           → (auth) → { user }
POST /api/forgot-password → { email } → { message }
```

### Dashboard
```
GET /api/dashboard       → (auth) → { stats, athletes_actifs, revenus_mois, presences_jour }
```

### Athlètes
```
GET    /api/athletes              → Liste paginée avec filtres
GET    /api/athletes/{id}         → Détail athlète
POST   /api/athletes              → Créer athlète
PUT    /api/athletes/{id}         → Modifier athlète
DELETE /api/athletes/{id}         → Supprimer athlète
GET    /api/athletes/{id}/presences    → Présences de l'athlète
GET    /api/athletes/{id}/paiements    → Paiements de l'athlète
GET    /api/athletes/{id}/performances → Performances de l'athlète
```

### Présences
```
GET  /api/presences              → Liste présences avec filtres (date, discipline)
POST /api/presences              → Enregistrer présences (bulk)
PUT  /api/presences/{id}         → Modifier présence
```

### Paiements
```
GET  /api/paiements              → Liste paiements
GET  /api/paiements/{id}         → Détail paiement
POST /api/paiements              → Créer paiement
PUT  /api/paiements/{id}         → Modifier paiement
GET  /api/paiements/arrieres     → Liste arriérés
```

### Performances
```
GET  /api/performances           → Liste performances
POST /api/performances           → Créer performance
PUT  /api/performances/{id}      → Modifier performance
```

### Disciplines
```
GET /api/disciplines             → Liste disciplines
GET /api/disciplines/{id}        → Détail discipline avec athlètes
```

### Événements
```
GET /api/evenements              → Liste événements
GET /api/evenements/{id}         → Détail événement
```

---

## 📋 Tâches à Implémenter

### Sprint 1 — Fondations (Priorité P0)

#### 1. Configuration Core
- [ ] `lib/core/config/app_config.dart` - URLs API, timeouts
- [ ] `lib/core/config/env_config.dart` - Variables d'environnement
- [ ] `lib/core/constants/app_strings.dart` - Textes de l'app
- [ ] `lib/core/constants/app_colors.dart` - Couleurs
- [ ] `lib/core/constants/app_assets.dart` - Chemins assets
- [ ] `lib/core/di/injection.dart` - GetIt + Injectable setup
- [ ] `lib/core/errors/exceptions.dart` - Classes d'exceptions
- [ ] `lib/core/errors/failures.dart` - Classes de failures

#### 2. Modèles Dart (avec Freezed)
- [ ] `lib/core/models/user_model.dart`
- [ ] `lib/core/models/athlete_model.dart`
- [ ] `lib/core/models/discipline_model.dart`
- [ ] `lib/core/models/presence_model.dart`
- [ ] `lib/core/models/paiement_model.dart`
- [ ] `lib/core/models/performance_model.dart`
- [ ] `lib/core/models/evenement_model.dart`

#### 3. Navigation (GoRouter)
- [ ] `lib/core/router/app_router.dart` - Routes avec guards
- [ ] `lib/core/router/route_names.dart` - Noms des routes

#### 4. Widgets Réutilisables
- [ ] `lib/core/widgets/app_button.dart`
- [ ] `lib/core/widgets/app_text_field.dart`
- [ ] `lib/core/widgets/app_card.dart`
- [ ] `lib/core/widgets/loading_widget.dart`
- [ ] `lib/core/widgets/error_widget.dart`
- [ ] `lib/core/widgets/empty_state_widget.dart`

### Sprint 2 — Authentification

#### Feature Auth (Clean Architecture)
```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart
│   ├── models/
│   │   └── login_response_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       └── get_current_user_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart ✅
    │   ├── auth_event.dart ✅
    │   └── auth_state.dart ✅
    └── pages/
        ├── login_page.dart
        ├── forgot_password_page.dart
        └── widgets/
            └── login_form.dart
```

### Sprint 3 — Dashboard

#### Dashboards par rôle
- [ ] `lib/features/dashboard/presentation/pages/admin_dashboard_page.dart`
- [ ] `lib/features/dashboard/presentation/pages/coach_dashboard_page.dart`
- [ ] `lib/features/dashboard/presentation/pages/athlete_dashboard_page.dart`
- [ ] `lib/features/dashboard/presentation/pages/parent_dashboard_page.dart`

#### Widgets Dashboard
- [ ] `StatCard` - Carte statistique
- [ ] `QuickActionCard` - Action rapide
- [ ] `RecentActivityList` - Activités récentes
- [ ] `UpcomingEventCard` - Prochain événement

### Sprint 4 — Gestion Athlètes

- [ ] Liste athlètes avec recherche et filtres
- [ ] Détail athlète avec onglets (infos, présences, paiements, performances)
- [ ] Formulaire création/modification athlète
- [ ] Photo de profil avec image_picker

### Sprint 5 — Gestion Présences

- [ ] Écran pointage rapide (liste athlètes avec toggle présent/absent)
- [ ] Historique présences avec calendrier
- [ ] Stats présences par athlète/discipline

### Sprint 6 — Gestion Paiements

- [ ] Liste paiements avec filtres (statut, période)
- [ ] Détail paiement
- [ ] Formulaire enregistrement paiement
- [ ] Écran arriérés

### Sprint 7 — Performances & Profil

- [ ] Liste performances
- [ ] Formulaire saisie performance
- [ ] Graphique évolution (fl_chart)
- [ ] Écran profil utilisateur
- [ ] Modification profil

---

## 🏗️ Architecture Clean Architecture

Chaque feature suit cette structure :

```
feature/
├── data/
│   ├── datasources/     # Sources de données (API, local)
│   ├── models/          # Modèles JSON (extends Entity)
│   └── repositories/    # Implémentation des repos
├── domain/
│   ├── entities/        # Entités métier pures
│   ├── repositories/    # Interfaces des repos
│   └── usecases/        # Cas d'utilisation
└── presentation/
    ├── bloc/            # BLoC (events, states, bloc)
    ├── pages/           # Pages/Screens
    └── widgets/         # Widgets spécifiques
```

---

## 🔐 Gestion de l'Authentification

### Flux de connexion
1. Utilisateur entre email/password
2. Appel `POST /api/login`
3. Réception token + user
4. Stockage token dans `flutter_secure_storage`
5. Configuration token dans `DioClient`
6. Redirection vers dashboard selon rôle

### Stockage sécurisé
```dart
// Clés de stockage
static const String tokenKey = 'auth_token';
static const String userKey = 'current_user';
static const String roleKey = 'user_role';
```

### Protection des routes
```dart
// GoRouter redirect
redirect: (context, state) {
  final isAuthenticated = authBloc.state.isAuthenticated;
  final isLoginRoute = state.matchedLocation == '/login';
  
  if (!isAuthenticated && !isLoginRoute) {
    return '/login';
  }
  if (isAuthenticated && isLoginRoute) {
    return '/dashboard';
  }
  return null;
}
```

---

## 📱 Écrans à Créer

### Communs
1. **SplashScreen** - Logo OBD + chargement
2. **LoginPage** - Formulaire connexion
3. **ForgotPasswordPage** - Récupération mot de passe

### Admin/Coach
4. **DashboardPage** - Stats, actions rapides
5. **AthletesListPage** - Liste avec recherche
6. **AthleteDetailPage** - Profil complet
7. **AthleteFormPage** - Création/modification
8. **PresencePointagePage** - Pointage rapide
9. **PresencesHistoryPage** - Historique
10. **PaiementsListPage** - Liste paiements
11. **PaiementFormPage** - Enregistrer paiement
12. **PerformancesListPage** - Liste performances
13. **PerformanceFormPage** - Saisir performance
14. **DisciplinesListPage** - Liste disciplines
15. **ProfilePage** - Mon profil
16. **SettingsPage** - Paramètres

### Athlète
17. **AthleteDashboardPage** - Mon tableau de bord
18. **MyPresencesPage** - Mes présences
19. **MyPaiementsPage** - Mes paiements
20. **MyPerformancesPage** - Mes performances
21. **MyProfilePage** - Mon profil

### Parent
22. **ParentDashboardPage** - Vue d'ensemble enfants
23. **ChildrenListPage** - Mes enfants
24. **ChildDetailPage** - Détail enfant

---

## 🧪 Tests à Écrire

### Tests Unitaires
- [ ] AuthBloc tests
- [ ] Repositories tests
- [ ] Usecases tests
- [ ] Models serialization tests

### Tests Widgets
- [ ] LoginForm test
- [ ] StatCard test
- [ ] AthleteCard test

### Tests Integration
- [ ] Login flow test
- [ ] Navigation test

---

## 📝 Conventions de Code

### Nommage
- **Fichiers** : snake_case (`athlete_model.dart`)
- **Classes** : PascalCase (`AthleteModel`)
- **Variables** : camelCase (`athleteList`)
- **Constantes** : camelCase avec `k` prefix (`kPrimaryColor`)

### Imports
```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Project imports
import '../../../core/constants/app_colors.dart';
```

### BLoC Pattern
```dart
// Event
sealed class AthleteEvent {}
class AthletesFetched extends AthleteEvent {}

// State
class AthleteState extends Equatable {
  final AthleteStatus status;
  final List<Athlete> athletes;
  final String? error;
}

// Bloc
class AthleteBloc extends Bloc<AthleteEvent, AthleteState> {
  AthleteBloc() : super(const AthleteState()) {
    on<AthletesFetched>(_onFetched);
  }
}
```

---

## 🚀 Commandes Utiles

```bash
# Installer les dépendances
flutter pub get

# Générer le code (Freezed, JSON Serializable)
dart run build_runner build --delete-conflicting-outputs

# Lancer l'app
flutter run

# Lancer les tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

---

## ⚠️ Points d'Attention

1. **Gestion des erreurs** : Toujours wrapper les appels API dans try-catch
2. **Loading states** : Afficher des shimmer/skeleton pendant le chargement
3. **Offline mode** : Prévoir le cache local pour les données critiques
4. **Validation** : Valider les formulaires côté client avant envoi
5. **Tokens** : Gérer l'expiration et le refresh des tokens
6. **Permissions** : Vérifier le rôle avant d'afficher certaines fonctionnalités

---

## 🎯 Objectif Final

Livrer une application mobile Flutter **fonctionnelle, performante et maintenable** qui permet :
- Aux **admins** de gérer le centre sportif
- Aux **coachs** de pointer les présences et saisir les performances
- Aux **athlètes** de consulter leurs informations
- Aux **parents** de suivre leurs enfants

L'application doit être **responsive**, **offline-capable** pour les fonctions critiques, et respecter les **couleurs du Mali** (vert, jaune, rouge).

---

**Fin du prompt — Bonne continuation !**
