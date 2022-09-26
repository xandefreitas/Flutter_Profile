import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color color;
  final int maxLines;
  final int? maxLength;
  final Function(String?)? onSaved;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;
  const CustomFormField({
    required this.label,
    required this.controller,
    required this.color,
    this.maxLines = 1,
    this.maxLength,
    this.onSaved,
    this.onChanged,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      cursorColor: color,
      decoration: InputDecoration(
        label: Text(label),
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: color),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
          ),
        ),
      ),
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
