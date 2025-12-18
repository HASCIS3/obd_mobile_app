import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// AppBar personnalisée OBD
class OBDAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const OBDAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

/// AppBar transparente pour les pages avec fond personnalisé
class OBDTransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Color foregroundColor;

  const OBDTransparentAppBar({
    super.key,
    this.title,
    this.actions,
    this.foregroundColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: foregroundColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
