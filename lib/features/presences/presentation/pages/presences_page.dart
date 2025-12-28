import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/presence_model.dart';
import '../../../../core/router/route_names.dart';
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

class _PresencesViewState extends State<_PresencesView> with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  String _selectedDiscipline = 'Toutes';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<PresenceBloc>().add(const PresenceRefreshRequested());
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
                Tab(icon: Icon(Icons.view_list), text: 'Par Discipline'),
                Tab(icon: Icon(Icons.people), text: 'Par Athlète'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await context.push('${RouteNames.presences}/${RouteNames.presenceCreate}');
              if (result == true && context.mounted) {
                context.read<PresenceBloc>().add(const PresenceRefreshRequested());
              }
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

    return Column(
      children: [
        // Sélecteur de date
        _buildDateSelector(context),

        // Stats globales
        _buildGlobalStats(presences),

        // Contenu avec tabs
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDisciplineView(context, presences),
              _buildAthleteView(context, presences),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.1), AppColors.primary.withOpacity(0.05)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
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
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(_selectedDate),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))
                ? () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 1));
                    });
                    _loadForDate(context);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalStats(List<PresenceModel> presences) {
    final nbPresents = presences.where((p) => p.present).length;
    final nbAbsents = presences.where((p) => !p.present).length;
    final tauxPresence = presences.isNotEmpty ? (nbPresents / presences.length * 100) : 0.0;

    // Extraire les disciplines uniques
    final disciplines = presences.map((p) => p.discipline?.nom ?? 'Autre').toSet();

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
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.people,
                  value: '${presences.length}',
                  label: 'Total',
                  color: AppColors.primary,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.grey200),
              Expanded(
                child: _StatItem(
                  icon: Icons.check_circle,
                  value: '$nbPresents',
                  label: 'Présents',
                  color: AppColors.success,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.grey200),
              Expanded(
                child: _StatItem(
                  icon: Icons.cancel,
                  value: '$nbAbsents',
                  label: 'Absents',
                  color: AppColors.error,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.grey200),
              Expanded(
                child: _StatItem(
                  icon: Icons.trending_up,
                  value: '${tauxPresence.toStringAsFixed(0)}%',
                  label: 'Taux',
                  color: _getTauxColor(tauxPresence),
                ),
              ),
            ],
          ),
          if (disciplines.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.sports, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                Text(
                  '${disciplines.length} discipline${disciplines.length > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 12, color: AppColors.grey600),
                ),
                const Spacer(),
                ...disciplines.take(3).map((d) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _getDisciplineChip(d),
                )),
                if (disciplines.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '+${disciplines.length - 3}',
                      style: TextStyle(fontSize: 11, color: AppColors.grey600),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDisciplineView(BuildContext context, List<PresenceModel> presences) {
    if (presences.isEmpty) {
      return _buildEmptyState();
    }

    // Grouper par discipline
    final groupedByDiscipline = <String, List<PresenceModel>>{};
    for (var presence in presences) {
      final discipline = presence.discipline?.nom ?? 'Autre';
      groupedByDiscipline.putIfAbsent(discipline, () => []).add(presence);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PresenceBloc>().add(const PresenceRefreshRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
        itemCount: groupedByDiscipline.length,
        itemBuilder: (context, index) {
          final discipline = groupedByDiscipline.keys.elementAt(index);
          final disciplinePresences = groupedByDiscipline[discipline]!;
          final nbPresents = disciplinePresences.where((p) => p.present).length;
          final nbAbsents = disciplinePresences.length - nbPresents;
          final taux = disciplinePresences.isNotEmpty
              ? (nbPresents / disciplinePresences.length * 100)
              : 0.0;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: _getDisciplineIcon(discipline),
              title: Text(
                discipline,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                children: [
                  _buildMiniStat(Icons.people, '${disciplinePresences.length}', AppColors.primary),
                  const SizedBox(width: 12),
                  _buildMiniStat(Icons.check_circle, '$nbPresents', AppColors.success),
                  const SizedBox(width: 12),
                  _buildMiniStat(Icons.cancel, '$nbAbsents', AppColors.error),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getTauxColor(taux).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${taux.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getTauxColor(taux),
                      ),
                    ),
                  ),
                ],
              ),
              children: disciplinePresences.map((presence) {
                return _buildAthleteRow(context, presence);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAthleteView(BuildContext context, List<PresenceModel> presences) {
    if (presences.isEmpty) {
      return _buildEmptyState();
    }

    // Grouper par athlète
    final groupedByAthlete = <int, List<PresenceModel>>{};
    for (var presence in presences) {
      groupedByAthlete.putIfAbsent(presence.athleteId, () => []).add(presence);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PresenceBloc>().add(const PresenceRefreshRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
        itemCount: groupedByAthlete.length,
        itemBuilder: (context, index) {
          final athleteId = groupedByAthlete.keys.elementAt(index);
          final athletePresences = groupedByAthlete[athleteId]!;
          final athlete = athletePresences.first.athlete;
          final nbPresents = athletePresences.where((p) => p.present).length;
          final nbAbsents = athletePresences.length - nbPresents;
          final taux = athletePresences.isNotEmpty
              ? (nbPresents / athletePresences.length * 100)
              : 0.0;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _getTauxColor(taux).withOpacity(0.15),
                    child: Text(
                      _getInitials(athlete?.nomComplet ?? 'A'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getTauxColor(taux),
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
                          athlete?.nomComplet ?? 'Athlète #$athleteId',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...athletePresences.map((p) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: _getDisciplineChip(p.discipline?.nom ?? 'Autre'),
                            )).take(2),
                            if (athletePresences.length > 2)
                              Text(
                                '+${athletePresences.length - 2}',
                                style: TextStyle(fontSize: 10, color: AppColors.grey600),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Stats
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTauxColor(taux).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${taux.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getTauxColor(taux),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: AppColors.success),
                          Text(' $nbPresents', style: TextStyle(fontSize: 11, color: AppColors.success)),
                          const SizedBox(width: 8),
                          Icon(Icons.cancel, size: 12, color: AppColors.error),
                          Text(' $nbAbsents', style: TextStyle(fontSize: 11, color: AppColors.error)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAthleteRow(BuildContext context, PresenceModel presence) {
    return Container(
      color: presence.present ? AppColors.success.withOpacity(0.05) : AppColors.error.withOpacity(0.05),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: presence.present
              ? AppColors.success.withOpacity(0.15)
              : AppColors.error.withOpacity(0.15),
          child: Icon(
            presence.present ? Icons.check : Icons.close,
            size: 16,
            color: presence.present ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(
          presence.athlete?.nomComplet ?? 'Athlète #${presence.athleteId}',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: Switch(
          value: presence.present,
          onChanged: (_) {
            context.read<PresenceBloc>().add(
              PresenceUpdateRequested(
                id: presence.id,
                data: {'present': !presence.present},
              ),
            );
          },
          activeColor: AppColors.success,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            'Aucune présence pour cette date',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur + pour faire le pointage',
            style: TextStyle(fontSize: 13, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      ],
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
      radius: 20,
      backgroundColor: color.withOpacity(0.15),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _getDisciplineChip(String discipline) {
    Color color;
    switch (discipline.toLowerCase()) {
      case 'basketball':
      case 'basket':
        color = Colors.orange;
        break;
      case 'volleyball':
      case 'volley':
        color = Colors.blue;
        break;
      case 'taekwondo':
      case 'karate':
      case 'judo':
        color = Colors.red;
        break;
      case 'football':
        color = Colors.green;
        break;
      default:
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        discipline.length > 10 ? '${discipline.substring(0, 8)}...' : discipline,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Color _getTauxColor(double taux) {
    if (taux >= 80) return AppColors.success;
    if (taux >= 50) return AppColors.warning;
    return AppColors.error;
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'A';
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
            fontSize: 18,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.grey600),
        ),
      ],
    );
  }
}
