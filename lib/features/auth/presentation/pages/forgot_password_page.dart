import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

/// Page de récupération de mot de passe
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implémenter la logique avec Bloc
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.forgotPassword),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),

          // Icône
          const Icon(
            Icons.lock_reset,
            size: 80,
            color: AppColors.primary,
          ),

          const SizedBox(height: 32),

          // Description
          Text(
            'Entrez votre adresse email pour recevoir un lien de réinitialisation de mot de passe.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _sendResetLink(),
            decoration: const InputDecoration(
              labelText: AppStrings.email,
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.errorRequired;
              }
              if (!value.contains('@')) {
                return AppStrings.errorInvalidEmail;
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Bouton
          ElevatedButton(
            onPressed: _isLoading ? null : _sendResetLink,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Envoyer le lien'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 64),

        // Icône succès
        const Icon(
          Icons.mark_email_read,
          size: 80,
          color: AppColors.success,
        ),

        const SizedBox(height: 32),

        // Message
        Text(
          'Email envoyé !',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Text(
          'Un email a été envoyé à ${_emailController.text}. Vérifiez votre boîte de réception et suivez les instructions pour réinitialiser votre mot de passe.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Bouton retour
        ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Retour à la connexion'),
        ),
      ],
    );
  }
}
