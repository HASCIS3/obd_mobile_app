import 'package:flutter/material.dart';

/// Tailles et espacements de l'application OBD Mobile
class AppSizes {
  AppSizes._();

  // Padding & Margin
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Button Heights
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // Input Heights
  static const double inputHeight = 56.0;
  static const double inputHeightS = 48.0;

  // Avatar Sizes
  static const double avatarXS = 24.0;
  static const double avatarS = 32.0;
  static const double avatarM = 48.0;
  static const double avatarL = 64.0;
  static const double avatarXL = 96.0;
  static const double avatarXXL = 128.0;

  // Card
  static const double cardElevation = 2.0;
  static const double cardRadius = radiusM;

  // Bottom Navigation
  static const double bottomNavHeight = 64.0;

  // App Bar
  static const double appBarHeight = 56.0;

  // Divider
  static const double dividerThickness = 1.0;

  // Border Width
  static const double borderWidth = 1.0;
  static const double borderWidthThick = 2.0;

  // Spacing helpers
  static const SizedBox verticalSpaceXS = SizedBox(height: paddingXS);
  static const SizedBox verticalSpaceS = SizedBox(height: paddingS);
  static const SizedBox verticalSpaceM = SizedBox(height: paddingM);
  static const SizedBox verticalSpaceL = SizedBox(height: paddingL);
  static const SizedBox verticalSpaceXL = SizedBox(height: paddingXL);

  static const SizedBox horizontalSpaceXS = SizedBox(width: paddingXS);
  static const SizedBox horizontalSpaceS = SizedBox(width: paddingS);
  static const SizedBox horizontalSpaceM = SizedBox(width: paddingM);
  static const SizedBox horizontalSpaceL = SizedBox(width: paddingL);
  static const SizedBox horizontalSpaceXL = SizedBox(width: paddingXL);

  // Screen breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}
