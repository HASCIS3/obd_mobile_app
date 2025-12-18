import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Page détail d'un athlète
class AthleteDetailPage extends StatelessWidget {
  final int athleteId;

  const AthleteDetailPage({
    super.key,
    required this.athleteId,
  });

  @override
  Widget build(BuildContext context) {
    // Données de démonstration
    final athlete = {
      'id': athleteId,
      'nom': 'Konaté',
      'prenom': 'Amadou',
      'categorie': 'Cadet',
      'age': 16,
      'sexe': 'M',
      'telephone': '+223 76 12 34 56',
      'email': 'amadou.konate@email.com',
      'adresse': 'Bamako, Quartier du Fleuve',
      'nomTuteur': 'Mamadou Konaté',
      'telephoneTuteur': '+223 66 78 90 12',
      'discipline': 'Basket',
      'tarifMensuel': 15000,
      'dateInscription': '2023-09-01',
      'actif': true,
      'tauxPresence': 85.0,
      'arrieres': 0,
      'noteMoyenne': 14.5,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Athlète'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigation vers édition
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'presences',
                child: Text('Voir présences'),
              ),
              const PopupMenuItem(
                value: 'paiements',
                child: Text('Voir paiements'),
              ),
              const PopupMenuItem(
                value: 'performances',
                child: Text('Voir performances'),
              ),
            ],
            onSelected: (value) {
              // TODO: Navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            // En-tête avec photo
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      '${athlete['prenom'].toString()[0]}${athlete['nom'].toString()[0]}',
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${athlete['prenom']} ${athlete['nom']}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${athlete['categorie']} • ${athlete['age']} ans',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '✓ Actif',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Informations de contact
            _InfoSection(
              title: 'Contact',
              children: [
                _InfoRow(
                  icon: Icons.phone,
                  label: 'Téléphone',
                  value: athlete['telephone'] as String,
                ),
                _InfoRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: athlete['email'] as String,
                ),
                _InfoRow(
                  icon: Icons.location_on,
                  label: 'Adresse',
                  value: athlete['adresse'] as String,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tuteur
            _InfoSection(
              title: 'Tuteur',
              children: [
                _InfoRow(
                  icon: Icons.person,
                  label: 'Nom',
                  value: athlete['nomTuteur'] as String,
                ),
                _InfoRow(
                  icon: Icons.phone,
                  label: 'Téléphone',
                  value: athlete['telephoneTuteur'] as String,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Discipline
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.sports_basketball, color: AppColors.primary),
                ),
                title: Text(athlete['discipline'] as String),
                subtitle: Text('${athlete['tarifMensuel']} FCFA/mois'),
                trailing: Text(
                  'Depuis 2023',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Statistiques
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '${athlete['tauxPresence']}%',
                    label: 'Présence',
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    value: '${athlete['arrieres']} FCFA',
                    label: 'Arriérés',
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    value: '${athlete['noteMoyenne']}/20',
                    label: 'Note moy.',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Voir présences
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Présences'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Voir paiements
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Paiements'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Voir performances
                },
                icon: const Icon(Icons.trending_up),
                label: const Text('Voir les performances'),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
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
