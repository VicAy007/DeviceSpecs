# DeviceSpecs — Page Dashboard (Flutter / Dart)

Module pour l'onglet **Dashboard** de DeviceSpecs (Groupe 20), thème noir
& blanc, fidèle à `dashboard_system_health_dark_minimal.html`, et **conforme
à l'architecture Feature-first / Domain-Data-Presentation décrite dans le
README du dépôt `VicAy007/device_specs`**.

## ⚠️ Branche cible : `develop`, pas `main`

Le dépôt du groupe utilise `develop` comme branche par défaut et cible de
Pull Request (voir la section "Convention Git" / "Contribution" du README
du projet). Toutes les commandes Git doivent partir de `develop`, jamais
de `main`.

## Contenu du zip (à fusionner dans le dépôt, pas à remplacer)

```
lib/
  app/
    theme/
      app_colors.dart        # AppColors — palette noir & blanc
      app_typography.dart    # AppTypography — styles de texte
      app_spacing.dart       # AppSpacing — échelle d'espacement
  core/
    widgets/
      gauge_ring_card.dart   # Jauge circulaire réutilisable (Batterie/RAM)
  features/
    dashboard/
      domain/
        entities/
          device_health.dart          # Entité DeviceHealth (+ ChartPoint)
        repositories/
          dashboard_repository.dart   # Contrat abstrait
      data/
        repositories/
          dashboard_repository_impl.dart  # Implémentation mock
      presentation/
        pages/
          dashboard_page.dart          # Page finale à afficher
        view_models/
          dashboard_view_model.dart    # ChangeNotifier (état loading/loaded/error)
        widgets/
          dashboard_header.dart
          device_summary_card.dart
          battery_card.dart
          memory_card.dart
          storage_card.dart
          cpu_frequency_card.dart
          wifi_card.dart
          quick_actions_card.dart      # "Diagnostic Control" du mock
          dashboard_bottom_nav.dart    # voir note ci-dessous
```

**Aucune nouvelle dépendance pub** n'est nécessaire (pas de `provider`, pas
de `google_fonts`) : la police "data" du mock est simulée avec la police
monospace système, et l'état est géré avec `ChangeNotifier`, déjà inclus
dans Flutter. Cela évite tout conflit avec le `pubspec.yaml` partagé tant
que l'équipe n'a pas figé sa solution de state management.

## Comment fusionner sans écraser le travail des autres

1. Si `lib/app/theme/` existe déjà (créé par un coéquipier, ex. pour
   `light_theme.dart` / `dark_theme.dart`), **ne pas écraser** : ajouter
   seulement les fichiers `app_colors.dart` / `app_typography.dart` /
   `app_spacing.dart` s'ils manquent, ou fusionner les valeurs à la main.
2. Copier tel quel `lib/core/widgets/gauge_ring_card.dart` et tout le
   dossier `lib/features/dashboard/`.
3. Dans le router de l'app (`lib/app/router/app_router.dart` selon
   l'architecture cible du README), ajouter la route `/dashboard` vers :
   ```dart
   import 'features/dashboard/presentation/pages/dashboard_page.dart';
   // ...
   const DashboardPage(),
   ```
4. Ne pas modifier les fichiers des autres features (`authentication`,
   `system_info`, `profile`).

⚠️ **Point à valider avec l'équipe** : `dashboard_bottom_nav.dart`
reproduit la barre de navigation du mock (Dashboard/Specs/Profile) à
l'identique, mais cette barre est censée être unique dans toute l'app
(voir "Navigation" dans le README). Ne l'intégrez que si personne d'autre
n'a déjà créé la sienne — sinon, donnez juste `DashboardPage` (sans son
`bottomNavigationBar`) au shell de navigation commun.

## Brancher les vraies données système

Toutes les valeurs viennent de `MockDashboardRepository` (couche Data).
Pour brancher les platform channels natifs (Kotlin/Swift, voir
`lib/services/native/` dans l'architecture cible), il suffit de créer une
nouvelle implémentation de `DashboardRepository` et de l'injecter dans
`DashboardViewModel(repository: ...)` — aucun widget n'a besoin de changer.

## Workflow Git en équipe

Principe : **une branche par fonctionnalité + Pull Request vers `develop`**,
jamais de push direct sur `develop` ou `main`. Le nommage suit la
convention du projet : `feature/dashboard-page`.

Étapes générales (détail des commandes donné pas à pas dans la
conversation) :
1. Se mettre à jour depuis `develop`.
2. Créer la branche `feature/dashboard-page`.
3. Ajouter les fichiers de ce zip dans le dépôt.
4. Lancer `flutter analyze` et `dart format .` si le SDK Flutter est
   disponible (sinon laisser la CI GitHub Actions le faire).
5. Commit (convention `feat: ...`) + push de la branche.
6. Ouvrir une Pull Request vers `develop`.
7. Laisser la CI valider avant de merger.
