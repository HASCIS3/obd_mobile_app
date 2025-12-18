import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/paiement_model.dart';
import '../../../../core/router/route_names.dart';
import '../bloc/paiement_bloc.dart';

/// Page des paiements
class PaiementsPage extends StatelessWidget {
  const PaiementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaiementBloc>()..add(const PaiementLoadRequested()),
      child: const _PaiementsView(),
    );
  }
}

class _PaiementsView extends StatelessWidget {
  const _PaiementsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaiementBloc, PaiementState>(
      listener: (context, state) {
        if (state.isSuccess && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success),
          );
        }
        if (state.status == PaiementStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.paiements),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(RouteNames.paiementCreate),
            child: const Icon(Icons.add),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PaiementState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == PaiementStatus.error) {
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
                context.read<PaiementBloc>().add(const PaiementLoadRequested());
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final paiements = state.paiements;
    final totalMontant = paiements.fold<double>(0, (sum, p) => sum + p.montant);
    final totalPaye = paiements.fold<double>(0, (sum, p) => sum + p.montantPaye);
    final pourcentage = totalMontant > 0 ? (totalPaye / totalMontant) : 0.0;

    return Column(
      children: [
        // Résumé
        Container(
          margin: const EdgeInsets.all(AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Résumé', style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    '${(pourcentage * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pourcentage,
                  minHeight: 8,
                  backgroundColor: AppColors.grey200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Collecté: ${_formatMontant(totalPaye)} / ${_formatMontant(totalMontant)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // Nombre de résultats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${paiements.length} paiements',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Liste
        Expanded(
          child: paiements.isEmpty
              ? const Center(child: Text('Aucun paiement trouvé'))
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<PaiementBloc>().add(const PaiementRefreshRequested());
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    itemCount: paiements.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final paiement = paiements[index];
                      return _PaiementCard(
                        paiement: paiement,
                        onTap: () {},
                        onDelete: () => _confirmDelete(context, paiement),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, PaiementModel paiement) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le paiement'),
        content: const Text('Voulez-vous vraiment supprimer ce paiement ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PaiementBloc>().add(PaiementDeleteRequested(paiement.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  String _formatMontant(double montant) {
    return '${montant.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} FCFA';
  }
}

class _PaiementCard extends StatelessWidget {
  final PaiementModel paiement;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PaiementCard({
    required this.paiement,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color statutColor;
    String statutLabel;
    IconData statutIcon;

    if (paiement.statut == StatutPaiement.paye) {
      statutColor = AppColors.success;
      statutLabel = 'Payé';
      statutIcon = Icons.check_circle;
    } else if (paiement.statut == StatutPaiement.partiel) {
      statutColor = AppColors.warning;
      statutLabel = 'Partiel';
      statutIcon = Icons.timelapse;
    } else {
      statutColor = AppColors.error;
      statutLabel = 'Impayé';
      statutIcon = Icons.cancel;
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: statutColor.withValues(alpha: 0.1),
                child: Icon(statutIcon, color: statutColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paiement.athlete?.nomComplet ?? 'Athlète #${paiement.athleteId}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${paiement.periode} • ${paiement.typePaiementLibelle}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    paiement.montantFormate,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statutColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statutLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: statutColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
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
