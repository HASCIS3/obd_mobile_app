import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Indicateur de chargement OBD
class OBDLoading extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const OBDLoading({
    super.key,
    this.size = 40,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Écran de chargement plein écran
class OBDLoadingScreen extends StatelessWidget {
  final String? message;

  const OBDLoadingScreen({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OBDLoading(message: message),
    );
  }
}

/// Shimmer pour liste de cartes
class OBDShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const OBDShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
      ),
    );
  }
}

/// Shimmer pour carte unique
class OBDShimmerCard extends StatelessWidget {
  final double height;
  final double? width;

  const OBDShimmerCard({
    super.key,
    this.height = 100,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      ),
    );
  }
}

/// Shimmer pour avatar
class OBDShimmerAvatar extends StatelessWidget {
  final double size;

  const OBDShimmerAvatar({
    super.key,
    this.size = AppSizes.avatarM,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.white,
      ),
    );
  }
}

/// Shimmer pour texte
class OBDShimmerText extends StatelessWidget {
  final double width;
  final double height;

  const OBDShimmerText({
    super.key,
    this.width = 100,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
