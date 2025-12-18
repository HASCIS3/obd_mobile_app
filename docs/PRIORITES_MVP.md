# Priorités MVP — Application Mobile OBD

**Version:** 1.0  
**Date:** 18 Décembre 2025  
**Auteur:** Agent 1 — Product Owner / Coordination

---

## 🎯 Objectif MVP

Livrer une **première version fonctionnelle** de l'application mobile OBD permettant :
1. L'authentification sécurisée
2. La consultation des données (athlètes, présences, paiements)
3. Le pointage des présences par les coachs
4. La visualisation du dashboard selon le rôle

**Délai estimé MVP:** 4-6 semaines

---

## 📊 Matrice de Priorités

### Légende

| Priorité | Signification | Délai |
|----------|---------------|-------|
| **P0** | Indispensable - Bloquant | Sprint 1 |
| **P1** | Important - Nécessaire | Sprint 2 |
| **P2** | Utile - Amélioration | Sprint 3 |
| **P3** | Nice-to-have | Post-MVP |

---

## 🚀 Sprint 1 — Fondations (Semaines 1-2)

### Architecture & Setup (Agent 2)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Structure projet Clean Architecture | P0 | 4h |
| Configuration Bloc/Riverpod | P0 | 2h |
| Configuration Dio + Interceptors | P0 | 3h |
| Modèles Dart (User, Athlete, etc.) | P0 | 4h |
| Gestion erreurs globale | P0 | 2h |
| Configuration environnements (dev/prod) | P0 | 1h |

### Authentification (Agent 5)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Écran Login | P0 | 3h |
| Service AuthRepository | P0 | 3h |
| Stockage sécurisé token | P0 | 2h |
| Gestion session expirée | P0 | 2h |
| Redirection selon rôle | P0 | 2h |

### Navigation (Agent 3)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Configuration GoRouter | P0 | 2h |
| Routes protégées | P0 | 2h |
| Bottom Navigation Bar | P0 | 2h |
| Splash Screen | P0 | 1h |

### Design System (Agent 3)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Thème couleurs Mali | P0 | 2h |
| Typographie | P0 | 1h |
| Composants de base (Button, Input, Card) | P0 | 4h |

**Total Sprint 1:** ~40h

---

## 🏃 Sprint 2 — Fonctionnalités Core (Semaines 3-4)

### Dashboard (Agent 3 + Agent 4)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Dashboard Admin | P0 | 4h |
| Dashboard Coach | P0 | 3h |
| Dashboard Athlète | P0 | 3h |
| API Dashboard | P0 | 2h |

### Athlètes (Agent 3 + Agent 4)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Liste athlètes + recherche | P0 | 4h |
| Détail athlète | P0 | 3h |
| Filtres (discipline, statut) | P0 | 2h |
| API Athlètes | P0 | 3h |
| Formulaire création athlète | P1 | 4h |
| Formulaire modification athlète | P1 | 3h |

### Présences (Agent 3 + Agent 4)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Écran pointage rapide | P0 | 5h |
| Liste présences | P0 | 3h |
| Stats présence athlète | P0 | 2h |
| API Présences | P0 | 3h |

**Total Sprint 2:** ~44h

---

## 🎯 Sprint 3 — Compléments MVP (Semaines 5-6)

### Paiements (Agent 3 + Agent 4)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Liste paiements | P0 | 3h |
| Détail paiement | P0 | 2h |
| Filtres paiements | P1 | 2h |
| API Paiements | P0 | 3h |
| Formulaire paiement | P1 | 4h |
| Écran arriérés | P1 | 3h |

### Performances (Agent 3 + Agent 4)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Liste performances | P1 | 3h |
| Détail performance | P1 | 2h |
| Formulaire saisie | P1 | 4h |
| Graphique évolution | P1 | 4h |
| API Performances | P1 | 3h |

### Profil (Agent 3 + Agent 4)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Écran profil | P0 | 2h |
| Modification profil | P1 | 3h |
| Changement mot de passe | P1 | 2h |
| Déconnexion | P0 | 1h |

### Disciplines (Agent 3 + Agent 4)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Liste disciplines | P1 | 2h |
| Détail discipline | P1 | 2h |

**Total Sprint 3:** ~45h

---

## 📱 Post-MVP (Phase 2)

### Notifications (Agent 6)

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Configuration FCM | P2 | 4h |
| Enregistrement device | P2 | 2h |
| Notification absence | P2 | 3h |
| Notification paiement | P2 | 3h |
| Notification performance | P2 | 2h |

### Activités/Actualités

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Liste activités | P2 | 2h |
| Détail activité | P2 | 2h |

### Améliorations UX

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Mode hors-ligne (présences) | P2 | 8h |
| Pull-to-refresh | P2 | 2h |
| Skeleton loading | P2 | 3h |
| Animations transitions | P3 | 4h |

### Export & Rapports

| Tâche | Priorité | Effort |
|-------|----------|--------|
| Génération reçu PDF | P2 | 4h |
| Rapport mensuel PDF | P3 | 4h |
| Partage WhatsApp | P3 | 2h |

---

## 🔧 Tâches Backend Laravel

Pour que l'application mobile fonctionne, le backend Laravel doit exposer des **API REST**.

### API à créer (Priorité P0)

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/api/login` | POST | Authentification |
| `/api/logout` | POST | Déconnexion |
| `/api/user` | GET | Utilisateur connecté |
| `/api/dashboard` | GET | Stats dashboard |
| `/api/athletes` | GET | Liste athlètes |
| `/api/athletes/{id}` | GET | Détail athlète |
| `/api/athletes` | POST | Créer athlète |
| `/api/presences` | GET | Liste présences |
| `/api/presences` | POST | Enregistrer présences |
| `/api/paiements` | GET | Liste paiements |
| `/api/paiements/{id}` | GET | Détail paiement |
| `/api/disciplines` | GET | Liste disciplines |

### Configuration Laravel

```php
// Installation Sanctum pour API tokens
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
php artisan migrate

// config/cors.php - Autoriser les requêtes mobiles
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_origins' => ['*'],
```

---

## ✅ Critères d'Acceptation MVP

### Authentification
- [ ] Un utilisateur peut se connecter avec email/mot de passe
- [ ] Le token est stocké de manière sécurisée
- [ ] La session expire après 7 jours d'inactivité
- [ ] L'utilisateur est redirigé vers le bon dashboard selon son rôle

### Dashboard
- [ ] L'admin voit les stats globales (athlètes, revenus, présences)
- [ ] Le coach voit ses disciplines et athlètes
- [ ] L'athlète voit son profil et ses stats personnelles

### Athlètes
- [ ] La liste affiche tous les athlètes avec pagination
- [ ] La recherche fonctionne par nom/prénom
- [ ] Les filtres par discipline et statut fonctionnent
- [ ] Le détail affiche toutes les informations de l'athlète

### Présences
- [ ] Le coach peut pointer les présences de sa discipline
- [ ] Le pointage multiple (tout présent/absent) fonctionne
- [ ] L'historique des présences est consultable
- [ ] Le taux de présence est calculé correctement

### Paiements
- [ ] La liste affiche les paiements avec statut coloré
- [ ] Les filtres par statut/période fonctionnent
- [ ] Le détail affiche montant, reste à payer, historique

### Profil
- [ ] L'utilisateur peut voir son profil
- [ ] L'utilisateur peut se déconnecter

---

## 📅 Planning Récapitulatif

```
Semaine 1-2: Sprint 1 - Fondations
├── Architecture Flutter
├── Authentification
├── Navigation
└── Design System

Semaine 3-4: Sprint 2 - Core
├── Dashboard (3 rôles)
├── Gestion Athlètes
└── Gestion Présences

Semaine 5-6: Sprint 3 - Compléments
├── Gestion Paiements
├── Gestion Performances
├── Profil utilisateur
└── Tests & Corrections

Semaine 7+: Post-MVP
├── Notifications Push
├── Mode hors-ligne
├── Exports PDF
└── Améliorations UX
```

---

## 🤝 Coordination Agents

### Dépendances entre agents

```
Agent 2 (Architecte) ──► Agent 3 (UI) ──► Agent 7 (Tests)
         │                    │
         └──► Agent 4 (API) ──┘
                    │
         Agent 5 (Sécurité)
                    │
         Agent 6 (Notifications) [Post-MVP]
                    │
         Agent 8 (Déploiement) [Fin MVP]
```

### Points de synchronisation

1. **Fin Sprint 1:** Validation architecture + auth fonctionnelle
2. **Fin Sprint 2:** Démo dashboard + athlètes + présences
3. **Fin Sprint 3:** MVP complet, prêt pour tests
4. **Post-MVP:** Intégration notifications, préparation stores

---

**Fin du document de priorités MVP**

*Document validé par Agent 1 — Product Owner / Coordination*
