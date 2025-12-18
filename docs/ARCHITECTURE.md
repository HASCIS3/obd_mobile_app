# Architecture Flutter — OBD Mobile

**Version:** 1.0  
**Date:** 18 Décembre 2025  
**Auteur:** Agent 2 — Architecte Flutter

---

## 📋 Sommaire

1. [Vue d'ensemble](#vue-densemble)
2. [Clean Architecture](#clean-architecture)
3. [Structure des dossiers](#structure-des-dossiers)
4. [Gestion d'état (Bloc)](#gestion-détat-bloc)
5. [Injection de dépendances](#injection-de-dépendances)
6. [Navigation (GoRouter)](#navigation-gorouter)
7. [Réseau (Dio)](#réseau-dio)
8. [Conventions de code](#conventions-de-code)
9. [Dépendances](#dépendances)

---

## 1. Vue d'ensemble

L'application OBD Mobile utilise **Clean Architecture** pour garantir :
- **Séparation des responsabilités** : UI, logique métier et données sont isolées
- **Testabilité** : Chaque couche peut être testée indépendamment
- **Maintenabilité** : Modifications localisées sans impact global
- **Scalabilité** : Ajout de fonctionnalités sans refactoring majeur

### Stack technique

| Catégorie | Technologie |
|-----------|-------------|
| Framework | Flutter 3.10+ |
| State Management | flutter_bloc |
| Navigation | go_router |
| HTTP Client | dio |
| DI | get_it |
| Storage | flutter_secure_storage, shared_preferences |
| Serialization | json_serializable, freezed |

---

## 2. Clean Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION                             │
│  (Pages, Widgets, Blocs)                                    │
│  - Affichage UI                                             │
│  - Gestion des événements utilisateur                       │
│  - États de l'interface                                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       DOMAIN                                 │
│  (Entities, Use Cases, Repository Interfaces)               │
│  - Logique métier pure                                      │
│  - Indépendant du framework                                 │
│  - Définit les contrats                                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        DATA                                  │
│  (Models, Repositories, Data Sources)                       │
│  - Implémentation des repositories                          │
│  - Communication API                                        │
│  - Cache local                                              │
└─────────────────────────────────────────────────────────────┘
```

### Règles de dépendance

- **Presentation** → dépend de → **Domain**
- **Data** → dépend de → **Domain**
- **Domain** → ne dépend de rien (couche pure)

---

## 3. Structure des dossiers

```
lib/
├── main.dart                    # Point d'entrée
│
├── core/                        # Code partagé
│   ├── config/                  # Configuration app
│   │   ├── app_config.dart      # Variables d'environnement
│   │   └── api_endpoints.dart   # Endpoints API
│   │
│   ├── constants/               # Constantes
│   │   ├── app_colors.dart      # Palette de couleurs
│   │   ├── app_sizes.dart       # Tailles et espacements
│   │   ├── app_strings.dart     # Chaînes de caractères
│   │   └── constants.dart       # Export barrel
│   │
│   ├── di/                      # Injection de dépendances
│   │   └── injection.dart       # Configuration GetIt
│   │
│   ├── errors/                  # Gestion des erreurs
│   │   ├── exceptions.dart      # Exceptions personnalisées
│   │   └── failures.dart        # Classes Failure
│   │
│   ├── models/                  # Modèles partagés
│   │   ├── user_model.dart
│   │   ├── athlete_model.dart
│   │   ├── discipline_model.dart
│   │   ├── paiement_model.dart
│   │   ├── presence_model.dart
│   │   ├── performance_model.dart
│   │   └── models.dart          # Export barrel
│   │
│   ├── network/                 # Configuration réseau
│   │   ├── dio_client.dart      # Client HTTP
│   │   └── network_info.dart    # Vérification connectivité
│   │
│   ├── router/                  # Navigation
│   │   ├── app_router.dart      # Configuration GoRouter
│   │   └── route_names.dart     # Noms des routes
│   │
│   ├── theme/                   # Thème
│   │   └── app_theme.dart       # Configuration thème
│   │
│   ├── utils/                   # Utilitaires
│   │   └── extensions.dart      # Extensions Dart
│   │
│   └── widgets/                 # Widgets partagés
│       └── main_scaffold.dart   # Scaffold avec bottom nav
│
└── features/                    # Fonctionnalités (par feature)
    │
    ├── auth/                    # Authentification
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── login_usecase.dart
    │   │       └── logout_usecase.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── forgot_password_page.dart
    │       └── widgets/
    │
    ├── dashboard/               # Dashboard
    │   └── presentation/
    │       └── pages/
    │           └── dashboard_page.dart
    │
    ├── athletes/                # Gestion athlètes
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       │   ├── athletes_page.dart
    │       │   └── athlete_detail_page.dart
    │       └── widgets/
    │
    ├── presences/               # Gestion présences
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       │   └── presences_page.dart
    │       └── widgets/
    │
    ├── paiements/               # Gestion paiements
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       │   └── paiements_page.dart
    │       └── widgets/
    │
    ├── performances/            # Gestion performances
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    ├── disciplines/             # Disciplines
    │   └── presentation/
    │
    ├── profile/                 # Profil utilisateur
    │   └── presentation/
    │       └── pages/
    │           └── profile_page.dart
    │
    └── splash/                  # Splash screen
        └── presentation/
            └── pages/
                └── splash_page.dart
```

---

## 4. Gestion d'état (Bloc)

### Pattern Bloc

```dart
// Event
abstract class AthleteEvent extends Equatable {}

class LoadAthletes extends AthleteEvent {
  final String? search;
  final int? disciplineId;
  
  LoadAthletes({this.search, this.disciplineId});
  
  @override
  List<Object?> get props => [search, disciplineId];
}

// State
abstract class AthleteState extends Equatable {}

class AthleteInitial extends AthleteState {
  @override
  List<Object?> get props => [];
}

class AthleteLoading extends AthleteState {
  @override
  List<Object?> get props => [];
}

class AthleteLoaded extends AthleteState {
  final List<AthleteModel> athletes;
  
  AthleteLoaded(this.athletes);
  
  @override
  List<Object?> get props => [athletes];
}

class AthleteError extends AthleteState {
  final String message;
  
  AthleteError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Bloc
class AthleteBloc extends Bloc<AthleteEvent, AthleteState> {
  final GetAthletesUseCase getAthletes;
  
  AthleteBloc({required this.getAthletes}) : super(AthleteInitial()) {
    on<LoadAthletes>(_onLoadAthletes);
  }
  
  Future<void> _onLoadAthletes(
    LoadAthletes event,
    Emitter<AthleteState> emit,
  ) async {
    emit(AthleteLoading());
    
    final result = await getAthletes(
      search: event.search,
      disciplineId: event.disciplineId,
    );
    
    result.fold(
      (failure) => emit(AthleteError(failure.message)),
      (athletes) => emit(AthleteLoaded(athletes)),
    );
  }
}
```

### Utilisation dans les widgets

```dart
// Fournir le Bloc
BlocProvider(
  create: (context) => sl<AthleteBloc>()..add(LoadAthletes()),
  child: const AthletesPage(),
)

// Consommer le Bloc
BlocBuilder<AthleteBloc, AthleteState>(
  builder: (context, state) {
    if (state is AthleteLoading) {
      return const CircularProgressIndicator();
    }
    if (state is AthleteLoaded) {
      return ListView.builder(
        itemCount: state.athletes.length,
        itemBuilder: (context, index) => AthleteCard(state.athletes[index]),
      );
    }
    if (state is AthleteError) {
      return ErrorWidget(message: state.message);
    }
    return const SizedBox.shrink();
  },
)
```

---

## 5. Injection de dépendances

### Configuration GetIt

```dart
final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(networkInfo: sl()),
  );

  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    logoutUseCase: sl(),
  ));

  // Athletes Feature
  // ... même pattern
}
```

### Accès aux dépendances

```dart
// Dans les widgets
final bloc = sl<AthleteBloc>();

// Dans les tests
sl.registerSingleton<AuthRepository>(MockAuthRepository());
```

---

## 6. Navigation (GoRouter)

### Configuration

```dart
final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = authBloc.state is Authenticated;
    final isLoggingIn = state.matchedLocation == '/login';
    
    if (!isLoggedIn && !isLoggingIn) return '/login';
    if (isLoggedIn && isLoggingIn) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/athletes',
          builder: (context, state) => const AthletesPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return AthleteDetailPage(athleteId: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
```

### Navigation

```dart
// Navigation simple
context.go('/dashboard');

// Navigation avec paramètres
context.go('/athletes/123');

// Push (ajoute à la pile)
context.push('/athletes/create');

// Pop (retour)
context.pop();
```

---

## 7. Réseau (Dio)

### Configuration du client

```dart
class DioClient {
  final Dio _dio;
  
  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      LogInterceptor(),
    ]);
  }
}
```

### Gestion des erreurs

```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.response?.statusCode) {
      case 401:
        throw AuthenticationException();
      case 403:
        throw AuthorizationException();
      case 404:
        throw NotFoundException();
      case 422:
        throw ValidationException(errors: err.response?.data['errors']);
      case 500:
        throw ServerException();
      default:
        throw UnknownException();
    }
  }
}
```

---

## 8. Conventions de code

### Nommage

| Type | Convention | Exemple |
|------|------------|---------|
| Classes | PascalCase | `AthleteModel` |
| Variables | camelCase | `athleteList` |
| Constantes | camelCase | `primaryColor` |
| Fichiers | snake_case | `athlete_model.dart` |
| Dossiers | snake_case | `data_sources` |

### Structure des fichiers

```dart
// 1. Imports (ordre)
import 'dart:async';                    // Dart SDK
import 'package:flutter/material.dart'; // Flutter
import 'package:bloc/bloc.dart';        // Packages externes
import '../models/athlete.dart';        // Imports relatifs

// 2. Part directives
part 'athlete_model.g.dart';

// 3. Constantes
const int kMaxAthletes = 100;

// 4. Classes principales
class AthleteModel { ... }

// 5. Classes auxiliaires
class _AthleteHelper { ... }
```

### Bonnes pratiques

1. **Widgets** : Préférer `const` constructors
2. **Immutabilité** : Utiliser `final` et `@immutable`
3. **Null safety** : Éviter `!` sauf si absolument nécessaire
4. **Extensions** : Pour ajouter des méthodes aux types existants
5. **Barrel files** : Exporter via un fichier index

---

## 9. Dépendances

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter

  # UI
  cupertino_icons: ^1.0.8
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Navigation
  go_router: ^14.2.0

  # Network
  dio: ^5.4.0
  connectivity_plus: ^6.0.3

  # Storage
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.2.3

  # Utils
  intl: ^0.19.0
  get_it: ^7.6.7
  dartz: ^0.10.1

  # JSON
  json_annotation: ^4.8.1
  freezed_annotation: ^2.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.8
  json_serializable: ^6.7.1
  freezed: ^2.4.7
  bloc_test: ^9.1.7
  mocktail: ^1.0.3
```

### Génération de code

```bash
# Générer les fichiers .g.dart
flutter pub run build_runner build --delete-conflicting-outputs

# Mode watch (développement)
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 📎 Commandes utiles

```bash
# Installation des dépendances
flutter pub get

# Analyse du code
flutter analyze

# Tests
flutter test

# Build Android
flutter build apk --release

# Build iOS
flutter build ios --release
```

---

**Fin du document d'architecture**

*Document validé par Agent 2 — Architecte Flutter*
