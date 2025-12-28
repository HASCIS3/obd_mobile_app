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

class _PaiementsView extends StatefulWidget {
  const _PaiementsView();

  @override
  State<_PaiementsView> createState() => _PaiementsViewState();
}

class _PaiementsViewState extends State<_PaiementsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'tous'; // tous, paye, impaye

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<PaiementBloc>().add(const PaiementRefreshRequested());
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(icon: Icon(Icons.person_add), text: 'Inscriptions'),
                Tab(icon: Icon(Icons.calendar_month), text: 'Cotisations'),
                Tab(icon: Icon(Icons.sports), text: 'Équipements'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await context.push('${RouteNames.paiements}/${RouteNames.paiementCreate}');
              if (result == true && context.mounted) {
                context.read<PaiementBloc>().add(const PaiementRefreshRequested());
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Paiement'),
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

    return Column(
      children: [
        // Stats globales
        _buildGlobalStats(paiements),
        
        // Filtres par statut
        _buildStatusFilters(paiements),

        // Contenu avec tabs
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPaiementsList(context, paiements, 'inscription'),
              _buildPaiementsList(context, paiements, 'cotisation'),
              _buildPaiementsList(context, paiements, 'equipement'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalStats(List<PaiementModel> paiements) {
    final totalMontant = paiements.fold<double>(0, (sum, p) => sum + p.montant);
    final totalPaye = paiements.fold<double>(0, (sum, p) => sum + p.montantPaye);
    final totalImpayes = totalMontant - totalPaye;
    final pourcentage = totalMontant > 0 ? (totalPaye / totalMontant * 100) : 0.0;

    // Stats par type
    final inscriptions = paiements.where((p) => p.typePaiement == 'inscription').toList();
    final cotisations = paiements.where((p) => p.typePaiement == 'cotisation').toList();
    final equipements = paiements.where((p) => p.typePaiement == 'equipement').toList();

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ligne principale
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.account_balance_wallet,
                  value: _formatMontant(totalMontant),
                  label: 'Total attendu',
                  color: AppColors.primary,
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.grey200),
              Expanded(
                child: _StatItem(
                  icon: Icons.check_circle,
                  value: _formatMontant(totalPaye),
                  label: 'Encaissé',
                  color: AppColors.success,
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.grey200),
              Expanded(
                child: _StatItem(
                  icon: Icons.warning,
                  value: _formatMontant(totalImpayes),
                  label: 'Impayés',
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Barre de progression
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (pourcentage / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Répartition par type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TypeBadge(
                label: 'Inscriptions',
                count: inscriptions.length,
                color: AppColors.primary,
              ),
              _TypeBadge(
                label: 'Cotisations',
                count: cotisations.length,
                color: AppColors.secondary,
              ),
              _TypeBadge(
                label: 'Équipements',
                count: equipements.length,
                color: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters(List<PaiementModel> paiements) {
    final nbPayes = paiements.where((p) => p.statut == StatutPaiement.paye).length;
    final nbImpayes = paiements.where((p) => p.statut == StatutPaiement.impaye).length;
    final nbPartiels = paiements.where((p) => p.statut == StatutPaiement.partiel).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'Tous (${paiements.length})',
            selected: _selectedFilter == 'tous',
            onSelected: () => setState(() => _selectedFilter = 'tous'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Payés ($nbPayes)',
            selected: _selectedFilter == 'paye',
            onSelected: () => setState(() => _selectedFilter = 'paye'),
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Impayés ($nbImpayes)',
            selected: _selectedFilter == 'impaye',
            onSelected: () => setState(() => _selectedFilter = 'impaye'),
            color: AppColors.error,
          ),
          if (nbPartiels > 0) ...[
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Partiels ($nbPartiels)',
              selected: _selectedFilter == 'partiel',
              onSelected: () => setState(() => _selectedFilter = 'partiel'),
              color: AppColors.warning,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaiementsList(BuildContext context, List<PaiementModel> allPaiements, String type) {
    // Filtrer par type (comparer avec l'enum)
    var paiements = allPaiements.where((p) {
      switch (type) {
        case 'inscription':
          return p.typePaiement == TypePaiement.inscription;
        case 'cotisation':
          return p.typePaiement == TypePaiement.cotisation;
        case 'equipement':
          return p.typePaiement == TypePaiement.equipement;
        default:
          return false;
      }
    }).toList();
    
    // Filtrer par statut
    if (_selectedFilter == 'paye') {
      paiements = paiements.where((p) => p.statut == StatutPaiement.paye).toList();
    } else if (_selectedFilter == 'impaye') {
      paiements = paiements.where((p) => p.statut == StatutPaiement.impaye).toList();
    } else if (_selectedFilter == 'partiel') {
      paiements = paiements.where((p) => p.statut == StatutPaiement.partiel).toList();
    }

    if (paiements.isEmpty) {
      return _buildEmptyState(type);
    }

    // Grouper par athlète
    final groupedByAthlete = <int, List<PaiementModel>>{};
    for (var paiement in paiements) {
      groupedByAthlete.putIfAbsent(paiement.athleteId, () => []).add(paiement);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PaiementBloc>().add(const PaiementRefreshRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
        itemCount: groupedByAthlete.length,
        itemBuilder: (context, index) {
          final athleteId = groupedByAthlete.keys.elementAt(index);
          final athletePaiements = groupedByAthlete[athleteId]!;
          final athlete = athletePaiements.first.athlete;
          final totalAthlete = athletePaiements.fold<double>(0, (sum, p) => sum + p.montant);
          final payeAthlete = athletePaiements.fold<double>(0, (sum, p) => sum + p.montantPaye);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: _getTypeColor(type).withOpacity(0.15),
                child: Text(
                  _getInitials(athlete?.nomComplet ?? 'A'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(type),
                  ),
                ),
              ),
              title: Text(
                athlete?.nomComplet ?? 'Athlète #$athleteId',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.payments, size: 14, color: AppColors.grey600),
                  const SizedBox(width: 4),
                  Text(
                    '${athletePaiements.length} paiement${athletePaiements.length > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 12, color: AppColors.grey600),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: payeAthlete >= totalAthlete
                          ? AppColors.success.withOpacity(0.15)
                          : AppColors.warning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatMontant(payeAthlete),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: payeAthlete >= totalAthlete ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              children: athletePaiements.map((paiement) {
                return _buildPaiementRow(context, paiement);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaiementRow(BuildContext context, PaiementModel paiement) {
    Color statutColor;
    IconData statutIcon;

    if (paiement.statut == StatutPaiement.paye) {
      statutColor = AppColors.success;
      statutIcon = Icons.check_circle;
    } else if (paiement.statut == StatutPaiement.partiel) {
      statutColor = AppColors.warning;
      statutIcon = Icons.timelapse;
    } else {
      statutColor = AppColors.error;
      statutIcon = Icons.cancel;
    }

    return Container(
      color: statutColor.withOpacity(0.03),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: statutColor.withOpacity(0.15),
          child: Icon(statutIcon, size: 16, color: statutColor),
        ),
        title: Text(
          paiement.periode,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          _getModePaiementLabel(paiement.modePaiement),
          style: TextStyle(fontSize: 11, color: AppColors.grey600),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              paiement.montantFormate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statutColor,
              ),
            ),
            if (paiement.datePaiement != null)
              Text(
                _formatDate(paiement.datePaiement!),
                style: TextStyle(fontSize: 10, color: AppColors.grey600),
              ),
          ],
        ),
        onLongPress: () => _confirmDelete(context, paiement),
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    String message;
    IconData icon;
    
    switch (type) {
      case 'inscription':
        message = 'Aucune inscription enregistrée';
        icon = Icons.person_add;
        break;
      case 'cotisation':
        message = 'Aucune cotisation enregistrée';
        icon = Icons.calendar_month;
        break;
      case 'equipement':
        message = 'Aucun équipement enregistré';
        icon = Icons.sports;
        break;
      default:
        message = 'Aucun paiement';
        icon = Icons.payment;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur + pour ajouter',
            style: TextStyle(fontSize: 13, color: AppColors.grey500),
          ),
        ],
      ),
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

  Color _getTypeColor(String type) {
    switch (type) {
      case 'inscription':
        return AppColors.primary;
      case 'cotisation':
        return AppColors.secondary;
      case 'equipement':
        return AppColors.accent;
      default:
        return AppColors.primary;
    }
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'A';
  }

  String _formatMontant(double montant) {
    return '${montant.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getModePaiementLabel(ModePaiement? mode) {
    switch (mode) {
      case ModePaiement.especes:
        return 'Espèces';
      case ModePaiement.virement:
        return 'Virement';
      case ModePaiement.mobileMoney:
        return 'Mobile Money';
      default:
        return 'Espèces';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
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
            fontSize: 13,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 9, color: AppColors.grey600),
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _TypeBadge({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? chipColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: chipColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : chipColor,
          ),
        ),
      ),
    );
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
