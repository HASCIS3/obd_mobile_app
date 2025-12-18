import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';

/// Page profil utilisateur
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Données de démonstration
    final user = {
      'name': 'Admin OBD',
      'email': 'admin@obd.ml',
      'role': 'admin',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            // En-tête profil
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          (user['name'] as String).substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user['name'] as String,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['email'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      (user['role'] as String).toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Menu options
            Card(
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.person_outline,
                    title: 'Modifier le profil',
                    onTap: () {
                      // TODO: Navigation vers édition profil
                    },
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.lock_outline,
                    title: 'Changer le mot de passe',
                    onTap: () {
                      // TODO: Navigation vers changement mot de passe
                    },
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Toggle notifications
                      },
                      activeColor: AppColors.primary,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Autres options
            Card(
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.help_outline,
                    title: 'Aide',
                    onTap: () {
                      // TODO: Aide
                    },
                  ),
                  const Divider(height: 1),
                  _MenuTile(
                    icon: Icons.info_outline,
                    title: 'À propos',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: AppStrings.appName,
                        applicationVersion: '1.0.0',
                        applicationLegalese: '© 2025 OBD Mali',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bouton déconnexion
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text(AppStrings.logout),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Version
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 24),

            // Drapeau Mali
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 24, height: 16, color: AppColors.primaryGreen),
                Container(width: 24, height: 16, color: AppColors.primaryYellow),
                Container(width: 24, height: 16, color: AppColors.primaryRed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implémenter la déconnexion avec Bloc
              context.go(RouteNames.login);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}
