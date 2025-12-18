import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/widgets.dart';

/// Page de création/édition d'un athlète
class AthleteFormPage extends StatefulWidget {
  final int? athleteId;

  const AthleteFormPage({
    super.key,
    this.athleteId,
  });

  bool get isEditing => athleteId != null;

  @override
  State<AthleteFormPage> createState() => _AthleteFormPageState();
}

class _AthleteFormPageState extends State<AthleteFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Contrôleurs
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseController = TextEditingController();
  final _nomTuteurController = TextEditingController();
  final _telephoneTuteurController = TextEditingController();

  // Valeurs
  DateTime? _dateNaissance;
  String _sexe = 'M';
  List<int> _disciplinesSelectionnees = [];
  bool _actif = true;

  // Disciplines disponibles (à charger depuis l'API)
  final List<Map<String, dynamic>> _disciplines = [
    {'id': 1, 'nom': 'Basket', 'tarif': 15000},
    {'id': 2, 'nom': 'Volley', 'tarif': 12000},
    {'id': 3, 'nom': 'Taekwondo', 'tarif': 10000},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadAthlete();
    }
  }

  Future<void> _loadAthlete() async {
    // TODO: Charger les données de l'athlète depuis l'API
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    // Données de démonstration
    _nomController.text = 'Konaté';
    _prenomController.text = 'Amadou';
    _telephoneController.text = '+223 76 12 34 56';
    _emailController.text = 'amadou@email.com';
    _adresseController.text = 'Bamako';
    _nomTuteurController.text = 'Mamadou Konaté';
    _telephoneTuteurController.text = '+223 66 78 90 12';
    _dateNaissance = DateTime(2008, 5, 15);
    _sexe = 'M';
    _disciplinesSelectionnees = [1];
    _actif = true;

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    _nomTuteurController.dispose();
    _telephoneTuteurController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_disciplinesSelectionnees.isEmpty) {
      OBDSnackBar.error(context, 'Sélectionnez au moins une discipline');
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Envoyer les données à l'API
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    OBDSnackBar.success(
      context,
      widget.isEditing ? 'Athlète modifié avec succès' : 'Athlète créé avec succès',
    );

    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier l\'athlète' : 'Nouvel athlète'),
      ),
      body: _isLoading && widget.isEditing
          ? const OBDLoading(message: 'Chargement...')
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section Identité
                    _buildSectionTitle('Identité'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: OBDTextField(
                            controller: _prenomController,
                            label: AppStrings.prenom,
                            prefixIcon: Icons.person_outline,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.errorRequired;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OBDTextField(
                            controller: _nomController,
                            label: AppStrings.nom,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.errorRequired;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OBDDatePicker(
                            value: _dateNaissance,
                            label: AppStrings.dateNaissance,
                            lastDate: DateTime.now(),
                            firstDate: DateTime(1980),
                            onChanged: (date) {
                              setState(() => _dateNaissance = date);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.sexe,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _SexeButton(
                                      label: 'Masculin',
                                      icon: Icons.male,
                                      selected: _sexe == 'M',
                                      onTap: () => setState(() => _sexe = 'M'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _SexeButton(
                                      label: 'Féminin',
                                      icon: Icons.female,
                                      selected: _sexe == 'F',
                                      onTap: () => setState(() => _sexe = 'F'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Contact
                    _buildSectionTitle('Contact'),
                    const SizedBox(height: 12),

                    OBDTextField(
                      controller: _telephoneController,
                      label: AppStrings.telephone,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    OBDTextField(
                      controller: _emailController,
                      label: AppStrings.email,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    OBDTextField(
                      controller: _adresseController,
                      label: AppStrings.adresse,
                      prefixIcon: Icons.location_on_outlined,
                      textInputAction: TextInputAction.next,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 24),

                    // Section Tuteur
                    _buildSectionTitle('Tuteur (si mineur)'),
                    const SizedBox(height: 12),

                    OBDTextField(
                      controller: _nomTuteurController,
                      label: AppStrings.tuteur,
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    OBDTextField(
                      controller: _telephoneTuteurController,
                      label: AppStrings.telephoneTuteur,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 24),

                    // Section Disciplines
                    _buildSectionTitle('Disciplines'),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _disciplines.map((discipline) {
                        final isSelected = _disciplinesSelectionnees.contains(discipline['id']);
                        return FilterChip(
                          label: Text('${discipline['nom']} (${discipline['tarif']} FCFA)'),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _disciplinesSelectionnees.add(discipline['id'] as int);
                              } else {
                                _disciplinesSelectionnees.remove(discipline['id']);
                              }
                            });
                          },
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),

                    if (_disciplinesSelectionnees.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      OBDInfoCard(
                        title: 'Tarif mensuel total',
                        message: '${_calculateTotalTarif()} FCFA/mois',
                        icon: Icons.payment,
                        color: AppColors.primary,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Statut actif
                    SwitchListTile(
                      title: const Text('Athlète actif'),
                      subtitle: Text(
                        _actif ? 'L\'athlète peut participer aux activités' : 'L\'athlète est inactif',
                      ),
                      value: _actif,
                      onChanged: (value) => setState(() => _actif = value),
                      activeColor: AppColors.primary,
                    ),

                    const SizedBox(height: 32),

                    // Boutons
                    OBDPrimaryButton(
                      text: widget.isEditing ? 'Enregistrer les modifications' : 'Créer l\'athlète',
                      onPressed: _submit,
                      isLoading: _isLoading,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  int _calculateTotalTarif() {
    int total = 0;
    for (final discipline in _disciplines) {
      if (_disciplinesSelectionnees.contains(discipline['id'])) {
        total += discipline['tarif'] as int;
      }
    }
    return total;
  }
}

class _SexeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SexeButton({
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
