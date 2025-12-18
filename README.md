# OBD Mobile App

Application mobile Flutter pour la gestion du centre sportif **OBD (Organisation Basket Développement)** au Mali.

## 📱 Description

Cette application mobile est le compagnon de la plateforme web Laravel OBD existante. Elle permet aux différents utilisateurs (admins, coachs, athlètes, parents) de gérer et consulter les informations du centre sportif.

## 🎯 Fonctionnalités Principales

### Pour les Admins
- Dashboard avec statistiques globales
- Gestion complète des athlètes
- Gestion des paiements et arriérés
- Suivi des présences et performances

### Pour les Coachs
- Pointage rapide des présences
- Saisie des performances
- Consultation des athlètes de leurs disciplines

### Pour les Athlètes/Parents
- Consultation du profil et statistiques
- Historique des présences
- Suivi des paiements
- Évolution des performances

## 🏗️ Architecture

Le projet utilise **Clean Architecture** avec :
- **Bloc/Riverpod** pour la gestion d'état
- **Dio** pour les appels API
- **GoRouter** pour la navigation
- **Flutter Secure Storage** pour le stockage sécurisé

## 🎨 Design System

Couleurs du drapeau Mali :
- 🟢 Vert : `#14B53A`
- 🟡 Jaune : `#FCD116`
- 🔴 Rouge : `#CE1126`

## 📚 Documentation

- [Spécifications Fonctionnelles](docs/SPECIFICATIONS_FONCTIONNELLES.md)
- [Flux Utilisateurs](docs/FLUX_UTILISATEURS.md)
- [Priorités MVP](docs/PRIORITES_MVP.md)
- [Répartition des Agents](AGENTS.md)

## 🚀 Getting Started

### Prérequis
- Flutter SDK ^3.10.1
- Dart SDK ^3.10.1
- Backend Laravel OBD avec API REST

### Installation

```bash
# Cloner le projet
git clone <repository-url>

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Configuration

Créer un fichier `.env` à la racine :
```
API_BASE_URL=http://votre-api-laravel.com/api
```

## 📦 Structure du Projet

```
lib/
├── core/
│   ├── config/          # Configuration app
│   ├── constants/       # Constantes (couleurs, strings)
│   ├── errors/          # Gestion des erreurs
│   ├── network/         # Configuration Dio
│   └── utils/           # Utilitaires
├── features/
│   ├── auth/            # Authentification
│   ├── dashboard/       # Dashboard
│   ├── athletes/        # Gestion athlètes
│   ├── presences/       # Gestion présences
│   ├── paiements/       # Gestion paiements
│   ├── performances/    # Gestion performances
│   ├── disciplines/     # Disciplines
│   └── profile/         # Profil utilisateur
└── main.dart
```

## 🤝 Équipe de Développement

Voir [AGENTS.md](AGENTS.md) pour la répartition des rôles.

## 📄 Licence

Projet privé - OBD Mali
