import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'obd_button.dart';

/// État vide OBD
class OBDEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const OBDEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  /// État vide pour liste d'athlètes
  factory OBDEmptyState.athletes({VoidCallback? onAdd}) => OBDEmptyState(
        icon: Icons.people_outline,
        title: 'Aucun athlète',
        message: 'Commencez par ajouter votre premier athlète',
        actionLabel: 'Ajouter un athlète',
        onAction: onAdd,
      );

  /// État vide pour recherche
  factory OBDEmptyState.search() => const OBDEmptyState(
        icon: Icons.search_off,
        title: 'Aucun résultat',
        message: 'Essayez avec d\'autres termes de recherche',
      );

  /// État vide pour paiements
  factory OBDEmptyState.paiements() => const OBDEmptyState(
        icon: Icons.payment,
        title: 'Aucun paiement',
        message: 'Les paiements apparaîtront ici',
      );

  /// État vide pour présences
  factory OBDEmptyState.presences() => const OBDEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Aucune présence',
        message: 'Les présences enregistrées apparaîtront ici',
      );

  /// État vide pour performances
  factory OBDEmptyState.performances() => const OBDEmptyState(
        icon: Icons.trending_up,
        title: 'Aucune performance',
        message: 'Les évaluations apparaîtront ici',
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.grey300,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textHint,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              OBDPrimaryButton(
                text: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// État d'erreur OBD
class OBDErrorState extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;

  const OBDErrorState({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
  });

  /// Erreur réseau
  factory OBDErrorState.network({VoidCallback? onRetry}) => OBDErrorState(
        title: 'Pas de connexion',
        message: 'Vérifiez votre connexion internet et réessayez',
        onRetry: onRetry,
      );

  /// Erreur serveur
  factory OBDErrorState.server({VoidCallback? onRetry}) => OBDErrorState(
        title: 'Erreur serveur',
        message: 'Une erreur est survenue. Veuillez réessayer plus tard.',
        onRetry: onRetry,
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.error,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OBDOutlinedButton(
                text: 'Réessayer',
                icon: Icons.refresh,
                onPressed: onRetry,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
