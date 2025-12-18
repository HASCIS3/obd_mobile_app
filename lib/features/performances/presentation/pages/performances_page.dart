import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/performance_model.dart';
import '../../../../core/router/route_names.dart';
import '../bloc/performance_bloc.dart';

/// Page des performances
class PerformancesPage extends StatelessWidget {
  const PerformancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PerformanceBloc>()..add(const PerformanceLoadRequested()),
      child: const _PerformancesView(),
    );
  }
}

class _PerformancesView extends StatelessWidget {
  const _PerformancesView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PerformanceBloc, PerformanceState>(
      listener: (context, state) {
        if (state.isSuccess && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success),
          );
        }
        if (state.status == PerformanceStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.performances),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(RouteNames.performanceCreate),
            child: const Icon(Icons.add),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PerformanceState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == PerformanceStatus.error) {
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
                context.read<PerformanceBloc>().add(const PerformanceLoadRequested());
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final performances = state.performances;

    if (performances.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_score, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            const Text('Aucune performance enregistrée'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PerformanceBloc>().add(const PerformanceRefreshRequested());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        itemCount: performances.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final performance = performances[index];
          return _PerformanceCard(
            performance: performance,
            onTap: () {},
            onDelete: () => _confirmDelete(context, performance),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, PerformanceModel performance) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la performance'),
        content: const Text('Voulez-vous vraiment supprimer cette performance ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PerformanceBloc>().add(PerformanceDeleteRequested(performance.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final PerformanceModel performance;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PerformanceCard({
    required this.performance,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final noteGlobale = performance.noteGlobale ?? 0;
    Color noteColor;
    if (noteGlobale >= 16) {
      noteColor = AppColors.success;
    } else if (noteGlobale >= 12) {
      noteColor = AppColors.warning;
    } else {
      noteColor = AppColors.error;
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              // Note
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: noteColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Center(
                  child: Text(
                    noteGlobale.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: noteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      performance.athlete?.nomComplet ?? 'Athlète #${performance.athleteId}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${performance.discipline?.nom ?? ""} • ${performance.contexteLibelle}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(performance.dateEvaluation),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
