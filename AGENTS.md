# AGENTS.md — Projet Mobile Flutter (OBD)

Ce document définit la **répartition claire des tâches** entre plusieurs agents pour le développement de l’application **mobile Flutter**, connectée au backend **Laravel OBD existant**.

L’objectif est de garantir :
- une architecture propre,
- une bonne collaboration,
- une application mobile maintenable et évolutive.

---

## 🧑‍💼 Agent 1 — **Product Owner / Coordination**

### Responsabilités :
- Définir les besoins fonctionnels mobiles à partir de la version web.
- Prioriser les fonctionnalités (MVP vs évolutions).
- Valider les écrans, flux utilisateurs et règles métier.
- Faire le lien entre backend Laravel et frontend Flutter.

### Pourquoi ce rôle ?
Sans coordination claire, le projet mobile risque de diverger de la logique métier existante sur le web.

---

## 🏗️ Agent 2 — **Architecte Flutter**

### Responsabilités :
- Définir l’architecture Flutter (Clean Architecture / MVVM).
- Choisir la gestion d’état (Bloc ou Riverpod).
- Mettre en place la structure des dossiers.
- Définir les conventions de code Dart.

### Pourquoi ce rôle ?
Une mauvaise architecture rend Flutter difficile à maintenir à moyen terme.

---

## 📱 Agent 3 — **Développeur Flutter – UI & Navigation**

### Responsabilités :
- Implémenter les écrans Flutter (login, dashboard, listes, détails).
- Mettre en place la navigation (BottomNavigationBar, routes protégées).
- Appliquer le design system (couleurs Mali : vert, jaune, rouge).
- Gérer le responsive mobile.

### Pourquoi ce rôle ?
L’expérience utilisateur est critique sur mobile ; elle doit être fluide et intuitive.

---

## 🔌 Agent 4 — **Développeur Flutter – API & State Management**

### Responsabilités :
- Consommer les APIs Laravel (auth, athlètes, paiements, présences, performances).
- Mapper les modèles Laravel vers des modèles Dart.
- Implémenter la gestion d’état (loading, error, success).
- Gérer l’authentification par token.

### Pourquoi ce rôle ?
Une mauvaise gestion des états et des APIs entraîne bugs, lenteurs et crashes.

---

## 🔐 Agent 5 — **Sécurité & Authentification Mobile**

### Responsabilités :
- Gestion sécurisée des tokens (flutter_secure_storage).
- Protection des écrans selon les rôles (admin, coach, parent, athlète).
- Gestion des expirations de session.
- Validation côté client.

### Pourquoi ce rôle ?
Les données sportives et financières doivent rester confidentielles.

---

## 🔔 Agent 6 — **Notifications & Temps réel**

### Responsabilités :
- Intégrer Firebase Cloud Messaging (FCM).
- Gérer l’enregistrement des devices.
- Définir les types de notifications (absence, paiement, performance).
- Tester la réception sur Android et iOS.

### Pourquoi ce rôle ?
Les notifications sont un élément clé de valeur pour les parents et coachs.

---

## 🧪 Agent 7 — **Tests & Qualité Mobile**

### Responsabilités :
- Écrire tests unitaires Flutter.
- Tester les parcours critiques (login, pointage, paiement).
- Vérifier performances et stabilité.
- Identifier et corriger les bugs.

### Pourquoi ce rôle ?
Une application mobile instable est rapidement désinstallée par les utilisateurs.

---

## 📦 Agent 8 — **Build, Déploiement & Documentation**

### Responsabilités :
- Configurer les builds Android et iOS.
- Préparer les signatures (keystore, certificates).
- Rédiger la documentation mobile (README Flutter).
- Préparer la publication (Play Store / App Store).

### Pourquoi ce rôle ?
Un projet non déployé correctement ne peut pas être utilisé en production.

---

## 🔄 Règles de collaboration

- Respect strict du contrat API Laravel ↔ Flutter.
- Communication continue entre agents.
- Commits Git clairs et fréquents.
- Code lisible et documenté.

---

**Fin du fichier AGENTS.md – Projet Mobile Flutter OBD**

