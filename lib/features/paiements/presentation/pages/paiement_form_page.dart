import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/athlete_model.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../athletes/domain/repositories/athlete_repository.dart';
import '../bloc/paiement_bloc.dart';

/// Page de création d'un paiement
class PaiementFormPage extends StatefulWidget {
  final int? athleteId;

  const PaiementFormPage({
    super.key,
    this.athleteId,
  });

  @override
  State<PaiementFormPage> createState() => _PaiementFormPageState();
}

class _PaiementFormPageState extends State<PaiementFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Contrôleurs
  final _inscriptionController = TextEditingController(text: '5000');
  final _equipementController = TextEditingController();
  final _cotisationController = TextEditingController(text: '2000');
  final _referenceController = TextEditingController();
  final _remarqueController = TextEditingController();

  // Valeurs
  int? _athleteId;
  String _typePaiement = 'premiere_inscription'; // premiere_inscription ou cotisation
  String _modePaiement = 'especes';
  int _mois = DateTime.now().month;
  int _annee = DateTime.now().year;
  DateTime _datePaiement = DateTime.now();
  
  // Pour première inscription
  String? _selectedDiscipline;
  
  // Équipements par discipline
  final Map<String, List<Map<String, dynamic>>> _equipementsParDiscipline = {
    'taekwondo': [
      {'id': 'dobok_cadet', 'nom': 'Dobok Cadet (5000-6000F)', 'prix': 5500},
      {'id': 'dobok_junior', 'nom': 'Dobok Junior (6000-7000F)', 'prix': 6500},
      {'id': 'dobok_senior', 'nom': 'Dobok Senior (8000-10000F)', 'prix': 9000},
    ],
    'basketball': [
      {'id': 'pack_basket', 'nom': 'Pack Ballon + Maillot', 'prix': 15000},
    ],
    'volleyball': [
      {'id': 'pack_volley', 'nom': 'Équipement complet', 'prix': 10000},
    ],
  };

  // Athlètes disponibles
  List<AthleteModel> _athletes = [];
  bool _loadingAthletes = true;

  @override
  void initState() {
    super.initState();
    _athleteId = widget.athleteId;
    _loadAthletes();
  }

  Future<void> _loadAthletes() async {
    final repository = sl<AthleteRepository>();
    final result = await repository.getAthletes(actif: true);
    
    result.fold(
      (failure) {
        if (mounted) {
          OBDSnackBar.error(context, 'Erreur: ${failure.message}');
        }
      },
      (athletes) {
        if (mounted) {
          setState(() {
            _athletes = athletes;
            _loadingAthletes = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _inscriptionController.dispose();
    _equipementController.dispose();
    _cotisationController.dispose();
    _referenceController.dispose();
    _remarqueController.dispose();
    super.dispose();
  }

  int get _montantInscription {
    return int.tryParse(_inscriptionController.text) ?? 0;
  }

  int get _montantEquipement {
    return int.tryParse(_equipementController.text) ?? 0;
  }

  int get _montantCotisation {
    return int.tryParse(_cotisationController.text) ?? 2000;
  }

  int get _montantTotal {
    if (_typePaiement == 'premiere_inscription') {
      return _montantInscription + _montantEquipement;
    } else {
      return _montantCotisation;
    }
  }
  
  String _getDisciplineKey(String disciplineName) {
    final name = disciplineName.toLowerCase();
    if (name.contains('taekwondo') || name.contains('tkd')) return 'taekwondo';
    if (name.contains('basket')) return 'basketball';
    if (name.contains('volley')) return 'volleyball';
    return 'autre';
  }

  List<dynamic> _getAthleteDisciplines() {
    if (_athleteId == null || _athletes.isEmpty) return [];
    final athlete = _athletes.firstWhere(
      (a) => a.id == _athleteId,
      orElse: () => _athletes.first,
    );
    return athlete.disciplines ?? [];
  }
  
  List<Map<String, dynamic>> _getEquipementsForSelectedDiscipline() {
    if (_selectedDiscipline == null) return [];
    return _equipementsParDiscipline[_selectedDiscipline] ?? [];
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_athleteId == null) {
      OBDSnackBar.error(context, 'Sélectionnez un athlète');
      return;
    }
    
    if (_typePaiement == 'premiere_inscription') {
      if (_selectedDiscipline == null) {
        OBDSnackBar.error(context, 'Sélectionnez une discipline');
        return;
      }
      if (_montantInscription <= 0) {
        OBDSnackBar.error(context, 'Saisissez le montant de l\'inscription');
        return;
      }
      if (_montantEquipement <= 0) {
        OBDSnackBar.error(context, 'Saisissez le montant de l\'équipement');
        return;
      }
    }

    setState(() => _isLoading = true);

    final dateStr = '${_datePaiement.year}-${_datePaiement.month.toString().padLeft(2, '0')}-${_datePaiement.day.toString().padLeft(2, '0')}';
    
    final data = {
      'athlete_id': _athleteId,
      'type_paiement': _typePaiement == 'premiere_inscription' ? 'inscription' : 'cotisation',
      'montant': _montantTotal.toDouble(),
      'mode_paiement': _modePaiement,
      'date_paiement': dateStr,
      if (_typePaiement == 'cotisation') 'mois': _mois,
      if (_typePaiement == 'cotisation') 'annee': _annee,
      if (_typePaiement == 'premiere_inscription') 'frais_inscription': _montantInscription,
      if (_typePaiement == 'premiere_inscription') 'frais_equipement': _montantEquipement,
      if (_typePaiement == 'premiere_inscription' && _selectedDiscipline != null) 'discipline': _selectedDiscipline,
      if (_referenceController.text.isNotEmpty) 'reference': _referenceController.text,
      if (_remarqueController.text.isNotEmpty) 'remarque': _remarqueController.text,
    };

    final bloc = sl<PaiementBloc>();
    bloc.add(PaiementCreateRequested(data));

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() => _isLoading = false);

    OBDSnackBar.success(context, 'Paiement enregistré avec succès');
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau paiement'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sélection athlète
              _loadingAthletes
                  ? const Center(child: CircularProgressIndicator())
                  : OBDDropdown<int>(
                      value: _athleteId,
                      label: 'Athlète',
                      prefixIcon: Icons.person_outline,
                      items: _athletes.map((athlete) {
                        return DropdownMenuItem<int>(
                          value: athlete.id,
                          child: Text(athlete.nomComplet),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _athleteId = value;
                          _selectedDiscipline = null;
                          _equipementController.clear();
                        });
                      },
                    ),

              const SizedBox(height: 20),

              // Type de paiement
              Text(
                'Type de paiement',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TypeCard(
                      title: '1ère Inscription',
                      subtitle: 'Inscription + Équipement',
                      icon: Icons.person_add,
                      selected: _typePaiement == 'premiere_inscription',
                      onTap: () {
                        setState(() {
                          _typePaiement = 'premiere_inscription';
                          _selectedDiscipline = null;
                          _equipementController.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCard(
                      title: 'Cotisation',
                      subtitle: '2000 FCFA/mois',
                      icon: Icons.calendar_month,
                      selected: _typePaiement == 'cotisation',
                      onTap: () {
                        setState(() {
                          _typePaiement = 'cotisation';
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Contenu selon le type
              if (_typePaiement == 'premiere_inscription') ...[
                _buildPremiereInscriptionForm(),
              ] else ...[
                _buildCotisationForm(),
              ],

              const SizedBox(height: 20),

              // Mode de paiement
              Text(
                'Mode de paiement',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ModeChip(
                      label: 'Espèces',
                      icon: Icons.money,
                      selected: _modePaiement == 'especes',
                      onTap: () => setState(() => _modePaiement = 'especes'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ModeChip(
                      label: 'Mobile Money',
                      icon: Icons.phone_android,
                      selected: _modePaiement == 'mobile_money',
                      onTap: () => setState(() => _modePaiement = 'mobile_money'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ModeChip(
                      label: 'Virement',
                      icon: Icons.account_balance,
                      selected: _modePaiement == 'virement',
                      onTap: () => setState(() => _modePaiement = 'virement'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Date de paiement
              OBDDatePicker(
                value: _datePaiement,
                label: 'Date de paiement',
                lastDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 1),
                onChanged: (date) {
                  setState(() => _datePaiement = date);
                },
              ),

              const SizedBox(height: 16),

              // Référence
              OBDTextField(
                controller: _referenceController,
                label: 'Référence (optionnel)',
                prefixIcon: Icons.tag,
                hint: 'Ex: Reçu n°123',
              ),

              const SizedBox(height: 16),

              // Remarque
              OBDTextField(
                controller: _remarqueController,
                label: 'Remarque (optionnel)',
                prefixIcon: Icons.note,
                maxLines: 2,
              ),

              const SizedBox(height: 24),

              // Résumé du paiement
              _buildResume(),

              const SizedBox(height: 24),

              // Bouton enregistrer
              OBDPrimaryButton(
                text: 'Enregistrer le paiement',
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

  Widget _buildPremiereInscriptionForm() {
    final disciplines = _getAthleteDisciplines();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.info.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.info, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Première inscription',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.info),
                    ),
                    Text(
                      'Inscription + Équipement = Total automatique',
                      style: TextStyle(fontSize: 12, color: AppColors.info),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Étape 1: Choisir la discipline
        Text(
          '1. Choisir la discipline',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        
        if (_athleteId == null)
          Text('Sélectionnez d\'abord un athlète', style: TextStyle(color: AppColors.grey600))
        else if (disciplines.isEmpty)
          Text('Aucune discipline trouvée', style: TextStyle(color: AppColors.grey600))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: disciplines.map((discipline) {
              final key = _getDisciplineKey(discipline.nom);
              final isSelected = _selectedDiscipline == key;
              return ChoiceChip(
                label: Text(discipline.nom),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedDiscipline = selected ? key : null;
                    // Pré-remplir le montant équipement suggéré
                    if (selected) {
                      final equipements = _equipementsParDiscipline[key];
                      if (equipements != null && equipements.isNotEmpty) {
                        _equipementController.text = equipements.first['prix'].toString();
                      }
                    } else {
                      _equipementController.clear();
                    }
                  });
                },
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        
        const SizedBox(height: 20),
        
        // Étape 2: Montant inscription
        Text(
          '2. Montant inscription (FCFA)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        OBDTextField(
          controller: _inscriptionController,
          label: 'Frais d\'inscription',
          prefixIcon: Icons.person_add,
          keyboardType: TextInputType.number,
          hint: 'Ex: 5000',
          onChanged: (value) => setState(() {}),
        ),
        
        const SizedBox(height: 16),
        
        // Étape 3: Montant équipement
        Text(
          '3. Montant équipement (FCFA)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        OBDTextField(
          controller: _equipementController,
          label: 'Frais d\'équipement',
          prefixIcon: Icons.sports,
          keyboardType: TextInputType.number,
          hint: 'Ex: 15000',
          onChanged: (value) => setState(() {}),
        ),
        
        const SizedBox(height: 16),
        
        // Tarifs info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarifs de référence:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Text('• Inscription: 5 000 FCFA (toutes disciplines)', style: TextStyle(fontSize: 11, color: AppColors.grey700)),
              const SizedBox(height: 2),
              Text('• Taekwondo: Cadet 5000-6000F, Junior 6000-7000F, Senior 8000-10000F', style: TextStyle(fontSize: 11, color: AppColors.grey700)),
              Text('• Basketball: Pack (Ballon + Maillot) = 15 000F', style: TextStyle(fontSize: 11, color: AppColors.grey700)),
              Text('• Volleyball: Équipement complet = 10 000F', style: TextStyle(fontSize: 11, color: AppColors.grey700)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCotisationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.success, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cotisation mensuelle',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                    Text(
                      'Tarif de référence: 2000 FCFA par mois',
                      style: TextStyle(fontSize: 12, color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Sélection du mois
        Row(
          children: [
            Expanded(
              child: OBDDropdown<int>(
                value: _mois,
                label: 'Mois',
                items: List.generate(12, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text(AppStrings.mois[index]),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _mois = value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OBDDropdown<int>(
                value: _annee,
                label: 'Année',
                items: List.generate(3, (index) {
                  final year = DateTime.now().year - 1 + index;
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _annee = value);
                  }
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Montant cotisation
        OBDTextField(
          controller: _cotisationController,
          label: 'Montant cotisation (FCFA)',
          prefixIcon: Icons.payment,
          keyboardType: TextInputType.number,
          hint: 'Ex: 2000',
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildResume() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Résumé du paiement',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
              ),
            ],
          ),
          const Divider(height: 24),
          
          _ResumeRow(
            label: 'Athlète',
            value: _athleteId != null && _athletes.isNotEmpty
                ? _athletes.firstWhere((a) => a.id == _athleteId, orElse: () => _athletes.first).nomComplet
                : '-',
          ),
          
          _ResumeRow(
            label: 'Type',
            value: _typePaiement == 'premiere_inscription' ? '1ère Inscription' : 'Cotisation mensuelle',
          ),
          
          if (_typePaiement == 'premiere_inscription') ...[
            _ResumeRow(label: 'Inscription', value: '${_formatMoney(_montantInscription)} F'),
            _ResumeRow(label: 'Équipement', value: '${_formatMoney(_montantEquipement)} F'),
          ] else ...[
            _ResumeRow(label: 'Période', value: '${AppStrings.mois[_mois - 1]} $_annee'),
          ],
          
          const Divider(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL À PAYER',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${_formatMoney(_montantTotal)} FCFA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary.withOpacity(0.2) : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? AppColors.secondaryDark : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.secondaryDark : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.grey300,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: selected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: selected ? Colors.white70 : AppColors.grey600,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary.withOpacity(0.15) : AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.grey300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? AppColors.secondary : AppColors.grey600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.secondary : AppColors.grey700,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResumeRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.grey600, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
