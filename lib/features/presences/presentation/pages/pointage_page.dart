import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/athlete_model.dart';
import '../../../../core/models/discipline_model.dart';
import '../../../../core/models/presence_model.dart';
import '../../../../core/widgets/presence_calendar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../athletes/domain/repositories/athlete_repository.dart';
import '../../../disciplines/domain/repositories/discipline_repository.dart';
import '../../domain/repositories/presence_repository.dart';
import '../bloc/presence_bloc.dart';

/// Types de période pour le filtrage
enum PeriodeType { jour, semaine, mois, trimestre, annee }

/// Page de pointage des présences
class PointagePage extends StatefulWidget {
  const PointagePage({super.key});

  @override
  State<PointagePage> createState() => _PointagePageState();
}

class _PointagePageState extends State<PointagePage> {
  DateTime _selectedDate = DateTime.now();
  PeriodeType _periodeType = PeriodeType.jour;
  DisciplineModel? _selectedDiscipline;
  
  List<AthleteModel> _athletes = [];
  List<DisciplineModel> _disciplines = [];
  Map<int, bool> _presenceStatus = {}; // athleteId -> present
  Map<int, Map<String, dynamic>> _athleteStats = {}; // athleteId -> {presences, absences, taux}
  Set<DateTime> _presenceDates = {}; // Dates où il y a eu des présences
  Set<DateTime> _absenceDates = {}; // Dates où il y a eu des absences
  List<PresenceModel> _existingPresences = []; // Présences existantes
  bool _isLoading = true;
  bool _isSaving = false;
  bool _loadingStats = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Charger les disciplines
    final disciplineRepo = sl<DisciplineRepository>();
    final disciplineResult = await disciplineRepo.getDisciplines();
    
    disciplineResult.fold(
      (failure) {
        if (mounted) {
          OBDSnackBar.error(context, 'Erreur: ${failure.message}');
        }
      },
      (disciplines) {
        _disciplines = disciplines;
        if (disciplines.isNotEmpty) {
          _selectedDiscipline = disciplines.first;
        }
      },
    );

    // Charger les athlètes
    await _loadAthletes();
    
    // Charger les stats de présence pour la période
    await _loadPresenceStats();
    
    setState(() => _isLoading = false);
  }

  /// Calculer les dates de début et fin selon la période
  Map<String, DateTime> _getPeriodeDates() {
    DateTime debut;
    DateTime fin;
    
    switch (_periodeType) {
      case PeriodeType.jour:
        debut = _selectedDate;
        fin = _selectedDate;
        break;
      case PeriodeType.semaine:
        // Début de la semaine (lundi)
        debut = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
        fin = debut.add(const Duration(days: 6));
        break;
      case PeriodeType.mois:
        debut = DateTime(_selectedDate.year, _selectedDate.month, 1);
        fin = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
        break;
      case PeriodeType.trimestre:
        final trimestre = ((_selectedDate.month - 1) ~/ 3) * 3 + 1;
        debut = DateTime(_selectedDate.year, trimestre, 1);
        fin = DateTime(_selectedDate.year, trimestre + 3, 0);
        break;
      case PeriodeType.annee:
        debut = DateTime(_selectedDate.year, 1, 1);
        fin = DateTime(_selectedDate.year, 12, 31);
        break;
    }
    
    return {'debut': debut, 'fin': fin};
  }

  String _formatPeriodeLabel() {
    final dates = _getPeriodeDates();
    final debut = dates['debut']!;
    final fin = dates['fin']!;
    const mois = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    
    switch (_periodeType) {
      case PeriodeType.jour:
        return '${debut.day} ${mois[debut.month - 1]} ${debut.year}';
      case PeriodeType.semaine:
        return '${debut.day} - ${fin.day} ${mois[fin.month - 1]} ${fin.year}';
      case PeriodeType.mois:
        return '${mois[debut.month - 1]} ${debut.year}';
      case PeriodeType.trimestre:
        final t = ((debut.month - 1) ~/ 3) + 1;
        return 'T$t ${debut.year}';
      case PeriodeType.annee:
        return 'Année ${debut.year}';
    }
  }

  Future<void> _loadPresenceStats() async {
    if (_selectedDiscipline == null) return;
    
    setState(() => _loadingStats = true);
    
    // Charger les présences existantes depuis l'API
    final presenceRepo = sl<PresenceRepository>();
    final dates = _getPeriodeDates();
    final debut = dates['debut']!;
    final fin = dates['fin']!;
    
    // Charger les présences pour la période
    final result = await presenceRepo.getPresences();
    
    result.fold(
      (failure) {
        debugPrint('Erreur chargement présences: ${failure.message}');
      },
      (presences) {
        _existingPresences = presences;
        
        // Extraire les dates de présence et d'absence
        _presenceDates = {};
        _absenceDates = {};
        
        for (var presence in presences) {
          final date = DateTime(presence.date.year, presence.date.month, presence.date.day);
          if (presence.present) {
            _presenceDates.add(date);
          } else {
            _absenceDates.add(date);
          }
        }
        
        // Calculer les stats par athlète
        _athleteStats = {};
        for (var athlete in _filteredAthletes) {
          final athletePresences = presences.where((p) => 
            p.athleteId == athlete.id &&
            p.date.isAfter(debut.subtract(const Duration(days: 1))) &&
            p.date.isBefore(fin.add(const Duration(days: 1)))
          ).toList();
          
          final nbPresent = athletePresences.where((p) => p.present).length;
          final nbAbsent = athletePresences.where((p) => !p.present).length;
          final total = nbPresent + nbAbsent;
          
          _athleteStats[athlete.id] = {
            'presences': nbPresent,
            'absences': nbAbsent,
            'taux': total > 0 ? (nbPresent / total * 100) : 0.0,
          };
        }
      },
    );
    
    setState(() => _loadingStats = false);
  }

  Future<void> _loadAthletes() async {
    final athleteRepo = sl<AthleteRepository>();
    final result = await athleteRepo.getAthletes(actif: true);
    
    result.fold(
      (failure) {
        if (mounted) {
          OBDSnackBar.error(context, 'Erreur: ${failure.message}');
        }
      },
      (athletes) {
        setState(() {
          _athletes = athletes;
          // Initialiser tous les athlètes comme absents
          _presenceStatus = {for (var a in athletes) a.id: false};
        });
      },
    );
  }

  void _togglePresence(int athleteId) {
    setState(() {
      _presenceStatus[athleteId] = !(_presenceStatus[athleteId] ?? false);
    });
  }

  void _selectAll(bool present) {
    setState(() {
      for (var athlete in _filteredAthletes) {
        _presenceStatus[athlete.id] = present;
      }
    });
  }

  List<AthleteModel> get _filteredAthletes {
    if (_selectedDiscipline == null) return _athletes;
    
    return _athletes.where((athlete) {
      if (athlete.disciplines == null) return false;
      return athlete.disciplines!.any((d) => d.id == _selectedDiscipline!.id);
    }).toList();
  }

  Future<void> _savePointage() async {
    if (_selectedDiscipline == null) {
      OBDSnackBar.error(context, 'Sélectionnez une discipline');
      return;
    }

    final presentAthletes = _filteredAthletes
        .where((a) => _presenceStatus[a.id] == true)
        .toList();

    if (presentAthletes.isEmpty) {
      OBDSnackBar.warning(context, 'Aucun athlète marqué présent');
      return;
    }

    setState(() => _isSaving = true);

    final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    
    final presences = _filteredAthletes.map((athlete) => {
      'athlete_id': athlete.id,
      'discipline_id': _selectedDiscipline!.id,
      'date': dateStr,
      'present': _presenceStatus[athlete.id] ?? false,
    }).toList();

    final bloc = sl<PresenceBloc>();
    bloc.add(PresencePointageMasseRequested(presences));

    // Attendre la réponse
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() => _isSaving = false);

    if (mounted) {
      OBDSnackBar.success(context, 'Pointage enregistré avec succès');
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pointage'),
        actions: [
          if (!_isLoading)
            TextButton.icon(
              onPressed: _isSaving ? null : _savePointage,
              icon: _isSaving 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save, color: Colors.white),
              label: Text(
                _isSaving ? 'Enregistrement...' : 'Enregistrer',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtres
                _buildFilters(),
                
                // Stats rapides
                _buildStats(),
                
                // Liste des athlètes
                Expanded(child: _buildAthletesList()),
              ],
            ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date et période
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Bouton calendrier édition
              InkWell(
                onTap: _openCalendarEditor,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit_calendar, size: 20, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              // Sélecteur de période
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PeriodeType>(
                    value: _periodeType,
                    items: const [
                      DropdownMenuItem(value: PeriodeType.jour, child: Text('Jour')),
                      DropdownMenuItem(value: PeriodeType.semaine, child: Text('Sem.')),
                      DropdownMenuItem(value: PeriodeType.mois, child: Text('Mois')),
                      DropdownMenuItem(value: PeriodeType.trimestre, child: Text('Trim.')),
                      DropdownMenuItem(value: PeriodeType.annee, child: Text('Année')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _periodeType = value);
                        _loadPresenceStats();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Discipline
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<DisciplineModel>(
                value: _selectedDiscipline,
                hint: const Text('Sélectionner une discipline'),
                isExpanded: true,
                items: _disciplines.map((d) => DropdownMenuItem(
                  value: d,
                  child: Text(d.nom),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDiscipline = value;
                    // Réinitialiser les présences
                    _presenceStatus = {for (var a in _athletes) a.id: false};
                  });
                  _loadPresenceStats();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    // Calculer les stats basées sur le calendrier (présences/absences par période)
    final dates = _getPeriodeDates();
    final debut = dates['debut']!;
    final fin = dates['fin']!;
    
    // Compter les jours de présence et absence dans la période
    int nbPresenceDays = 0;
    int nbAbsenceDays = 0;
    
    for (var date in _presenceDates) {
      if (!date.isBefore(debut) && !date.isAfter(fin)) {
        nbPresenceDays++;
      }
    }
    for (var date in _absenceDates) {
      if (!date.isBefore(debut) && !date.isAfter(fin)) {
        nbAbsenceDays++;
      }
    }
    
    final totalDays = nbPresenceDays + nbAbsenceDays;
    final taux = totalDays > 0 ? (nbPresenceDays / totalDays * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: [
          _StatChip(
            icon: Icons.calendar_month,
            label: 'Jours',
            value: '$totalDays',
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          _StatChip(
            icon: Icons.check_circle,
            label: 'Présents',
            value: '$nbPresenceDays',
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          _StatChip(
            icon: Icons.cancel,
            label: 'Absents',
            value: '$nbAbsenceDays',
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          _StatChip(
            icon: Icons.percent,
            label: 'Taux',
            value: '${taux.toStringAsFixed(0)}%',
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildAthletesList() {
    final filtered = _filteredAthletes;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              _selectedDiscipline == null
                  ? 'Sélectionnez une discipline'
                  : 'Aucun athlète dans cette discipline',
              style: TextStyle(color: AppColors.grey600),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Actions rapides
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
          child: Row(
            children: [
              Text(
                '${filtered.length} athlètes',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _selectAll(true),
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text('Tous présents'),
                style: TextButton.styleFrom(foregroundColor: AppColors.success),
              ),
              TextButton.icon(
                onPressed: () => _selectAll(false),
                icon: const Icon(Icons.cancel, size: 18),
                label: const Text('Tous absents'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
        ),
        
        // Liste
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final athlete = filtered[index];
              final isPresent = _presenceStatus[athlete.id] ?? false;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPresent
                        ? AppColors.success.withOpacity(0.2)
                        : AppColors.grey200,
                    child: Text(
                      '${athlete.prenom[0]}${athlete.nom[0]}',
                      style: TextStyle(
                        color: isPresent ? AppColors.success : AppColors.grey600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    athlete.nomComplet,
                    style: TextStyle(
                      fontWeight: isPresent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    athlete.categorieAge?.name.toUpperCase() ?? '',
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: isPresent,
                      onChanged: (_) => _togglePresence(athlete.id),
                      activeColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  onTap: () => _togglePresence(athlete.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    // Ouvrir le calendrier interactif avec les présences marquées
    final result = await showPresenceCalendarDialog(
      context: context,
      initialDate: _selectedDate,
      presenceDates: _presenceDates,
      absenceDates: _absenceDates,
      allowEditing: false, // Mode visualisation seulement pour sélection de date
    );
    
    if (result != null && result['date'] != null) {
      setState(() => _selectedDate = result['date'] as DateTime);
      _loadPresenceStats();
    }
  }

  /// Ouvrir le calendrier en mode édition pour marquer les présences/absences
  Future<void> _openCalendarEditor() async {
    if (_selectedDiscipline == null) {
      OBDSnackBar.warning(context, 'Sélectionnez d\'abord une discipline');
      return;
    }

    final result = await showPresenceCalendarDialog(
      context: context,
      initialDate: _selectedDate,
      presenceDates: _presenceDates,
      absenceDates: _absenceDates,
      allowEditing: true, // Mode édition pour marquer les jours
    );

    if (result != null) {
      final newPresenceDates = result['presenceDates'] as Set<DateTime>;
      final newAbsenceDates = result['absenceDates'] as Set<DateTime>;
      
      // Sauvegarder les modifications
      await _saveCalendarChanges(newPresenceDates, newAbsenceDates);
    }
  }

  Future<void> _saveCalendarChanges(
    Set<DateTime> newPresenceDates,
    Set<DateTime> newAbsenceDates,
  ) async {
    setState(() => _isSaving = true);

    // Trouver les dates modifiées
    final allDates = {...newPresenceDates, ...newAbsenceDates};
    final presences = <Map<String, dynamic>>[];

    for (var date in allDates) {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final isPresent = newPresenceDates.contains(date);
      
      // Pour chaque athlète de la discipline
      for (var athlete in _filteredAthletes) {
        presences.add({
          'athlete_id': athlete.id,
          'discipline_id': _selectedDiscipline!.id,
          'date': dateStr,
          'present': isPresent,
        });
      }
    }

    if (presences.isNotEmpty) {
      final bloc = sl<PresenceBloc>();
      bloc.add(PresencePointageMasseRequested(presences));
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    // Mettre à jour les données locales et forcer le rafraîchissement
    if (mounted) {
      setState(() {
        _presenceDates = Set<DateTime>.from(newPresenceDates);
        _absenceDates = Set<DateTime>.from(newAbsenceDates);
        _isSaving = false;
      });
      
      // Afficher le message de succès
      OBDSnackBar.success(context, 'Présences enregistrées');
      
      // Debug: afficher les stats
      debugPrint('=== Stats mises à jour ===');
      debugPrint('Présences: ${_presenceDates.length} jours');
      debugPrint('Absences: ${_absenceDates.length} jours');
    }
  }

  String _formatDate(DateTime date) {
    return _formatPeriodeLabel();
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
