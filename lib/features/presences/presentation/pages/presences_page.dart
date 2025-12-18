import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/presence_model.dart';
import '../bloc/presence_bloc.dart';

/// Page des présences
class PresencesPage extends StatelessWidget {
  const PresencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PresenceBloc>()..add(const PresenceLoadRequested()),
      child: const _PresencesView(),
    );
  }
}

class _PresencesView extends StatefulWidget {
  const _PresencesView();

  @override
  State<_PresencesView> createState() => _PresencesViewState();
}

class _PresencesViewState extends State<_PresencesView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PresenceBloc, PresenceState>(
      listener: (context, state) {
        if (state.isSuccess && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success),
          );
        }
        if (state.status == PresenceStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.presences),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // TODO: Nouveau pointage
            },
            icon: const Icon(Icons.add),
            label: const Text('Pointage'),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PresenceState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == PresenceStatus.error) {
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
                context.read<PresenceBloc>().add(const PresenceLoadRequested());
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final presences = state.presences;

    // Stats
    final nbPresents = presences.where((p) => p.present).length;
    final nbAbsents = presences.where((p) => !p.present).length;
    final tauxPresence = presences.isNotEmpty 
        ? (nbPresents / presences.length * 100) 
        : 0.0;

    return Column(
      children: [
        // Date sélectionnée
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          color: AppColors.primary.withValues(alpha: 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                  });
                  _loadForDate(context);
                },
              ),
              Text(
                _formatDate(_selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(const Duration(days: 1));
                  });
                  _loadForDate(context);
                },
              ),
            ],
          ),
        ),

        // Stats
        Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              _StatCard(
                icon: Icons.check_circle,
                label: 'Présents',
                value: '$nbPresents',
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.cancel,
                label: 'Absents',
                value: '$nbAbsents',
                color: AppColors.error,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.percent,
                label: 'Taux',
                value: '${tauxPresence.toStringAsFixed(0)}%',
                color: AppColors.primary,
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
              '${presences.length} présences enregistrées',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Liste
        Expanded(
          child: presences.isEmpty
              ? const Center(child: Text('Aucune présence pour cette date'))
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<PresenceBloc>().add(const PresenceRefreshRequested());
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    itemCount: presences.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final presence = presences[index];
                      return _PresenceCard(
                        presence: presence,
                        onToggle: () {
                          context.read<PresenceBloc>().add(
                            PresenceUpdateRequested(
                              id: presence.id,
                              data: {'present': !presence.present},
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  void _loadForDate(BuildContext context) {
    final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    context.read<PresenceBloc>().add(PresenceLoadRequested(date: dateStr));
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
      _loadForDate(context);
    }
  }

  String _formatDate(DateTime date) {
    const jours = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    const mois = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${jours[date.weekday - 1]} ${date.day} ${mois[date.month - 1]} ${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PresenceCard extends StatelessWidget {
  final PresenceModel presence;
  final VoidCallback onToggle;

  const _PresenceCard({
    required this.presence,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = presence.present;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPresent
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.error.withValues(alpha: 0.1),
          child: Icon(
            isPresent ? Icons.check : Icons.close,
            color: isPresent ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(presence.athlete?.nomComplet ?? 'Athlète #${presence.athleteId}'),
        subtitle: Text(presence.discipline?.nom ?? ''),
        trailing: Switch(
          value: isPresent,
          onChanged: (_) => onToggle(),
          activeColor: AppColors.success,
        ),
      ),
    );
  }
}
