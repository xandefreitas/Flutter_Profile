import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/shared_preferences_util.dart';
import 'package:flutter_profile/l10n/l10n.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../provider/language_provider.dart';

class LanguageWidget extends StatefulWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  final languageItems = L10n.all;
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    dropdownValue = provider.locale.languageCode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.language,
          color: AppColors.profilePrimary,
        ),
        const SizedBox(width: 4),
        DropdownButton(
          isDense: true,
          underline: const SizedBox(),
          style: AppTextStyles.textMedium.copyWith(color: AppColors.profilePrimary),
          iconEnabledColor: AppColors.profilePrimary,
          dropdownColor: AppColors.white,
          items: languageItems.map((e) => _buildMenuItem(e)).toList(),
          value: dropdownValue,
          onChanged: (String? selectedValue) {
            if (selectedValue is String) {
              setState(() {
                dropdownValue = selectedValue;
                provider.setLocale(Locale(dropdownValue));
                SharedPreferencesUtil.setLocale(Locale(dropdownValue));
              });
            }
          },
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildMenuItem(Locale item) {
    return DropdownMenuItem(
      child: Text(item.languageCode == 'pt' ? 'Português' : 'English'),
      value: item.languageCode,
    );
  }
}
