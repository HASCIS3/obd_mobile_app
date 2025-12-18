import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/discipline_model.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/discipline_bloc.dart';

/// Page des disciplines
class DisciplinesPage extends StatelessWidget {
  const DisciplinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DisciplineBloc>()..add(const DisciplineLoadRequested()),
      child: const _DisciplinesView(),
    );
  }
}

class _DisciplinesView extends StatelessWidget {
  const _DisciplinesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.disciplines),
      ),
      body: BlocBuilder<DisciplineBloc, DisciplineState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DisciplineStatus.error) {
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
                      context.read<DisciplineBloc>().add(const DisciplineLoadRequested());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state.disciplines.isEmpty) {
            return const Center(child: Text('Aucune discipline trouvée'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DisciplineBloc>().add(const DisciplineRefreshRequested());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              itemCount: state.disciplines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final discipline = state.disciplines[index];
                return _DisciplineCard(
                  discipline: discipline,
                  onTap: () {
                    // Détail discipline
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DisciplineCard extends StatelessWidget {
  final DisciplineModel discipline;
  final VoidCallback onTap;

  const _DisciplineCard({
    required this.discipline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.primary;

    return OBDCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icône
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Icon(
                  Icons.sports,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            discipline.nom,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!discipline.actif)
                          OBDStatusBadge.inactive(),
                      ],
                    ),
                    if (discipline.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        discipline.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),

              // Tarif
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${discipline.tarifMensuel.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'FCFA/mois',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.people,
                  label: 'Athlètes',
                  value: '${discipline.nbAthletesActifs ?? 0}',
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
