import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../bloc/dashboard_bloc.dart';

/// Page Dashboard
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(const DashboardLoadRequested()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notifications
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Erreur de chargement'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(const DashboardLoadRequested());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final data = state.data;
          if (data == null) {
            return const Center(child: Text('Aucune donnée'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(const DashboardRefreshRequested());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Salutation
                  Text(
                    'Bonjour, ${data.user.name} !',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    _getFormattedDate(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Athlètes',
                          value: '${data.stats.athletesActifs}',
                          subtitle: 'actifs',
                          icon: Icons.people,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Présents',
                          value: '${data.stats.presencesJour}',
                          subtitle: 'aujourd\'hui',
                          icon: Icons.check_circle,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Arriérés',
                          value: '${data.stats.paiements.arrieres}',
                          subtitle: 'impayés',
                          icon: Icons.warning,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Revenus du mois
                  _RevenusCard(paiements: data.stats.paiements),

                  const SizedBox(height: 24),

                  // Actions rapides
                  Text(
                    'Actions rapides',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.check_circle_outline,
                          label: 'Pointage',
                          color: AppColors.primary,
                          onTap: () => context.go(RouteNames.presences),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.payment,
                          label: 'Paiement',
                          color: AppColors.secondary,
                          onTap: () => context.go(RouteNames.paiements),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.person_add,
                          label: 'Athlète',
                          color: AppColors.accent,
                          onTap: () => context.go(RouteNames.athletes),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Dernières activités
                  Text(
                    'Dernières activités',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _ActivitiesCard(activities: data.activitesRecentes),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

class _RevenusCard extends StatelessWidget {
  final PaiementStats paiements;

  const _RevenusCard({required this.paiements});

  @override
  Widget build(BuildContext context) {
    final pourcentage = paiements.pourcentagePaye / 100;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenus du mois',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pourcentage.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: AppColors.grey200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${paiements.pourcentagePaye.toStringAsFixed(0)}%',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatMoney(paiements.paye)} / ${_formatMoney(paiements.total)} FCFA',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}

class _ActivitiesCard extends StatelessWidget {
  final List<ActivityModel> activities;

  const _ActivitiesCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Center(
            child: Text(
              'Aucune activité récente',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLast = index == activities.length - 1;

          return Column(
            children: [
              _ActivityItem(
                icon: activity.present == true ? Icons.check_circle : Icons.cancel,
                iconColor: activity.present == true ? AppColors.success : AppColors.error,
                title: activity.athlete ?? 'Activité',
                subtitle: activity.discipline ?? '',
                time: _formatTime(activity.date),
              ),
              if (!isLast) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours}h';
    } else if (diff.inDays == 1) {
      return 'Hier';
    } else {
      return 'Il y a ${diff.inDays} jours';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
