import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Bouton primaire OBD
class OBDPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;

  const OBDPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        minimumSize: Size(
          isFullWidth ? double.infinity : 0,
          AppSizes.buttonHeightM,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                    Text(text),
                  ],
                )
              : Text(text),
    );

    return button;
  }
}

/// Bouton secondaire (outlined) OBD
class OBDOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? color;

  const OBDOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primary;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        side: BorderSide(color: buttonColor),
        minimumSize: Size(
          isFullWidth ? double.infinity : 0,
          AppSizes.buttonHeightM,
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
              ),
            )
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                    Text(text),
                  ],
                )
              : Text(text),
    );
  }
}

/// Bouton texte OBD
class OBDTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const OBDTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.primary,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 4),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}

/// Bouton d'action flottant OBD
class OBDFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final Color? backgroundColor;

  const OBDFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? AppColors.primary,
        icon: Icon(icon),
        label: Text(label!),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      child: Icon(icon),
    );
  }
}
