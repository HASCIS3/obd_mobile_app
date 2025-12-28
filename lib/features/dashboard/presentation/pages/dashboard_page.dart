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
                          onTap: () => context.push('${RouteNames.paiements}/${RouteNames.paiementCreate}'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.person_add,
                          label: 'Athlète',
                          color: AppColors.accent,
                          onTap: () => context.push('${RouteNames.athletes}/${RouteNames.athleteCreate}'),
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
    final hasData = paiements.total > 0;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.primary.withOpacity(0.03)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.account_balance_wallet, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Revenus du mois',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPercentageColor(paiements.pourcentagePaye).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${paiements.pourcentagePaye.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getPercentageColor(paiements.pourcentagePaye),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Barre de progression
            Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: pourcentage.clamp(0.0, 1.0),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Montants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Encaissé',
                      style: TextStyle(fontSize: 11, color: AppColors.grey600),
                    ),
                    Text(
                      '${_formatMoney(paiements.paye)} FCFA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Arriérés',
                      style: TextStyle(fontSize: 11, color: AppColors.grey600),
                    ),
                    Text(
                      '${_formatMoney(paiements.arrieres)} FCFA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Attendu',
                      style: TextStyle(fontSize: 11, color: AppColors.grey600),
                    ),
                    Text(
                      '${_formatMoney(paiements.total)} FCFA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (!hasData) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Aucun paiement enregistré ce mois',
                        style: TextStyle(fontSize: 12, color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 50) return AppColors.warning;
    return AppColors.error;
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}

class _ActivitiesCard extends StatefulWidget {
  final List<ActivityModel> activities;

  const _ActivitiesCard({required this.activities});

  @override
  State<_ActivitiesCard> createState() => _ActivitiesCardState();
}

class _ActivitiesCardState extends State<_ActivitiesCard> {
  String _selectedFilter = 'Toutes';
  static const int _maxVisibleItems = 5;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) {
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

    // Extraire les disciplines uniques
    final disciplines = <String>{'Toutes'};
    for (var activity in widget.activities) {
      if (activity.discipline != null && activity.discipline!.isNotEmpty) {
        disciplines.add(activity.discipline!);
      }
    }

    // Filtrer par discipline
    final filteredActivities = _selectedFilter == 'Toutes'
        ? widget.activities
        : widget.activities.where((a) => a.discipline == _selectedFilter).toList();

    // Grouper par date puis par discipline
    final groupedByDate = <String, Map<String, List<ActivityModel>>>{};
    for (var activity in filteredActivities) {
      final dateKey = _formatDateKey(activity.date);
      final discipline = activity.discipline ?? 'Autre';
      groupedByDate.putIfAbsent(dateKey, () => {});
      groupedByDate[dateKey]!.putIfAbsent(discipline, () => []).add(activity);
    }

    // Limiter le nombre de dates affichées
    final dateEntries = groupedByDate.entries.toList();
    final visibleEntries = _showAll ? dateEntries : dateEntries.take(_maxVisibleItems).toList();

    return Column(
      children: [
        // Filtres par discipline
        if (disciplines.length > 2)
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: disciplines.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final discipline = disciplines.elementAt(index);
                final isSelected = discipline == _selectedFilter;
                return FilterChip(
                  label: Text(
                    discipline,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppColors.grey700,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedFilter = discipline),
                  backgroundColor: AppColors.grey100,
                  selectedColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  visualDensity: VisualDensity.compact,
                );
              },
            ),
          ),
        
        if (disciplines.length > 2) const SizedBox(height: 12),

        // Résumé global
        _buildSummaryCard(filteredActivities),

        const SizedBox(height: 12),

        // Liste des activités groupées
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ...visibleEntries.map((dateEntry) {
                final dateLabel = dateEntry.key;
                final disciplineGroups = dateEntry.value;
                
                // Calculer les totaux pour cette date
                int totalPresents = 0;
                int totalAbsents = 0;
                int totalAthletes = 0;
                
                for (var group in disciplineGroups.values) {
                  totalAthletes += group.length;
                  totalPresents += group.where((a) => a.present == true).length;
                  totalAbsents += group.where((a) => a.present != true).length;
                }

                return ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    radius: 18,
                    child: Text(
                      '$totalAthletes',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    dateLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.check_circle, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text('$totalPresents', style: TextStyle(color: AppColors.success, fontSize: 12)),
                      const SizedBox(width: 12),
                      Icon(Icons.cancel, size: 14, color: AppColors.error),
                      const SizedBox(width: 4),
                      Text('$totalAbsents', style: TextStyle(color: AppColors.error, fontSize: 12)),
                      const SizedBox(width: 12),
                      Text(
                        '${disciplineGroups.length} discipline${disciplineGroups.length > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 11, color: AppColors.grey600),
                      ),
                    ],
                  ),
                  children: disciplineGroups.entries.map((disciplineEntry) {
                    final disciplineName = disciplineEntry.key;
                    final athletes = disciplineEntry.value;
                    final nbPresents = athletes.where((a) => a.present == true).length;
                    final nbAbsents = athletes.length - nbPresents;
                    final tauxPresence = athletes.isNotEmpty 
                        ? (nbPresents / athletes.length * 100).toStringAsFixed(0) 
                        : '0';

                    return Container(
                      color: AppColors.grey100,
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        leading: _getDisciplineIcon(disciplineName),
                        title: Text(
                          disciplineName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              '${athletes.length} athlètes',
                              style: TextStyle(fontSize: 11, color: AppColors.grey600),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: _getTauxColor(double.parse(tauxPresence)).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$tauxPresence%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getTauxColor(double.parse(tauxPresence)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: athletes.map((activity) {
                          return Container(
                            color: Colors.white,
                            child: ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              leading: Icon(
                                activity.present == true ? Icons.check_circle : Icons.cancel,
                                color: activity.present == true ? AppColors.success : AppColors.error,
                                size: 18,
                              ),
                              title: Text(
                                activity.athlete ?? 'Athlète',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: activity.present == true 
                                      ? AppColors.success.withOpacity(0.15) 
                                      : AppColors.error.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  activity.present == true ? 'P' : 'A',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: activity.present == true ? AppColors.success : AppColors.error,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                );
              }),

              // Bouton "Voir plus" si nécessaire
              if (dateEntries.length > _maxVisibleItems && !_showAll)
                InkWell(
                  onTap: () => setState(() => _showAll = true),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      border: Border(top: BorderSide(color: AppColors.grey200)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.expand_more, size: 18, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Voir ${dateEntries.length - _maxVisibleItems} jours de plus',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              if (_showAll && dateEntries.length > _maxVisibleItems)
                InkWell(
                  onTap: () => setState(() => _showAll = false),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      border: Border(top: BorderSide(color: AppColors.grey200)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.expand_less, size: 18, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Réduire',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(List<ActivityModel> activities) {
    final totalPresents = activities.where((a) => a.present == true).length;
    final totalAbsents = activities.length - totalPresents;
    final tauxGlobal = activities.isNotEmpty 
        ? (totalPresents / activities.length * 100) 
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.1), AppColors.primary.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            icon: Icons.people,
            value: '${activities.length}',
            label: 'Total',
            color: AppColors.primary,
          ),
          _SummaryItem(
            icon: Icons.check_circle,
            value: '$totalPresents',
            label: 'Présents',
            color: AppColors.success,
          ),
          _SummaryItem(
            icon: Icons.cancel,
            value: '$totalAbsents',
            label: 'Absents',
            color: AppColors.error,
          ),
          _SummaryItem(
            icon: Icons.percent,
            value: '${tauxGlobal.toStringAsFixed(0)}%',
            label: 'Taux',
            color: _getTauxColor(tauxGlobal),
          ),
        ],
      ),
    );
  }

  Widget _getDisciplineIcon(String discipline) {
    IconData icon;
    Color color;
    
    switch (discipline.toLowerCase()) {
      case 'basketball':
      case 'basket':
        icon = Icons.sports_basketball;
        color = Colors.orange;
        break;
      case 'volleyball':
      case 'volley':
        icon = Icons.sports_volleyball;
        color = Colors.blue;
        break;
      case 'taekwondo':
      case 'karate':
      case 'judo':
        icon = Icons.sports_martial_arts;
        color = Colors.red;
        break;
      case 'football':
        icon = Icons.sports_soccer;
        color = Colors.green;
        break;
      case 'natation':
        icon = Icons.pool;
        color = Colors.cyan;
        break;
      default:
        icon = Icons.sports;
        color = AppColors.primary;
    }
    
    return CircleAvatar(
      radius: 14,
      backgroundColor: color.withOpacity(0.15),
      child: Icon(icon, size: 16, color: color),
    );
  }

  Color _getTauxColor(double taux) {
    if (taux >= 80) return AppColors.success;
    if (taux >= 50) return AppColors.warning;
    return AppColors.error;
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) {
      return "Aujourd'hui";
    } else if (diff == 1) {
      return 'Hier';
    } else if (diff < 7) {
      return 'Il y a $diff jours';
    } else {
      const mois = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
      return '${date.day} ${mois[date.month - 1]} ${date.year}';
    }
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
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
