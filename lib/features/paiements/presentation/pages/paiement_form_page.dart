import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/widgets.dart';

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
  final _montantController = TextEditingController();
  final _referenceController = TextEditingController();
  final _remarqueController = TextEditingController();

  // Valeurs
  int? _athleteId;
  String _typePaiement = 'cotisation';
  String _modePaiement = 'especes';
  int _mois = DateTime.now().month;
  int _annee = DateTime.now().year;
  DateTime _datePaiement = DateTime.now();

  // Athlètes disponibles (à charger depuis l'API)
  final List<Map<String, dynamic>> _athletes = [
    {'id': 1, 'nom': 'Amadou Konaté', 'tarif': 15000},
    {'id': 2, 'nom': 'Fatou Diallo', 'tarif': 12000},
    {'id': 3, 'nom': 'Moussa Traoré', 'tarif': 15000},
    {'id': 4, 'nom': 'Awa Keita', 'tarif': 10000},
  ];

  @override
  void initState() {
    super.initState();
    _athleteId = widget.athleteId;
    _updateMontant();
  }

  @override
  void dispose() {
    _montantController.dispose();
    _referenceController.dispose();
    _remarqueController.dispose();
    super.dispose();
  }

  void _updateMontant() {
    if (_typePaiement == 'cotisation' && _athleteId != null) {
      final athlete = _athletes.firstWhere(
        (a) => a['id'] == _athleteId,
        orElse: () => {'tarif': 0},
      );
      _montantController.text = athlete['tarif'].toString();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_athleteId == null) {
      OBDSnackBar.error(context, 'Sélectionnez un athlète');
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Envoyer les données à l'API
    await Future.delayed(const Duration(seconds: 2));

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
              OBDDropdown<int>(
                value: _athleteId,
                label: 'Athlète',
                prefixIcon: Icons.person_outline,
                items: _athletes.map((athlete) {
                  return DropdownMenuItem<int>(
                    value: athlete['id'] as int,
                    child: Text(athlete['nom'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _athleteId = value;
                    _updateMontant();
                  });
                },
              ),

              const SizedBox(height: 16),

              // Type de paiement
              Text(
                'Type de paiement',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TypeButton(
                      label: 'Cotisation',
                      icon: Icons.calendar_month,
                      selected: _typePaiement == 'cotisation',
                      onTap: () {
                        setState(() {
                          _typePaiement = 'cotisation';
                          _updateMontant();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TypeButton(
                      label: 'Inscription',
                      icon: Icons.person_add,
                      selected: _typePaiement == 'inscription',
                      onTap: () {
                        setState(() {
                          _typePaiement = 'inscription';
                          _montantController.text = '25000';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TypeButton(
                      label: 'Équipement',
                      icon: Icons.sports_basketball,
                      selected: _typePaiement == 'equipement',
                      onTap: () {
                        setState(() {
                          _typePaiement = 'equipement';
                          _montantController.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Période (pour cotisation)
              if (_typePaiement == 'cotisation') ...[
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
              ],

              // Montant
              OBDTextField(
                controller: _montantController,
                label: '${AppStrings.montant} (FCFA)',
                prefixIcon: Icons.payment,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.errorRequired;
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Mode de paiement
              Text(
                'Mode de paiement',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _ModeButton(
                      label: 'Espèces',
                      icon: Icons.money,
                      selected: _modePaiement == 'especes',
                      onTap: () => setState(() => _modePaiement = 'especes'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ModeButton(
                      label: 'Mobile Money',
                      icon: Icons.phone_android,
                      selected: _modePaiement == 'mobile_money',
                      onTap: () => setState(() => _modePaiement = 'mobile_money'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ModeButton(
                      label: 'Virement',
                      icon: Icons.account_balance,
                      selected: _modePaiement == 'virement',
                      onTap: () => setState(() => _modePaiement = 'virement'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

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
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Résumé
              OBDCard(
                backgroundColor: AppColors.grey50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résumé du paiement',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Athlète',
                      value: _athleteId != null
                          ? _athletes.firstWhere((a) => a['id'] == _athleteId)['nom'] as String
                          : '-',
                    ),
                    _SummaryRow(
                      label: 'Type',
                      value: _typePaiement == 'cotisation'
                          ? 'Cotisation mensuelle'
                          : _typePaiement == 'inscription'
                              ? 'Frais d\'inscription'
                              : 'Équipement',
                    ),
                    if (_typePaiement == 'cotisation')
                      _SummaryRow(
                        label: 'Période',
                        value: '${AppStrings.mois[_mois - 1]} $_annee',
                      ),
                    _SummaryRow(
                      label: 'Montant',
                      value: '${_montantController.text.isNotEmpty ? _montantController.text : '0'} FCFA',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Boutons
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: isHighlighted
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    )
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
