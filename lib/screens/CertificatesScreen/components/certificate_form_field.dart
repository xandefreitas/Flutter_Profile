import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/app_colors.dart';

class CertificateFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int? maxLength;
  final Function(String)? onChanged;
  const CertificateFormField({
    required this.label,
    required this.controller,
    this.maxLength,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      cursorColor: AppColors.certificatesPrimary,
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(color: AppColors.certificatesPrimary),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.certificatesPrimary,
          ),
        ),
      ),
      onChanged: onChanged,
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.formFieldRequiredMessage;
        }
        return null;
      }),
    );
  }
}
