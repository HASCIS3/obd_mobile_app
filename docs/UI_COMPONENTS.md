# Composants UI — OBD Mobile

**Version:** 1.0  
**Date:** 18 Décembre 2025  
**Auteur:** Agent 3 — Développeur Flutter UI & Navigation

---

## 📋 Sommaire

1. [Design System](#design-system)
2. [Widgets réutilisables](#widgets-réutilisables)
3. [Pages implémentées](#pages-implémentées)
4. [Navigation](#navigation)
5. [Formulaires](#formulaires)
6. [Guide d'utilisation](#guide-dutilisation)

---

## 1. Design System

### Couleurs (Drapeau Mali)

```dart
// Couleurs principales
primaryGreen: #14B53A   // Vert Mali
primaryYellow: #FCD116  // Jaune Mali
primaryRed: #CE1126     // Rouge Mali

// Couleurs sémantiques
success: #4CAF50
warning: #FF9800
error: #F44336
info: #2196F3
```

### Typographie

| Style | Taille | Poids | Usage |
|-------|--------|-------|-------|
| displayLarge | 32px | Bold | Titres principaux |
| headlineSmall | 18px | SemiBold | Titres de section |
| titleMedium | 14px | Medium | Titres de carte |
| bodyMedium | 14px | Regular | Texte courant |
| bodySmall | 12px | Regular | Texte secondaire |
| labelSmall | 10px | Medium | Labels, badges |

### Espacements

```dart
paddingXS: 4px
paddingS: 8px
paddingM: 16px
paddingL: 24px
paddingXL: 32px
```

### Rayons de bordure

```dart
radiusS: 8px
radiusM: 12px
radiusL: 16px
radiusFull: 999px  // Cercle/Pill
```

---

## 2. Widgets réutilisables

### Boutons

#### OBDPrimaryButton
Bouton principal avec fond vert.

```dart
OBDPrimaryButton(
  text: 'Enregistrer',
  onPressed: () {},
  isLoading: false,
  icon: Icons.check,
)
```

#### OBDOutlinedButton
Bouton secondaire avec bordure.

```dart
OBDOutlinedButton(
  text: 'Annuler',
  onPressed: () {},
  color: AppColors.error,  // Optionnel
)
```

#### OBDFloatingButton
Bouton d'action flottant.

```dart
OBDFloatingButton(
  onPressed: () {},
  icon: Icons.add,
  label: 'Nouveau',  // Optionnel pour FAB étendu
)
```

---

### Cartes

#### OBDCard
Carte de base.

```dart
OBDCard(
  onTap: () {},
  padding: EdgeInsets.all(16),
  child: Text('Contenu'),
)
```

#### OBDStatCard
Carte de statistique.

```dart
OBDStatCard(
  title: 'Athlètes',
  value: '45',
  subtitle: 'actifs',
  icon: Icons.people,
  color: AppColors.primary,
)
```

#### OBDListCard
Carte pour liste avec avatar.

```dart
OBDListCard(
  title: 'Amadou Konaté',
  subtitle: 'Cadet • 16 ans',
  leading: OBDAvatar(name: 'Amadou Konaté'),
  onTap: () {},
  badges: [OBDStatusBadge.active()],
)
```

#### OBDInfoCard
Carte d'information colorée.

```dart
OBDInfoCard(
  title: 'Attention',
  message: '3 athlètes ont des arriérés',
  icon: Icons.warning,
  color: AppColors.warning,
  actionLabel: 'Voir',
  onAction: () {},
)
```

---

### Avatars

#### OBDAvatar
Avatar avec initiales ou image.

```dart
OBDAvatar(
  name: 'Amadou Konaté',  // Génère "AK"
  imageUrl: 'https://...',  // Optionnel
  size: 48,
)
```

#### OBDAvatarWithStatus
Avatar avec indicateur de statut.

```dart
OBDAvatarWithStatus(
  name: 'Amadou',
  isOnline: true,
  statusColor: AppColors.success,
)
```

#### OBDAvatarGroup
Groupe d'avatars empilés.

```dart
OBDAvatarGroup(
  names: ['Amadou', 'Fatou', 'Moussa', 'Awa'],
  maxDisplay: 3,  // Affiche "+1"
)
```

---

### Badges

#### OBDStatusBadge
Badge de statut avec couleur.

```dart
// Factories disponibles
OBDStatusBadge.active()
OBDStatusBadge.inactive()
OBDStatusBadge.paye()
OBDStatusBadge.impaye()
OBDStatusBadge.partiel()
OBDStatusBadge.present()
OBDStatusBadge.absent()

// Personnalisé
OBDStatusBadge(
  label: 'En attente',
  color: AppColors.warning,
  icon: Icons.hourglass_empty,
)
```

#### OBDCategoryBadge
Badge de catégorie d'âge.

```dart
OBDCategoryBadge(category: 'Cadet')
// Couleurs automatiques selon catégorie
```

#### OBDDisciplineBadge
Badge de discipline.

```dart
OBDDisciplineBadge(discipline: 'Basket')
```

---

### Champs de saisie

#### OBDTextField
Champ de texte standard.

```dart
OBDTextField(
  controller: _controller,
  label: 'Nom',
  prefixIcon: Icons.person,
  validator: (value) => value!.isEmpty ? 'Requis' : null,
)
```

#### OBDSearchField
Champ de recherche.

```dart
OBDSearchField(
  controller: _searchController,
  hint: 'Rechercher un athlète...',
  onChanged: (value) {},
  onClear: () {},
)
```

#### OBDDropdown
Sélecteur dropdown.

```dart
OBDDropdown<int>(
  value: _selectedId,
  label: 'Discipline',
  items: [
    DropdownMenuItem(value: 1, child: Text('Basket')),
    DropdownMenuItem(value: 2, child: Text('Volley')),
  ],
  onChanged: (value) {},
)
```

#### OBDDatePicker
Sélecteur de date.

```dart
OBDDatePicker(
  value: _date,
  label: 'Date de naissance',
  onChanged: (date) {},
  lastDate: DateTime.now(),
)
```

---

### États

#### OBDLoading
Indicateur de chargement.

```dart
OBDLoading(message: 'Chargement...')
```

#### OBDShimmerList
Effet shimmer pour liste.

```dart
OBDShimmerList(itemCount: 5, itemHeight: 80)
```

#### OBDEmptyState
État vide.

```dart
// Factories disponibles
OBDEmptyState.athletes(onAdd: () {})
OBDEmptyState.search()
OBDEmptyState.paiements()
OBDEmptyState.presences()
OBDEmptyState.performances()
```

#### OBDErrorState
État d'erreur.

```dart
OBDErrorState.network(onRetry: () {})
OBDErrorState.server(onRetry: () {})
```

---

### Dialogues

#### OBDConfirmDialog
Dialogue de confirmation.

```dart
final result = await OBDConfirmDialog.show(
  context,
  title: 'Supprimer',
  message: 'Confirmer la suppression ?',
  isDanger: true,
);
if (result == true) { /* Supprimer */ }
```

#### OBDBottomSheet
Bottom sheet modal.

```dart
OBDBottomSheet.show(
  context,
  title: 'Filtres',
  child: FilterWidget(),
);
```

#### OBDSnackBar
Notifications toast.

```dart
OBDSnackBar.success(context, 'Enregistré !');
OBDSnackBar.error(context, 'Une erreur est survenue');
OBDSnackBar.warning(context, 'Attention');
```

---

## 3. Pages implémentées

### Authentification
| Page | Fichier | Description |
|------|---------|-------------|
| Splash | `splash_page.dart` | Écran de démarrage avec logo |
| Login | `login_page.dart` | Formulaire de connexion |
| Forgot Password | `forgot_password_page.dart` | Récupération mot de passe |

### Dashboard
| Page | Fichier | Description |
|------|---------|-------------|
| Dashboard | `dashboard_page.dart` | Stats, actions rapides, activités |

### Athlètes
| Page | Fichier | Description |
|------|---------|-------------|
| Liste | `athletes_page.dart` | Liste avec recherche et filtres |
| Détail | `athlete_detail_page.dart` | Profil complet de l'athlète |
| Formulaire | `athlete_form_page.dart` | Création/édition athlète |

### Présences
| Page | Fichier | Description |
|------|---------|-------------|
| Présences | `presences_page.dart` | Pointage + historique (tabs) |

### Paiements
| Page | Fichier | Description |
|------|---------|-------------|
| Liste | `paiements_page.dart` | Liste avec résumé mensuel |
| Formulaire | `paiement_form_page.dart` | Nouveau paiement |

### Performances
| Page | Fichier | Description |
|------|---------|-------------|
| Liste | `performances_page.dart` | Évaluations + classement (tabs) |
| Formulaire | `performance_form_page.dart` | Nouvelle évaluation |

### Disciplines
| Page | Fichier | Description |
|------|---------|-------------|
| Liste | `disciplines_page.dart` | Liste des disciplines |

### Profil
| Page | Fichier | Description |
|------|---------|-------------|
| Profil | `profile_page.dart` | Profil utilisateur + paramètres |

---

## 4. Navigation

### Structure des routes

```
/                     → Splash
/login                → Login
/forgot-password      → Forgot Password
/dashboard            → Dashboard (avec bottom nav)
/athletes             → Liste athlètes
/athletes/create      → Créer athlète
/athletes/:id         → Détail athlète
/athletes/:id/edit    → Modifier athlète
/presences            → Présences
/paiements            → Paiements
/paiements/create     → Nouveau paiement
/performances         → Performances
/performances/create  → Nouvelle évaluation
/disciplines          → Disciplines
/profile              → Profil
```

### Navigation programmatique

```dart
// Aller à une page
context.go('/dashboard');

// Pousser une page (avec retour possible)
context.push('/athletes/create');

// Retour
context.pop();

// Avec paramètres
context.push('/paiements/create?athleteId=1');
```

### Bottom Navigation

5 onglets principaux :
1. **Dashboard** - Accueil avec stats
2. **Athlètes** - Gestion des athlètes
3. **Présences** - Pointage
4. **Paiements** - Gestion financière
5. **Profil** - Paramètres utilisateur

---

## 5. Formulaires

### Validation

```dart
OBDTextField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    if (!value.contains('@')) {
      return 'Email invalide';
    }
    return null;
  },
)
```

### Soumission

```dart
Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;
  
  setState(() => _isLoading = true);
  
  try {
    // Appel API
    await repository.create(data);
    
    OBDSnackBar.success(context, 'Enregistré !');
    context.pop(true);
  } catch (e) {
    OBDSnackBar.error(context, e.toString());
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

## 6. Guide d'utilisation

### Import des widgets

```dart
import 'package:obd_mobile_app/core/widgets/widgets.dart';
```

### Exemple de page complète

```dart
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exemple')),
      floatingActionButton: OBDFloatingButton(
        onPressed: () {},
        icon: Icons.add,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: EdgeInsets.all(AppSizes.paddingM),
          children: [
            OBDSearchField(hint: 'Rechercher...'),
            SizedBox(height: 16),
            OBDListCard(
              title: 'Item 1',
              subtitle: 'Description',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

---

**Fin du document UI Components**

*Document validé par Agent 3 — Développeur Flutter UI & Navigation*
