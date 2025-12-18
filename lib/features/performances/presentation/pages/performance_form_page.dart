import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/widgets.dart';

/// Page de création d'une évaluation de performance
class PerformanceFormPage extends StatefulWidget {
  final int? athleteId;

  const PerformanceFormPage({
    super.key,
    this.athleteId,
  });

  @override
  State<PerformanceFormPage> createState() => _PerformanceFormPageState();
}

class _PerformanceFormPageState extends State<PerformanceFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Contrôleurs
  final _observationsController = TextEditingController();
  final _competitionController = TextEditingController();
  final _adversaireController = TextEditingController();
  final _lieuController = TextEditingController();

  // Valeurs
  int? _athleteId;
  int? _disciplineId;
  String _contexte = 'entrainement';
  DateTime _dateEvaluation = DateTime.now();
  int _notePhysique = 10;
  int _noteTechnique = 10;
  int _noteComportement = 10;
  String? _resultatMatch;
  int? _pointsMarques;
  int? _pointsEncaisses;
  int? _classement;
  String? _medaille;

  // Données de démonstration
  final List<Map<String, dynamic>> _athletes = [
    {'id': 1, 'nom': 'Amadou Konaté'},
    {'id': 2, 'nom': 'Fatou Diallo'},
    {'id': 3, 'nom': 'Moussa Traoré'},
    {'id': 4, 'nom': 'Awa Keita'},
  ];

  final List<Map<String, dynamic>> _disciplines = [
    {'id': 1, 'nom': 'Basket'},
    {'id': 2, 'nom': 'Volley'},
    {'id': 3, 'nom': 'Taekwondo'},
  ];

  @override
  void initState() {
    super.initState();
    _athleteId = widget.athleteId;
  }

  @override
  void dispose() {
    _observationsController.dispose();
    _competitionController.dispose();
    _adversaireController.dispose();
    _lieuController.dispose();
    super.dispose();
  }

  double get _noteGlobale =>
      (_notePhysique + _noteTechnique + _noteComportement) / 3;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_athleteId == null) {
      OBDSnackBar.error(context, 'Sélectionnez un athlète');
      return;
    }

    if (_disciplineId == null) {
      OBDSnackBar.error(context, 'Sélectionnez une discipline');
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Envoyer les données à l'API
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    OBDSnackBar.success(context, 'Évaluation enregistrée avec succès');
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle évaluation'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sélection athlète et discipline
              Row(
                children: [
                  Expanded(
                    child: OBDDropdown<int>(
                      value: _athleteId,
                      label: 'Athlète',
                      items: _athletes.map((a) {
                        return DropdownMenuItem<int>(
                          value: a['id'] as int,
                          child: Text(a['nom'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _athleteId = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OBDDropdown<int>(
                      value: _disciplineId,
                      label: 'Discipline',
                      items: _disciplines.map((d) {
                        return DropdownMenuItem<int>(
                          value: d['id'] as int,
                          child: Text(d['nom'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _disciplineId = value);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Date
              OBDDatePicker(
                value: _dateEvaluation,
                label: 'Date d\'évaluation',
                lastDate: DateTime.now(),
                onChanged: (date) {
                  setState(() => _dateEvaluation = date);
                },
              ),

              const SizedBox(height: 24),

              // Contexte
              Text(
                'Contexte',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ContexteChip(
                    label: 'Entraînement',
                    icon: Icons.fitness_center,
                    selected: _contexte == 'entrainement',
                    onTap: () => setState(() => _contexte = 'entrainement'),
                  ),
                  _ContexteChip(
                    label: 'Match',
                    icon: Icons.sports,
                    selected: _contexte == 'match',
                    onTap: () => setState(() => _contexte = 'match'),
                  ),
                  _ContexteChip(
                    label: 'Compétition',
                    icon: Icons.emoji_events,
                    selected: _contexte == 'competition',
                    onTap: () => setState(() => _contexte = 'competition'),
                  ),
                  _ContexteChip(
                    label: 'Test physique',
                    icon: Icons.timer,
                    selected: _contexte == 'test_physique',
                    onTap: () => setState(() => _contexte = 'test_physique'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Champs spécifiques selon contexte
              if (_contexte == 'match') ...[
                _buildMatchFields(),
              ] else if (_contexte == 'competition') ...[
                _buildCompetitionFields(),
              ],

              // Notes
              Text(
                'Notes (sur 20)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),

              _NoteSlider(
                label: 'Note physique',
                value: _notePhysique,
                onChanged: (value) => setState(() => _notePhysique = value),
              ),

              _NoteSlider(
                label: 'Note technique',
                value: _noteTechnique,
                onChanged: (value) => setState(() => _noteTechnique = value),
              ),

              _NoteSlider(
                label: 'Note comportement',
                value: _noteComportement,
                onChanged: (value) => setState(() => _noteComportement = value),
              ),

              const SizedBox(height: 16),

              // Note globale
              OBDCard(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Note globale: ${_noteGlobale.toStringAsFixed(1)}/20',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Observations
              OBDTextField(
                controller: _observationsController,
                label: 'Observations',
                hint: 'Points forts, axes d\'amélioration...',
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              // Boutons
              OBDPrimaryButton(
                text: 'Enregistrer l\'évaluation',
                onPressed: _submit,
                isLoading: _isLoading,
                icon: Icons.check,
              ),

              const SizedBox(height: 12),

              OBDOutlinedButton(
                text: 'Annuler',
                onPressed: () => context.pop(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OBDTextField(
          controller: _adversaireController,
          label: 'Adversaire',
          prefixIcon: Icons.groups,
        ),

        const SizedBox(height: 16),

        Text(
          'Résultat',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ResultatButton(
                label: 'Victoire',
                color: AppColors.success,
                selected: _resultatMatch == 'victoire',
                onTap: () => setState(() => _resultatMatch = 'victoire'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ResultatButton(
                label: 'Nul',
                color: AppColors.grey500,
                selected: _resultatMatch == 'nul',
                onTap: () => setState(() => _resultatMatch = 'nul'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ResultatButton(
                label: 'Défaite',
                color: AppColors.error,
                selected: _resultatMatch == 'defaite',
                onTap: () => setState(() => _resultatMatch = 'defaite'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCompetitionFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OBDTextField(
          controller: _competitionController,
          label: 'Nom de la compétition',
          prefixIcon: Icons.emoji_events,
        ),

        const SizedBox(height: 16),

        OBDTextField(
          controller: _lieuController,
          label: 'Lieu',
          prefixIcon: Icons.location_on,
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OBDDropdown<int>(
                value: _classement,
                label: 'Classement',
                items: List.generate(10, (i) {
                  return DropdownMenuItem<int>(
                    value: i + 1,
                    child: Text('${i + 1}${i == 0 ? 'er' : 'ème'}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _classement = value;
                    if (value == 1) _medaille = 'or';
                    else if (value == 2) _medaille = 'argent';
                    else if (value == 3) _medaille = 'bronze';
                    else _medaille = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OBDDropdown<String>(
                value: _medaille,
                label: 'Médaille',
                items: const [
                  DropdownMenuItem(value: 'or', child: Text('🥇 Or')),
                  DropdownMenuItem(value: 'argent', child: Text('🥈 Argent')),
                  DropdownMenuItem(value: 'bronze', child: Text('🥉 Bronze')),
                ],
                onChanged: (value) {
                  setState(() => _medaille = value);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

class _ContexteChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ContexteChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteSlider extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _NoteSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getColor(value).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: Text(
                '$value/20',
                style: TextStyle(
                  color: _getColor(value),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 20,
          divisions: 20,
          activeColor: _getColor(value),
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }

  Color _getColor(int note) {
    if (note >= 16) return AppColors.success;
    if (note >= 14) return AppColors.primary;
    if (note >= 10) return AppColors.warning;
    return AppColors.error;
  }
}

class _ResultatButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ResultatButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
          border: Border.all(color: color),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
