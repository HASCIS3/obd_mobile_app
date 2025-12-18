import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Champ de texte standard OBD
class OBDTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;

  const OBDTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Champ de recherche OBD
class OBDSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;

  const OBDSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted?.call(),
      decoration: InputDecoration(
        hintText: hint ?? 'Rechercher...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
      ),
    );
  }
}

/// Sélecteur dropdown OBD
class OBDDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final bool enabled;

  const OBDDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
    );
  }
}

/// Sélecteur de date OBD
class OBDDatePicker extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final String? label;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  const OBDDatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: firstDate ?? DateTime(1900),
                lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                onChanged?.call(date);
              }
            }
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null
              ? '${value!.day.toString().padLeft(2, '0')}/${value!.month.toString().padLeft(2, '0')}/${value!.year}'
              : hint ?? 'Sélectionner une date',
          style: value != null
              ? Theme.of(context).textTheme.bodyLarge
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textHint,
                  ),
        ),
      ),
    );
  }
}
