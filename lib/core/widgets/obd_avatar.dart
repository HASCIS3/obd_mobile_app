import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Avatar OBD avec initiales ou image
class OBDAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;

  const OBDAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.name,
    this.size = AppSizes.avatarM,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
  });

  String get _initials {
    if (initials != null) return initials!;
    if (name != null && name!.isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size / 2,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => _buildInitialsAvatar(),
        errorWidget: (context, url, error) => _buildInitialsAvatar(),
      );
    } else {
      avatar = _buildInitialsAvatar();
    }

    if (showBorder) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? AppColors.primary,
            width: 2,
          ),
        ),
        child: avatar,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildInitialsAvatar() {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? AppColors.primary.withOpacity(0.1),
      child: Text(
        _initials,
        style: TextStyle(
          color: foregroundColor ?? AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.35,
        ),
      ),
    );
  }
}

/// Avatar avec badge de statut
class OBDAvatarWithStatus extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool isOnline;
  final Color? statusColor;

  const OBDAvatarWithStatus({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppSizes.avatarM,
    this.isOnline = false,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OBDAvatar(
          imageUrl: imageUrl,
          name: name,
          size: size,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: statusColor ?? (isOnline ? AppColors.success : AppColors.grey400),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Groupe d'avatars empilés
class OBDAvatarGroup extends StatelessWidget {
  final List<String?> names;
  final List<String?> imageUrls;
  final double size;
  final int maxDisplay;
  final VoidCallback? onTap;

  const OBDAvatarGroup({
    super.key,
    required this.names,
    this.imageUrls = const [],
    this.size = AppSizes.avatarS,
    this.maxDisplay = 3,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = names.length > maxDisplay ? maxDisplay : names.length;
    final remaining = names.length - maxDisplay;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + (displayCount - 1) * (size * 0.6) + (remaining > 0 ? size * 0.6 : 0),
        height: size,
        child: Stack(
          children: [
            for (int i = 0; i < displayCount; i++)
              Positioned(
                left: i * (size * 0.6),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: OBDAvatar(
                    name: names[i],
                    imageUrl: i < imageUrls.length ? imageUrls[i] : null,
                    size: size,
                  ),
                ),
              ),
            if (remaining > 0)
              Positioned(
                left: displayCount * (size * 0.6),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: size / 2,
                    backgroundColor: AppColors.grey300,
                    child: Text(
                      '+$remaining',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: size * 0.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
