import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/athlete_model.dart';
import '../../../../core/router/route_names.dart';
import '../bloc/athlete_bloc.dart';

/// Page liste des athlètes
class AthletesPage extends StatelessWidget {
  const AthletesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AthleteBloc>()..add(const AthleteLoadRequested()),
      child: const _AthletesView(),
    );
  }
}

class _AthletesView extends StatefulWidget {
  const _AthletesView();

  @override
  State<_AthletesView> createState() => _AthletesViewState();
}

class _AthletesViewState extends State<_AthletesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AthleteBloc, AthleteState>(
      listener: (context, state) {
        if (state.isSuccess && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.success,
            ),
          );
        }
        if (state.hasError && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.athletes),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('${RouteNames.athletes}/${RouteNames.athleteCreate}'),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              // Barre de recherche
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchAthlete,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<AthleteBloc>().add(
                                    const AthleteSearchChanged(''),
                                  );
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    context.read<AthleteBloc>().add(AthleteSearchChanged(value));
                  },
                ),
              ),

              // Nombre de résultats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.athletes.length} athlètes trouvés',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Liste des athlètes
              Expanded(
                child: _buildAthletesList(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAthletesList(BuildContext context, AthleteState state) {
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
                context.read<AthleteBloc>().add(const AthleteLoadRequested());
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (state.athletes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            const Text('Aucun athlète trouvé'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AthleteBloc>().add(const AthleteRefreshRequested());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        itemCount: state.athletes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final athlete = state.athletes[index];
          return _AthleteCard(
            athlete: athlete,
            onTap: () {
              context.push('${RouteNames.athletes}/${athlete.id}');
            },
            onDelete: () => _confirmDelete(context, athlete),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AthleteModel athlete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'athlète'),
        content: Text('Voulez-vous vraiment supprimer ${athlete.nomComplet} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AthleteBloc>().add(AthleteDeleteRequested(athlete.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _AthleteCard extends StatelessWidget {
  final AthleteModel athlete;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AthleteCard({
    required this.athlete,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasArrieres = athlete.arrieres != null && athlete.arrieres! > 0;
    final tauxPresence = athlete.tauxPresence ?? 0;
    final lowPresence = tauxPresence < 70;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: athlete.photo != null
                    ? NetworkImage(athlete.photo!)
                    : null,
                child: athlete.photo == null
                    ? Text(
                        '${athlete.prenom[0]}${athlete.nom[0]}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.nomComplet,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${athlete.categorieAgeLibelle} • ${athlete.age ?? "?"} ans • ${athlete.sexeLibelle}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (athlete.actif)
                          _StatusBadge(
                            label: 'Actif',
                            color: AppColors.success,
                          )
                        else
                          _StatusBadge(
                            label: 'Inactif',
                            color: AppColors.grey500,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          'Présence: ${tauxPresence.toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: lowPresence
                                    ? AppColors.warning
                                    : AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                    if (hasArrieres) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            size: 14,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Arriérés: ${athlete.arrieres!.toStringAsFixed(0)} FCFA',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.error,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}
