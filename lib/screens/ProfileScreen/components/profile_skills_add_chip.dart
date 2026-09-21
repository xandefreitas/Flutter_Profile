import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/skillsBloc/skills_bloc.dart';
import '../../../common/bloc/skillsBloc/skills_event.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../common/widgets/custom_form_field.dart';
import '../../../core/core.dart';
import '../../../l10n/app_localizations.dart';

class ProfileSkillsAddChip extends StatelessWidget {
  const ProfileSkillsAddChip({super.key});
  final Color color = AppColors.profilePrimary;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) {
          final skillTitlecontroller = TextEditingController();
          return CustomDialog(
            dialogTitle: text.skillsAddDialogTitle,
            dialogBody: CustomFormField(
              controller: skillTitlecontroller,
              label: text.skillsAddDialogTitle,
            ),
            dialogAction: ElevatedButton(
              onPressed: () {
                context.read<SkillsBloc>().add(
                  SkillsAddEvent(skillTitle: skillTitlecontroller.text),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: Text(text.skillsAddDialogAddButton),
            ),
            dialogColor: color,
          );
        },
      ),
      child: Chip(
        backgroundColor: AppColors.snackBarSuccess.withValues(alpha: 0.8),
        elevation: 2,
        label: Icon(Icons.add, color: AppColors.white),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
