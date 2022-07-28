import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/core.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({
    Key? key,
    required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: text.formHintTextName,
              hintStyle: const TextStyle(color: AppColors.profilePrimary),
              isDense: true,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.name,
            validator: (name) {
              return name!.trim().isEmpty ? text.formValidatorMessage : null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: text.formHintTextEmail,
              isDense: true,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (email) {
              return email!.trim().isEmpty ? text.formValidatorMessage : null;
            },
          ),
        ],
      ),
    );
  }
}
