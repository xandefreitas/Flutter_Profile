import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_event.dart';
import 'package:flutter_profile/common/util/shared_preferences_util.dart';
import 'package:flutter_profile/l10n/l10n.dart';
import '../../core/core.dart';
import '../bloc/languageBloc/language_bloc.dart';
import '../bloc/languageBloc/language_state.dart';

class LanguageWidget extends StatefulWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  final languageItems = L10n.all;
  String dropdownValue = 'pt';

  @override
  Widget build(BuildContext context) {
    context.read<LanguageBloc>().add(LanguageFetchEvent());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.language,
          color: AppColors.profilePrimary,
        ),
        const SizedBox(width: 4),
        BlocConsumer<LanguageBloc, LanguageState>(
          listener: (context, state) {
            if (state is LanguageFetchedState) {
              setState(() {
                dropdownValue = state.locale.languageCode;
              });
            }
          },
          builder: (context, state) {
            return DropdownButton(
              isDense: true,
              underline: const SizedBox(),
              style: AppTextStyles.textMedium.copyWith(color: AppColors.profilePrimary),
              iconEnabledColor: AppColors.profilePrimary,
              dropdownColor: AppColors.white,
              items: languageItems.map((e) => _buildMenuItem(e)).toList(),
              value: dropdownValue,
              onChanged: (String? selectedValue) {
                if (selectedValue is String) {
                  context.read<LanguageBloc>().add(LanguageUpdateEvent(locale: Locale(selectedValue)));
                  SharedPreferencesUtil.setLocale(Locale(selectedValue));
                }
              },
            );
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
