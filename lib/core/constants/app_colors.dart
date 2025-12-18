import 'package:flutter/material.dart';

/// Couleurs de l'application OBD Mobile
/// Basées sur le drapeau du Mali (Vert, Jaune, Rouge)
class AppColors {
  AppColors._();

  // Couleurs principales (Drapeau Mali)
  static const Color primaryGreen = Color(0xFF14B53A);
  static const Color primaryYellow = Color(0xFFFCD116);
  static const Color primaryRed = Color(0xFFCE1126);

  // Couleurs primaires de l'app
  static const Color primary = primaryGreen;
  static const Color primaryLight = Color(0xFF4CD964);
  static const Color primaryDark = Color(0xFF0D8A2B);

  // Couleurs secondaires
  static const Color secondary = primaryYellow;
  static const Color secondaryLight = Color(0xFFFFE066);
  static const Color secondaryDark = Color(0xFFD4A800);

  // Couleurs d'accent
  static const Color accent = primaryRed;
  static const Color accentLight = Color(0xFFFF4D4D);
  static const Color accentDark = Color(0xFFA30D1C);

  // Couleurs de fond
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF212121);

  // Couleurs sémantiques
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Couleurs de statut paiement
  static const Color statusPaye = success;
  static const Color statusImpaye = error;
  static const Color statusPartiel = warning;

  // Couleurs de présence
  static const Color present = success;
  static const Color absent = error;

  // Couleurs neutres
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Couleurs de bordure
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Couleurs de divider
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Ombres
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
}
