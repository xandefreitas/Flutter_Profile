import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/skillsBloc/skills_bloc.dart';
import '../../../common/bloc/skillsBloc/skills_event.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../core/core.dart';

class ProfileSkillsAddChip extends StatelessWidget {
  const ProfileSkillsAddChip({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (ctx) {
          final skillTitlecontroller = TextEditingController();
          return CustomDialog(
            dialogTitle: text.skillsAddDialogTitle,
            dialogBody: TextFormField(controller: skillTitlecontroller),
            dialogAction: TextButton(
              onPressed: () {
                context.read<SkillsBloc>().add(SkillsAddEvent(skillTitle: skillTitlecontroller.text));
                Navigator.pop(context);
              },
              child: Text(text.skillsAddDialogAddButton),
            ),
            dialogColor: AppColors.profilePrimary,
          );
        },
      ),
      child: Chip(
        backgroundColor: AppColors.snackBarSuccess.withOpacity(0.8),
        elevation: 2,
        label: Text(
          '+',
          style: AppTextStyles.textSize24.copyWith(color: AppColors.white),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
