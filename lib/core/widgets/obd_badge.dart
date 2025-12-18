import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Badge de statut OBD
class OBDStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool outlined;

  const OBDStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.outlined = false,
  });

  /// Badge "Actif"
  factory OBDStatusBadge.active() => const OBDStatusBadge(
        label: 'Actif',
        color: AppColors.success,
      );

  /// Badge "Inactif"
  factory OBDStatusBadge.inactive() => const OBDStatusBadge(
        label: 'Inactif',
        color: AppColors.grey500,
      );

  /// Badge "Payé"
  factory OBDStatusBadge.paye() => const OBDStatusBadge(
        label: 'Payé',
        color: AppColors.success,
        icon: Icons.check_circle,
      );

  /// Badge "Impayé"
  factory OBDStatusBadge.impaye() => const OBDStatusBadge(
        label: 'Impayé',
        color: AppColors.error,
        icon: Icons.cancel,
      );

  /// Badge "Partiel"
  factory OBDStatusBadge.partiel() => const OBDStatusBadge(
        label: 'Partiel',
        color: AppColors.warning,
        icon: Icons.timelapse,
      );

  /// Badge "Présent"
  factory OBDStatusBadge.present() => const OBDStatusBadge(
        label: 'Présent',
        color: AppColors.success,
      );

  /// Badge "Absent"
  factory OBDStatusBadge.absent() => const OBDStatusBadge(
        label: 'Absent',
        color: AppColors.error,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: outlined ? Border.all(color: color) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge de catégorie d'âge
class OBDCategoryBadge extends StatelessWidget {
  final String category;

  const OBDCategoryBadge({
    super.key,
    required this.category,
  });

  Color get _color {
    switch (category.toLowerCase()) {
      case 'poussin':
        return Colors.purple;
      case 'benjamin':
        return Colors.blue;
      case 'minime':
        return Colors.teal;
      case 'cadet':
        return Colors.orange;
      case 'junior':
        return Colors.deepOrange;
      case 'senior':
        return Colors.red;
      default:
        return AppColors.grey500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Badge de discipline
class OBDDisciplineBadge extends StatelessWidget {
  final String discipline;
  final Color? color;

  const OBDDisciplineBadge({
    super.key,
    required this.discipline,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports, size: 12, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            discipline,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge de notification
class OBDNotificationBadge extends StatelessWidget {
  final int count;
  final Color? color;

  const OBDNotificationBadge({
    super.key,
    required this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 18),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
