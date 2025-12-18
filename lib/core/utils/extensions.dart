import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extensions sur DateTime
extension DateTimeExtension on DateTime {
  /// Formate la date en français
  String toFrenchDate() {
    return DateFormat('dd/MM/yyyy', 'fr_FR').format(this);
  }

  /// Formate la date avec le jour
  String toFrenchDateWithDay() {
    return DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(this);
  }

  /// Formate la date courte
  String toShortDate() {
    return DateFormat('dd/MM/yy').format(this);
  }

  /// Formate l'heure
  String toTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Formate date et heure
  String toDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Vérifie si c'est aujourd'hui
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Vérifie si c'est hier
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Retourne le nom du mois en français
  String get monthName {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }
}

/// Extensions sur String
extension StringExtension on String {
  /// Capitalise la première lettre
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalise chaque mot
  String capitalizeWords() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Vérifie si c'est un email valide
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Vérifie si c'est un numéro de téléphone valide (Mali)
  bool get isValidPhone {
    return RegExp(r'^(\+223)?[0-9]{8}$').hasMatch(replaceAll(' ', ''));
  }
}

/// Extensions sur double
extension DoubleExtension on double {
  /// Formate en FCFA
  String toFCFA() {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return '${formatter.format(this)} FCFA';
  }

  /// Formate en pourcentage
  String toPercent({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }
}

/// Extensions sur int
extension IntExtension on int {
  /// Formate en FCFA
  String toFCFA() {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return '${formatter.format(this)} FCFA';
  }
}

/// Extensions sur BuildContext
extension ContextExtension on BuildContext {
  /// Accès rapide au thème
  ThemeData get theme => Theme.of(this);

  /// Accès rapide au text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Accès rapide au color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Accès rapide à la taille de l'écran
  Size get screenSize => MediaQuery.of(this).size;

  /// Largeur de l'écran
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Hauteur de l'écran
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Padding système (safe area)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Vérifie si c'est un mobile
  bool get isMobile => screenWidth < 600;

  /// Vérifie si c'est une tablette
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Affiche un snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }

  /// Affiche un snackbar de succès
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Affiche un snackbar d'erreur
  void showErrorSnackBar(String message) {
    showSnackBar(message, isError: true);
  }
}
