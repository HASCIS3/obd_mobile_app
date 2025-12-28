# 📱 Guide de Démarrage - Application OBD Mobile

## 🔧 Prérequis

- **Flutter** installé sur votre PC
- **PHP** et **Composer** installés
- **Téléphone Android** avec câble USB ou sur le même Wi-Fi
- **Backend Laravel OBD** dans `D:\projects\obd`

---

## 📋 Étapes pour lancer l'application

### Étape 1 : Trouver l'IP de votre PC

Ouvrez un terminal et exécutez :
```powershell
ipconfig
```

Notez l'**Adresse IPv4** de votre connexion Wi-Fi (ex: `192.168.1.7`).

---

### Étape 2 : Configurer l'IP dans l'app Flutter

Modifiez le fichier :
```
D:\projects\flutter\obd_mobile\obd_mobile_app\lib\core\config\app_config.dart
```

Changez la ligne `defaultValue` avec votre IP :
```dart
static const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://VOTRE_IP:8000/api', // Remplacez VOTRE_IP
);
```

---

### Étape 3 : Ouvrir le port 8000 dans le pare-feu Windows

⚠️ **IMPORTANT** : Sans cette étape, le téléphone ne peut pas se connecter au serveur !

#### Méthode 1 : Commande PowerShell (Recommandée)

1. Ouvrez **PowerShell en tant qu'Administrateur** :
   - Appuyez sur `Windows + X`
   - Cliquez sur **"Terminal (Admin)"** ou **"PowerShell (Admin)"**

2. Exécutez cette commande :
```powershell
netsh advfirewall firewall add rule name="Laravel OBD" dir=in action=allow protocol=TCP localport=8000
```

3. Vous devriez voir : `Ok.`

#### Méthode 2 : Interface graphique

1. Ouvrez le **Panneau de configuration**
2. Allez dans **Système et sécurité** → **Pare-feu Windows Defender**
3. Cliquez sur **Paramètres avancés** (à gauche)
4. Cliquez sur **Règles de trafic entrant** (à gauche)
5. Cliquez sur **Nouvelle règle...** (à droite)
6. Sélectionnez **Port** → Suivant
7. Sélectionnez **TCP** et entrez **8000** → Suivant
8. Sélectionnez **Autoriser la connexion** → Suivant
9. Cochez les 3 options (Domaine, Privé, Public) → Suivant
10. Nommez la règle **"Laravel OBD"** → Terminer

---

### Étape 4 : Lancer le serveur Laravel

Ouvrez un terminal et exécutez :
```powershell
cd D:\projects\obd
php artisan serve --host=0.0.0.0 --port=8000
```

Vous devriez voir :
```
INFO  Server running on [http://0.0.0.0:8000].
```

⚠️ **Laissez ce terminal ouvert !**

---

### Étape 5 : Lancer l'application Flutter

Ouvrez un **autre terminal** et exécutez :
```powershell
cd D:\projects\flutter\obd_mobile\obd_mobile_app
flutter run
```

Ou pour cibler un appareil spécifique :
```powershell
flutter devices  # Pour voir les appareils disponibles
flutter run -d DEVICE_ID  # Remplacez DEVICE_ID
```

---

### Étape 6 : Se connecter

Sur l'écran de connexion, utilisez :
- **Email** : `admin@centresport.ml`
- **Mot de passe** : `password`

---

## 🔥 Commandes utiles Flutter

| Action | Commande |
|--------|----------|
| Voir les appareils | `flutter devices` |
| Lancer l'app | `flutter run` |
| Hot reload | Appuyez sur `r` dans le terminal |
| Hot restart | Appuyez sur `R` dans le terminal |
| Arrêter l'app | Appuyez sur `q` dans le terminal |
| Installer les dépendances | `flutter pub get` |
| Générer le code Freezed | `dart run build_runner build --delete-conflicting-outputs` |
| Analyser le code | `flutter analyze` |
| Lancer les tests | `flutter test` |
| Build APK | `flutter build apk --release` |

---

## 🔥 Commandes utiles Laravel

| Action | Commande |
|--------|----------|
| Lancer le serveur | `php artisan serve --host=0.0.0.0 --port=8000` |
| Voir les routes | `php artisan route:list` |
| Migrer la BDD | `php artisan migrate` |
| Seeder la BDD | `php artisan db:seed` |
| Vider le cache | `php artisan cache:clear` |

---

## ❌ Problèmes courants et solutions

### 1. "Délai de connexion dépassé" ou "Connection timeout"

**Cause** : Le pare-feu Windows bloque le port 8000.

**Solution** : Ouvrez le port 8000 (voir Étape 3).

---

### 2. "Pas de connexion internet" dans l'app

**Causes possibles** :
- Le téléphone n'est pas sur le même Wi-Fi que le PC
- L'IP dans `app_config.dart` est incorrecte
- Le serveur Laravel n'est pas lancé

**Solutions** :
1. Vérifiez que le téléphone et le PC sont sur le même réseau Wi-Fi
2. Vérifiez l'IP avec `ipconfig` et mettez à jour `app_config.dart`
3. Relancez le serveur Laravel

---

### 3. "Identifiants incorrects"

**Cause** : L'utilisateur n'existe pas dans la base de données.

**Solution** : Exécutez les seeders Laravel :
```powershell
cd D:\projects\obd
php artisan db:seed
```

---

### 4. L'app ne se lance pas sur le téléphone

**Causes possibles** :
- Le téléphone n'est pas en mode développeur
- Le débogage USB n'est pas activé

**Solutions** :
1. Sur le téléphone, allez dans **Paramètres** → **À propos du téléphone**
2. Tapez 7 fois sur **Numéro de build** pour activer le mode développeur
3. Allez dans **Paramètres** → **Options pour les développeurs**
4. Activez **Débogage USB**
5. Reconnectez le câble USB et acceptez l'autorisation

---

### 5. Erreur "No pubspec.yaml file found"

**Cause** : Vous n'êtes pas dans le bon dossier.

**Solution** : Assurez-vous d'être dans le dossier du projet Flutter :
```powershell
cd D:\projects\flutter\obd_mobile\obd_mobile_app
```

---

## 📁 Structure des projets

### Backend Laravel
```
D:\projects\obd\
├── app/              # Code PHP
├── routes/api.php    # Routes API
├── database/         # Migrations et seeders
└── .env              # Configuration (BDD, etc.)
```

### Application Flutter
```
D:\projects\flutter\obd_mobile\obd_mobile_app\
├── lib/
│   ├── core/         # Configuration, modèles, widgets
│   ├── features/     # Fonctionnalités (auth, dashboard, etc.)
│   └── main.dart     # Point d'entrée
├── pubspec.yaml      # Dépendances
└── docs/             # Documentation
```

---

## 📞 Endpoints API

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/api/login` | POST | Connexion |
| `/api/logout` | POST | Déconnexion |
| `/api/user` | GET | Utilisateur connecté |
| `/api/dashboard` | GET | Statistiques |
| `/api/athletes` | GET/POST | Liste/Créer athlètes |
| `/api/athletes/{id}` | GET/PUT/DELETE | Détail/Modifier/Supprimer |
| `/api/presences` | GET/POST | Liste/Créer présences |
| `/api/paiements` | GET/POST | Liste/Créer paiements |
| `/api/performances` | GET/POST | Liste/Créer performances |
| `/api/disciplines` | GET | Liste disciplines |

---

## ✅ Checklist avant de tester

- [ ] IP correcte dans `app_config.dart`
- [ ] Port 8000 ouvert dans le pare-feu
- [ ] Serveur Laravel lancé avec `--host=0.0.0.0`
- [ ] Téléphone sur le même Wi-Fi que le PC
- [ ] Base de données migrée et seedée

---

## 🌐 Lancer l'application WEB

### Méthode rapide (recommandée pour le développement)

1. **Lancer le serveur Laravel** :
```powershell
cd D:\projects\obd
php artisan serve --host=0.0.0.0 --port=8000
```

2. **Lancer l'app Flutter sur Chrome** :
```powershell
cd D:\projects\flutter\obd_mobile\obd_mobile_app
flutter run -d chrome
```

L'application s'ouvrira automatiquement dans Chrome.

---

### Commandes web Flutter

| Action | Commande |
|--------|----------|
| Lancer sur Chrome | `flutter run -d chrome` |
| Lancer sur Edge | `flutter run -d edge` |
| Build web (production) | `flutter build web --release` |
| Servir le build web | `cd build/web && python -m http.server 8080` |

---

### Configuration web

L'application web utilise `http://127.0.0.1:8000/api` par défaut, ce qui fonctionne directement avec le serveur Laravel local.

**Pas besoin de configurer le pare-feu pour le web** - le navigateur et le serveur sont sur le même PC.

---

## 📱 Lancer l'application MOBILE (via USB)

### Méthode ADB Reverse (recommandée)

Cette méthode utilise le câble USB pour faire passer les requêtes, évitant les problèmes de pare-feu et de Wi-Fi.

1. **Connecter le téléphone en USB** avec le débogage USB activé

2. **Configurer le port forwarding** :
```powershell
adb reverse tcp:8000 tcp:8000
```

3. **Configurer l'IP dans `app_config.dart`** :
```dart
defaultValue: 'http://127.0.0.1:8000/api', // Via ADB reverse (USB)
```

4. **Lancer le serveur Laravel** :
```powershell
cd D:\projects\obd
php artisan serve --host=0.0.0.0 --port=8000
```

5. **Lancer l'app Flutter** :
```powershell
cd D:\projects\flutter\obd_mobile\obd_mobile_app
flutter run -d DEVICE_ID
```

---

### Méthode Wi-Fi (alternative)

Si vous préférez tester sans câble USB :

1. **Ouvrir le port 8000 dans le pare-feu** (voir section plus haut)

2. **Trouver l'IP de votre PC** :
```powershell
ipconfig
```

3. **Configurer l'IP dans `app_config.dart`** :
```dart
defaultValue: 'http://VOTRE_IP:8000/api', // IP Wi-Fi de votre PC
```

4. **S'assurer que le téléphone est sur le même réseau Wi-Fi**

---

## 🔄 Basculer entre Web et Mobile

Pour basculer facilement entre les plateformes, modifiez `app_config.dart` :

| Plateforme | Configuration |
|------------|---------------|
| **Web** | `http://127.0.0.1:8000/api` |
| **Mobile (USB)** | `http://127.0.0.1:8000/api` + `adb reverse tcp:8000 tcp:8000` |
| **Mobile (Wi-Fi)** | `http://VOTRE_IP:8000/api` + pare-feu ouvert |
| **Émulateur Android** | `http://10.0.2.2:8000/api` |

---

**Bonne continuation ! 🚀**
