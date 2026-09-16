# 📱 DeviceSpecs

> **Inspecteur d'informations système pour Android & iOS, développé avec Flutter & Dart.**

DeviceSpecs est une application mobile permettant à un utilisateur de consulter de manière claire et structurée les principales informations concernant son appareil mobile.

Le projet met particulièrement l'accent sur :

* 📱 le développement cross-platform avec Flutter ;
* 🧠 Dart et une architecture logicielle maintenable ;
* 🔌 les intégrations natives Android/iOS ;
* 📦 l'utilisation de packages open-source ;
* 🎨 une interface moderne inspirée de la maquette du projet ;
* ✨ des animations et micro-interactions soignées ;
* 🧪 les tests et la qualité du code.

---

# 📑 Table des matières

* [Présentation](#-présentation)
* [Objectifs du projet](#-objectifs-du-projet)
* [Fonctionnalités](#-fonctionnalités)

  * [1. Sign Up](#1--sign-up)
  * [2. Login](#2--login)
  * [3. Dashboard](#3--dashboard)
  * [4. System Info](#4--system-info)
  * [5. Profile](#5--profile)
* [Architecture](#-architecture)
* [Structure du projet](#-structure-du-projet)
* [Flux de données](#-flux-de-données)
* [Navigation](#-navigation)
* [Native Integration](#-native-integration)
* [Packages Open-Source](#-packages-open-source)
* [Gestion de l'état](#-gestion-de-létat)
* [Design System](#-design-system)
* [Animations](#-animations)
* [Gestion des erreurs](#-gestion-des-erreurs)
* [Tests](#-tests)
* [Qualité du code](#-qualité-du-code)
* [Compatibilité](#-compatibilité)
* [Installation](#-installation)
* [Configuration](#-configuration)
* [Convention Git](#-convention-git)
* [Roadmap](#-roadmap)
* [Limitations](#-limitations)
* [Contribution](#-contribution)
* [Licence](#-licence)
* [Auteur](#-auteur)

---

# 📱 Présentation

DeviceSpecs est un **inspecteur d'informations système** destiné aux appareils Android et iOS.

L'application permet à l'utilisateur de :

1. créer son compte ;
2. se connecter ;
3. consulter un tableau de bord présentant un résumé de son appareil ;
4. consulter les caractéristiques techniques détaillées du système ;
5. gérer son profil et les paramètres de l'application.

Le projet est conçu comme une application Flutter complète permettant de mettre en pratique le développement mobile moderne ainsi que la communication entre Flutter et les plateformes natives.

---

# 🎯 Objectifs du projet

## Objectif principal

Développer une application Flutter capable de récupérer, organiser et présenter les informations matérielles et logicielles d'un appareil mobile à travers une interface moderne et intuitive.

## Objectifs techniques

Le projet permet de mettre en pratique :

* Flutter ;
* Dart ;
* architecture Feature-first ;
* séparation Presentation / Domain / Data ;
* MVVM ;
* Repository Pattern ;
* Service Pattern ;
* Dependency Injection ;
* gestion d'état ;
* Platform Channels ;
* Kotlin pour Android ;
* Swift pour iOS ;
* packages Flutter open-source ;
* responsive design ;
* animations Flutter ;
* tests unitaires ;
* tests de widgets ;
* tests d'intégration ;
* Git et GitHub.

---

# ✨ Fonctionnalités

DeviceSpecs possède **5 interfaces principales**.

```text
┌─────────────────────────────────────────┐
│              DeviceSpecs                │
├─────────────────────────────────────────┤
│                                         │
│  1. Sign Up                             │
│  2. Login                               │
│  3. Dashboard                           │
│  4. System Info                         │
│  5. Profile                             │
│                                         │
└─────────────────────────────────────────┘
```

---

# 1. 🔐 Sign Up

La page **Sign Up** permet à un nouvel utilisateur de créer son compte.

## Fonctionnalités

* Création d'un compte ;
* saisie du nom ;
* saisie de l'adresse email ;
* création du mot de passe ;
* confirmation du mot de passe ;
* validation des champs ;
* affichage des erreurs ;
* navigation vers Login.

## Objectif UX

La création de compte doit être :

* simple ;
* rapide ;
* claire ;
* sécurisée ;
* accompagnée d'un feedback visuel.

---

# 2. 🔑 Login

La page **Login** permet à un utilisateur existant d'accéder à son espace.

## Fonctionnalités

* Email ;
* mot de passe ;
* validation des champs ;
* affichage des erreurs ;
* connexion ;
* navigation vers Sign Up ;
* maintien de la session lorsque cela est prévu.

## Flux

```text
Login
  │
  ├── Identifiants valides
  │          ↓
  │      Dashboard
  │
  └── Identifiants invalides
             ↓
        Message d'erreur
```

---

# 3. 🏠 Dashboard

Le **Dashboard** constitue l'écran principal après authentification.

Il fournit une vue synthétique des informations importantes de l'appareil.

## Informations affichées

* Nom de l'appareil ;
* modèle ;
* système d'exploitation ;
* niveau de batterie ;
* RAM ;
* stockage ;
* informations processeur ;
* résumé de l'état du système.

## Exemple de structure

```text
Dashboard
│
├── Device Summary
│
├── Battery
│
├── Memory
│
├── Storage
│
├── CPU
│
└── Quick Actions
```

Le Dashboard affiche uniquement les informations nécessaires à une consultation rapide.

Les informations techniques détaillées sont accessibles depuis **System Info**.

---

# 4. ⚙️ System Info

La page **System Info** constitue le cœur technique de DeviceSpecs.

Elle permet de consulter les caractéristiques détaillées de l'appareil.

## 📱 Device

* Fabricant ;
* modèle ;
* nom de l'appareil ;
* architecture ;
* informations matérielles disponibles.

## 🧠 CPU

* Architecture ;
* nombre de cœurs ;
* informations processeur disponibles ;
* ABI lorsque disponible.

## 🎮 GPU

Lorsque les informations sont accessibles :

* GPU ;
* renderer ;
* API graphique ;
* informations de rendu.

## 💾 Memory

* RAM totale ;
* RAM disponible ;
* RAM utilisée ;
* pourcentage d'utilisation.

## 💽 Storage

* Stockage total ;
* stockage disponible ;
* stockage utilisé ;
* pourcentage d'utilisation.

## 🔋 Battery

* Niveau de batterie ;
* état de charge ;
* source d'alimentation ;
* informations disponibles sur l'état de la batterie.

## 🖥️ Display

* Résolution ;
* densité ;
* ratio de pixels ;
* taille logique ;
* orientation ;
* autres informations disponibles.

## 📡 Network

Lorsque les informations sont accessibles :

* type de connexion ;
* état de la connexion ;
* informations réseau disponibles.

## 📳 Sensors

Lorsque la plateforme le permet :

* Accéléromètre ;
* gyroscope ;
* magnétomètre ;
* proximité ;
* autres capteurs disponibles.

---

# 5. 👤 Profile

La page **Profile** centralise les informations personnelles et les préférences de l'utilisateur.

Elle ne se limite donc pas à l'affichage du profil.

## 👤 Informations utilisateur

* Nom ;
* email ;
* avatar/photo de profil ;
* informations du compte.

## 🎨 Apparence

L'utilisateur peut choisir :

* ☀️ Mode clair ;
* 🌙 Mode sombre ;
* 📱 Mode système.

Le changement de thème doit être appliqué à l'ensemble de l'application.

```text
Profile
   │
   ▼
Theme Preference
   │
   ▼
Application Theme
   │
   ├── Light Theme
   ├── Dark Theme
   └── System Theme
```

## ⚙️ Paramètres

La page Profile peut également regrouper :

* préférences de l'application ;
* notifications ;
* langue ;
* autres paramètres futurs.

## 🔐 Compte

* Déconnexion ;
* gestion du compte ;
* informations relatives à la session.

---

# 🏗️ Architecture

DeviceSpecs adopte une architecture **Feature-first** combinée à une séparation en couches.

Les principales responsabilités sont séparées entre :

```text
Presentation
     ↓
Domain
     ↓
Data
     ↓
Services
     ↓
Packages / Native APIs
```

## Architecture globale

```text
┌────────────────────────────────────────────┐
│               PRESENTATION                │
│                                            │
│     Pages / Widgets / ViewModels           │
└──────────────────────┬─────────────────────┘
                       │
                       ▼
┌────────────────────────────────────────────┐
│                  DOMAIN                   │
│                                            │
│      Entities / Repository Contracts       │
└──────────────────────┬─────────────────────┘
                       │
                       ▼
┌────────────────────────────────────────────┐
│                   DATA                    │
│                                            │
│ Models / Repositories / Data Sources       │
└──────────────────────┬─────────────────────┘
                       │
             ┌─────────┴──────────┐
             ▼                    ▼
      Open-source              Native
       Packages              Services
             │                    │
             └─────────┬──────────┘
                       ▼
                 Android / iOS
```

---

# 🧩 Feature-first Architecture

Les fonctionnalités principales sont organisées ainsi :

```text
features/
│
├── authentication/
├── dashboard/
├── system_info/
└── profile/
```

Pourquoi `authentication` contient deux pages ?

Parce que **Sign Up et Login appartiennent au même domaine fonctionnel : l'authentification**.

```text
authentication/
│
├── login
└── signup
```

De même, CPU, RAM, batterie et stockage ne sont pas des pages indépendantes.

Ils appartiennent au domaine :

```text
system_info/
```

---

# 📂 Structure du projet

```text
devicespecs/
│
├── android/
│
├── ios/
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── animations/
│
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart
│   │   │
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   │
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── light_theme.dart
│   │       ├── dark_theme.dart
│   │       ├── app_colors.dart
│   │       ├── app_typography.dart
│   │       └── app_spacing.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── extensions/
│   │   ├── utils/
│   │   ├── dependency_injection/
│   │   │   └── service_locator.dart
│   │   │
│   │   └── widgets/
│   │       ├── app_button.dart
│   │       ├── app_text_field.dart
│   │       ├── app_card.dart
│   │       ├── loading_widget.dart
│   │       └── error_widget.dart
│   │
│   ├── features/
│   │   │
│   │   ├── authentication/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository.dart
│   │   │   │
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       └── auth_service.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   └── signup_page.dart
│   │   │       │
│   │   │       ├── view_models/
│   │   │       │   └── auth_view_model.dart
│   │   │       │
│   │   │       └── widgets/
│   │   │           ├── auth_header.dart
│   │   │           ├── auth_text_field.dart
│   │   │           └── auth_button.dart
│   │   │
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── dashboard_page.dart
│   │   │       │
│   │   │       ├── view_models/
│   │   │       │   └── dashboard_view_model.dart
│   │   │       │
│   │   │       └── widgets/
│   │   │           ├── device_summary_card.dart
│   │   │           ├── battery_card.dart
│   │   │           ├── memory_card.dart
│   │   │           ├── storage_card.dart
│   │   │           └── quick_info_card.dart
│   │   │
│   │   ├── system_info/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── device_info.dart
│   │   │   │   │   ├── cpu_info.dart
│   │   │   │   │   ├── memory_info.dart
│   │   │   │   │   ├── storage_info.dart
│   │   │   │   │   └── battery_info.dart
│   │   │   │   │
│   │   │   │   └── repositories/
│   │   │   │       └── system_info_repository.dart
│   │   │   │
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── system_info_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       ├── device_info_service.dart
│   │   │   │       ├── battery_service.dart
│   │   │   │       ├── storage_service.dart
│   │   │   │       └── system_service.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── system_info_page.dart
│   │   │       │
│   │   │       ├── view_models/
│   │   │       │   └── system_info_view_model.dart
│   │   │       │
│   │   │       └── widgets/
│   │   │           ├── device_info_section.dart
│   │   │           ├── cpu_section.dart
│   │   │           ├── memory_section.dart
│   │   │           ├── storage_section.dart
│   │   │           ├── battery_section.dart
│   │   │           ├── display_section.dart
│   │   │           └── system_section.dart
│   │   │
│   │   └── profile/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── profile.dart
│   │       │   └── repositories/
│   │       │       └── profile_repository.dart
│   │       │
│   │       ├── data/
│   │       │   ├── repositories/
│   │       │   │   └── profile_repository_impl.dart
│   │       │   └── services/
│   │       │       └── profile_service.dart
│   │       │
│   │       └── presentation/
│   │           ├── pages/
│   │           │   └── profile_page.dart
│   │           │
│   │           ├── view_models/
│   │           │   └── profile_view_model.dart
│   │           │
│   │           └── widgets/
│   │               ├── profile_header.dart
│   │               ├── profile_info_section.dart
│   │               ├── theme_selector.dart
│   │               ├── settings_section.dart
│   │               └── logout_button.dart
│   │
│   └── services/
│       └── native/
│           ├── device_platform_service.dart
│           ├── battery_platform_service.dart
│           ├── storage_platform_service.dart
│           └── system_platform_service.dart
│
├── test/
│   ├── core/
│   └── features/
│       ├── authentication/
│       ├── dashboard/
│       ├── system_info/
│       └── profile/
│
├── integration_test/
│   ├── authentication_flow_test.dart
│   ├── dashboard_test.dart
│   ├── system_info_test.dart
│   └── profile_test.dart
│
├── docs/
│   ├── architecture.md
│   ├── native-integration.md
│   ├── packages.md
│   ├── testing.md
│   └── screenshots/
│
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
├── LICENSE
└── .gitignore
```

---

# 🔄 Flux de données

Les widgets Flutter ne doivent pas communiquer directement avec les APIs natives.

Le flux recommandé est :

```text
UI
 ↓
ViewModel
 ↓
Repository
 ↓
Service
 ↓
Package / Native API
 ↓
Android / iOS
```

Pour les informations système :

```text
┌──────────────┐
│ System Info  │
│     Page     │
└──────┬───────┘
       ↓
┌──────────────┐
│  ViewModel   │
└──────┬───────┘
       ↓
┌──────────────┐
│ Repository   │
└──────┬───────┘
       ↓
 ┌─────┴─────┐
 ↓           ↓
Package     Native
 ↓           ↓
 └─────┬─────┘
       ↓
 Android / iOS
```

---

# 🧭 Navigation

Les cinq interfaces principales sont organisées autour de deux espaces.

```text
                    DeviceSpecs
                        │
              ┌─────────┴─────────┐
              │                   │
         Authentication          App
              │                   │
        ┌─────┴─────┐       ┌─────┼─────┐
        │           │       │     │     │
      Login       Sign Up Dashboard System Profile
                              Info
```

## Routes

```text
/login
/signup

/dashboard
/system-info
/profile
```

Les routes protégées nécessitent une authentification.

---

# 🔌 Native Integration

L'intégration native est l'un des objectifs techniques principaux du projet.

## Android

Technologies :

* Kotlin ;
* Android SDK ;
* APIs système ;
* Platform Channels.

```text
Flutter
   │
   │ MethodChannel
   ▼
Kotlin
   │
   ▼
Android APIs
   │
   ▼
Device
```

## iOS

Technologies :

* Swift ;
* iOS SDK ;
* APIs système ;
* Platform Channels.

```text
Flutter
   │
   │ MethodChannel
   ▼
Swift
   │
   ▼
iOS APIs
   │
   ▼
Device
```

## Règle d'architecture

Les appels natifs ne doivent pas être effectués directement dans les widgets.

❌ À éviter :

```dart
onPressed: () {
  // Appel natif directement depuis l'UI
}
```

✅ Architecture souhaitée :

```text
Widget
   ↓
ViewModel
   ↓
Repository
   ↓
Native Service
   ↓
Platform Channel
   ↓
Kotlin / Swift
```

---

# 📦 Packages Open-Source

Les packages open-source seront utilisés lorsqu'ils permettent de résoudre proprement un besoin sans réimplémenter inutilement une fonctionnalité existante.

Packages susceptibles d'être utilisés :

| Package              | Utilisation                          |
| -------------------- | ------------------------------------ |
| `device_info_plus`   | Informations générales de l'appareil |
| `battery_plus`       | Informations sur la batterie         |
| `package_info_plus`  | Informations sur l'application       |
| `connectivity_plus`  | État de la connectivité              |
| `sensors_plus`       | Accès aux capteurs                   |
| `permission_handler` | Gestion des permissions              |
| `path_provider`      | Accès aux chemins système            |

Les dépendances définitives seront choisies après analyse de :

* compatibilité Android/iOS ;
* maintenance ;
* documentation ;
* performances ;
* licence ;
* couverture fonctionnelle.

---

# 🧠 Gestion de l'état

La logique d'état est séparée de l'interface.

Les ViewModels sont responsables de :

* charger les données ;
* exposer l'état ;
* gérer les états de chargement ;
* gérer les erreurs ;
* déclencher les actualisations ;
* communiquer avec les repositories.

Exemple :

```text
Page
 ↓
ViewModel
 ↓
Repository
```

La technologie de gestion d'état définitive sera choisie selon les besoins du projet.

---

# 🎨 Design System

L'interface doit utiliser un Design System centralisé.

## Couleurs

```text
AppColors
├── primary
├── secondary
├── background
├── surface
├── textPrimary
├── textSecondary
├── success
├── warning
└── error
```

## Typographie

```text
AppTypography
├── display
├── headline
├── title
├── body
├── label
└── caption
```

## Espacement

```text
AppSpacing
├── xs
├── sm
├── md
├── lg
├── xl
└── xxl
```

## Composants

Les composants réutilisables sont centralisés dans :

```text
core/widgets/
```

Exemples :

* `AppButton`
* `AppTextField`
* `AppCard`
* `LoadingWidget`
* `ErrorWidget`

---

# ✨ Animations

Les animations constituent la fonctionnalité bonus du projet.

Elles doivent améliorer l'expérience utilisateur sans surcharger l'interface.

Animations prévues :

* apparition progressive des cartes ;
* transitions de pages ;
* animation des valeurs ;
* progression RAM ;
* progression stockage ;
* animation batterie ;
* micro-interactions ;
* états de chargement.

Principe :

> **Les animations doivent communiquer quelque chose ou améliorer le feedback utilisateur.**

Elles ne doivent pas être ajoutées uniquement à des fins décoratives.

---

# ⚠️ Gestion des erreurs

Les informations système ne sont pas toujours disponibles.

Une donnée peut être :

* indisponible ;
* non supportée ;
* restreinte ;
* dépendante de la version Android/iOS ;
* dépendante du constructeur ;
* dépendante des permissions.

L'application doit donc éviter d'afficher des valeurs inventées.

Exemples :

```text
Unavailable
Not supported
Restricted
Unknown
```

---

# 🧪 Tests

Le projet prévoit trois niveaux de tests.

## Unit Tests

Tester :

* repositories ;
* services ;
* ViewModels ;
* modèles ;
* mappers ;
* utilitaires.

Structure :

```text
test/
└── features/
    ├── authentication/
    ├── dashboard/
    ├── system_info/
    └── profile/
```

## Widget Tests

Tester :

* rendu des pages ;
* formulaires ;
* interactions ;
* états de chargement ;
* erreurs ;
* changement de thème.

## Integration Tests

Tester les parcours utilisateur complets.

### Authentication

```text
Sign Up
   ↓
Login
   ↓
Dashboard
```

### Application

```text
Dashboard
   ↓
System Info
   ↓
Profile
   ↓
Theme / Settings
```

---

# 🧹 Qualité du code

Avant chaque Pull Request, les vérifications suivantes doivent être effectuées.

## Analyse

```bash
flutter analyze
```

## Formatage

```bash
dart format .
```

## Tests

```bash
flutter test
```

## Tests d'intégration

```bash
flutter test integration_test
```

Le projet doit privilégier :

* des classes courtes ;
* des responsabilités clairement séparées ;
* des widgets réutilisables ;
* des noms explicites ;
* une faible duplication ;
* une architecture testable ;
* l'absence de logique métier dans les widgets.

---

# 📱 Compatibilité

## Android

Les données disponibles peuvent varier selon :

* version Android ;
* constructeur ;
* modèle ;
* permissions ;
* APIs système.

## iOS

iOS impose également certaines restrictions concernant l'accès aux informations système.

DeviceSpecs utilise uniquement les informations accessibles via les APIs publiques et les mécanismes autorisés.

---

# 🚀 Installation

## Prérequis

Installer :

* Flutter ;
* Dart ;
* Android Studio ;
* Android SDK ;
* Xcode pour iOS ;
* Git.

Vérifier l'environnement :

```bash
flutter doctor
```

---

## Cloner le projet

```bash
git clone <repository-url>
```

Puis :

```bash
cd devicespecs
```

---

## Installer les dépendances

```bash
flutter pub get
```

---

## Lancer l'application

```bash
flutter run
```

---

# ⚙️ Configuration

Les configurations générales de l'application sont centralisées dans :

```text
lib/app/
```

Les paramètres spécifiques sont organisés notamment dans :

```text
lib/app/config/
```

Aucune donnée sensible ne doit être commitée dans le repository.

---

# 🌿 Convention Git

Branches principales :

```text
main
└── develop
```

Branches de fonctionnalités :

```text
feature/...
```

Exemples :

```text
feature/login
feature/signup
feature/dashboard
feature/system-info
feature/profile
feature/native-android
feature/native-ios
```

Corrections :

```text
fix/...
```

Exemples :

```text
fix/battery-value
fix/login-validation
```

Refactoring :

```text
refactor/...
```

---

# 📝 Convention des commits

Le projet utilise une convention inspirée de Conventional Commits.

```text
feat: add login page
feat: add system information
feat: add dark mode

fix: correct battery percentage
fix: handle unavailable device information

refactor: improve system repository

test: add login tests

docs: update architecture documentation

style: format dashboard widgets

chore: update dependencies
```

---

# 🗺️ Roadmap

## Phase 1 — Architecture

* [ ] Création du projet
* [ ] Mise en place de Feature-first
* [ ] Configuration du routing
* [ ] Configuration du thème
* [ ] Configuration de la gestion d'état
* [ ] Dependency Injection

## Phase 2 — Authentication

* [ ] Sign Up
* [ ] Login
* [ ] Validation des formulaires
* [ ] Gestion des erreurs
* [ ] Session utilisateur

## Phase 3 — Dashboard

* [ ] Device Summary
* [ ] Battery Card
* [ ] Memory Card
* [ ] Storage Card
* [ ] CPU Card
* [ ] Navigation

## Phase 4 — System Info

* [ ] Device Information
* [ ] CPU
* [ ] GPU
* [ ] RAM
* [ ] Storage
* [ ] Battery
* [ ] Display
* [ ] Network
* [ ] Sensors

## Phase 5 — Profile

* [ ] Informations utilisateur
* [ ] Avatar
* [ ] Dark Mode
* [ ] Light Mode
* [ ] System Theme
* [ ] Settings
* [ ] Logout

## Phase 6 — Native Integration

* [ ] Android
* [ ] Kotlin
* [ ] iOS
* [ ] Swift
* [ ] Platform Channels
* [ ] Gestion des différences entre plateformes

## Phase 7 — UI/UX

* [ ] Design System
* [ ] Responsive UI
* [ ] Animations
* [ ] Micro-interactions
* [ ] Loading states
* [ ] Error states

## Phase 8 — Qualité

* [ ] Unit Tests
* [ ] Widget Tests
* [ ] Integration Tests
* [ ] Static Analysis
* [ ] Performance
* [ ] Documentation

---

# ⚠️ Limitations

Les informations disponibles peuvent varier selon l'appareil.

Certaines fonctionnalités peuvent être différentes entre Android et iOS.

DeviceSpecs ne garantit donc pas que toutes les informations seront disponibles sur tous les appareils.

Lorsqu'une information n'est pas accessible, l'application doit clairement l'indiquer.

---

# 🤝 Contribution

Les contributions sont les bienvenues.

## Processus

Créer une branche :

```bash
git checkout -b feature/my-feature
```

Développer la fonctionnalité puis vérifier :

```bash
flutter analyze
```

```bash
dart format .
```

```bash
flutter test
```

Créer le commit :

```bash
git commit -m "feat: add my feature"
```

Puis pousser la branche :

```bash
git push origin feature/my-feature
```

Enfin, ouvrir une Pull Request vers `develop`.

---

# 📚 Documentation technique

La documentation détaillée se trouve dans :

```text
docs/
├── architecture.md
├── native-integration.md
├── packages.md
├── testing.md
└── screenshots/
```

### `architecture.md`

Documente :

* architecture globale ;
* responsabilités des couches ;
* Feature-first ;
* MVVM ;
* Repository Pattern ;
* flux de données.

### `native-integration.md`

Documente :

* Android ;
* Kotlin ;
* iOS ;
* Swift ;
* Platform Channels ;
* APIs natives.

### `packages.md`

Documente :

* packages utilisés ;
* raisons du choix ;
* alternatives ;
* compatibilité ;
* licences.

### `testing.md`

Documente :

* stratégie de tests ;
* unit tests ;
* widget tests ;
* integration tests.

---

# 🧠 Principes architecturaux

DeviceSpecs suit plusieurs principes fondamentaux.

### Separation of Concerns

Chaque couche possède une responsabilité clairement définie.

### Single Responsibility

Une classe ou un composant doit avoir une responsabilité principale.

### Dependency Inversion

Les couches métier dépendent d'abstractions plutôt que d'implémentations concrètes.

### Reusability

Les composants communs doivent être réutilisables.

### Testability

La logique doit pouvoir être testée indépendamment de l'interface.

### Platform Isolation

Les différences Android/iOS doivent être isolées dans les services appropriés.

---

# 🏆 Vision du projet

DeviceSpecs doit démontrer la capacité de l'équipe à construire une véritable application mobile Flutter structurée.

```text
                       DEVICESPECS
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
    Authentication       Main App          Native
          │                 │                 │
     ┌────┴────┐      ┌─────┼─────┐      ┌───┴───┐
     │         │      │     │     │      │       │
   Sign Up   Login Dashboard System Profile Android iOS
                         Info
                            │
                            ▼
                    Device Information
                            │
                   ┌────────┴────────┐
                   │                 │
                Packages           Native
                   │                 │
                   └────────┬────────┘
                            ▼
                       Device APIs
```

L'objectif final est de produire une application :

**📱 Cross-platform**
**🧱 Maintenable**
**🧠 Bien architecturée**
**🔌 Native-aware**
**📦 Open-source friendly**
**🎨 Moderne**
**✨ Animée**
**🧪 Testable**
**📚 Documentée**

---

# 📄 Licence

Ce projet est distribué sous licence :

```text
MIT License
```

Voir le fichier :

```text
LICENSE
```

---

# 👨‍💻 Auteur

**DeviceSpecs Team**

Projet développé avec :

```text
Flutter
Dart
Kotlin
Swift
Git
GitHub
```

---

# ⭐ DeviceSpecs

> **Understand your device.**
>
> *Inspect. Understand. Explore.*
