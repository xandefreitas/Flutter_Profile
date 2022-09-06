import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class CertificateFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  const CertificateFormField({
    required this.label,
    required this.controller,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
