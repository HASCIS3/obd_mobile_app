import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// Widget Logo OBD
class OBDLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool useWhiteText;

  const OBDLogo({
    super.key,
    this.size = 120,
    this.showText = true,
    this.useWhiteText = false,
  });

  /// Logo petit format
  factory OBDLogo.small() => const OBDLogo(size: 48, showText: false);

  /// Logo moyen format
  factory OBDLogo.medium() => const OBDLogo(size: 80, showText: false);

  /// Logo grand format avec texte
  factory OBDLogo.large() => const OBDLogo(size: 120, showText: true);

  /// Logo pour splash screen
  factory OBDLogo.splash() => const OBDLogo(size: 150, showText: true, useWhiteText: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo image
        ClipOval(
          child: Image.asset(
            AppAssets.logo,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback si l'image n'est pas trouvée
              return _buildFallbackLogo();
            },
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: size * 0.15,
              fontWeight: FontWeight.bold,
              color: useWhiteText ? Colors.white : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.appTagline,
            style: TextStyle(
              fontSize: size * 0.09,
              color: useWhiteText ? Colors.white70 : AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(
          color: AppColors.primaryYellow,
          width: size * 0.05,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sports,
              size: size * 0.4,
              color: Colors.white,
            ),
            Text(
              'OBD',
              style: TextStyle(
                fontSize: size * 0.15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Logo circulaire avec bordure Mali
class OBDLogoCircle extends StatelessWidget {
  final double size;

  const OBDLogoCircle({
    super.key,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGreen,
          width: size * 0.04,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          AppAssets.logo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.white,
              child: Icon(
                Icons.sports,
                size: size * 0.5,
                color: AppColors.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}
