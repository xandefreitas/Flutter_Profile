import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final String? suffixText;
  final TextInputType? keyBoardType;
  final Function(String?)? onSaved;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;
  const CustomFormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.suffixText,
    this.keyBoardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        label: Text(label),
        isDense: true,
        alignLabelWithHint: true,
        suffixText: suffixText,
      ),
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
