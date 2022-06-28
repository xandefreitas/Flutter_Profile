import 'package:flutter/material.dart';

import '../../../core/core.dart';

class OnboardingForm extends StatelessWidget {
  const OnboardingForm({
    Key? key,
    required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Antes de continuarmos, informe seu Nome e E-mail',
            style: AppTextStyles.textSize24.copyWith(
              color: AppColors.profilePrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Nome',
              hintStyle: const TextStyle(color: AppColors.profilePrimary),
              isDense: true,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.name,
            validator: (name) {
              return name!.trim().isEmpty ? 'Campo Obrigatório' : null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'E-mail',
              isDense: true,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (email) {
              return email!.trim().isEmpty ? 'Campo Obrigatório' : null;
            },
          ),
        ],
      ),
    );
  }
}
