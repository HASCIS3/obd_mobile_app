import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'obd_button.dart';

/// Dialog de confirmation OBD
class OBDConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDanger;

  const OBDConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmer',
    this.cancelLabel = 'Annuler',
    this.confirmColor,
    this.icon,
    this.isDanger = false,
  });

  /// Dialog de suppression
  factory OBDConfirmDialog.delete({
    required String itemName,
  }) =>
      OBDConfirmDialog(
        title: 'Supprimer',
        message: 'Voulez-vous vraiment supprimer "$itemName" ?',
        confirmLabel: 'Supprimer',
        icon: Icons.delete_outline,
        isDanger: true,
      );

  /// Dialog de déconnexion
  factory OBDConfirmDialog.logout() => const OBDConfirmDialog(
        title: 'Déconnexion',
        message: 'Voulez-vous vraiment vous déconnecter ?',
        confirmLabel: 'Déconnexion',
        icon: Icons.logout,
        isDanger: true,
      );

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirmer',
    String cancelLabel = 'Annuler',
    Color? confirmColor,
    IconData? icon,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => OBDConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        icon: icon,
        isDanger: isDanger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = confirmColor ?? (isDanger ? AppColors.error : AppColors.primary);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: buttonColor),
            const SizedBox(width: 12),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: buttonColor),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

/// Dialog d'information OBD
class OBDInfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;

  const OBDInfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => OBDInfoDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? AppColors.primary),
            const SizedBox(width: 12),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

/// Bottom sheet OBD
class OBDBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showHandle;
  final EdgeInsetsGeometry? padding;

  const OBDBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showHandle = true,
    this.padding,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    bool showHandle = true,
    bool isScrollControlled = true,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusL),
        ),
      ),
      builder: (context) => OBDBottomSheet(
        title: title,
        showHandle: showHandle,
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showHandle) ...[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Snackbar OBD
class OBDSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
      ),
    );
  }

  static void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
      ),
    );
  }

  static void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
      ),
    );
  }

  static void warning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
      ),
    );
  }
}
