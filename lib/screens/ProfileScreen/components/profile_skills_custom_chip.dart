import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/skillsBloc/skills_bloc.dart';
import '../../../common/bloc/skillsBloc/skills_event.dart';
import '../../../common/bloc/skillsBloc/skills_state.dart';
import '../../../common/models/skill.dart';
import '../../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';

class ProfileSkillsCustomChip extends StatefulWidget {
  final Skill skill;
  final bool isAdmin;
  final Function() sortSkills;
  const ProfileSkillsCustomChip({
    required this.skill,
    required this.isAdmin,
    required this.sortSkills,
    super.key,
  });

  @override
  State<ProfileSkillsCustomChip> createState() => _ProfileSkillsCustomChipState();
}

class _ProfileSkillsCustomChipState extends State<ProfileSkillsCustomChip> {
  Color? chipTextColor;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isRecommendingFinished = true;

  @override
  Widget build(BuildContext context) {
    chipTextColor = widget.skill.isRecommended ? chipTextColor = AppColors.white : chipTextColor = AppColors.profilePrimary.withValues(alpha: 0.8);
    final text = AppLocalizations.of(context)!;
    return BlocConsumer<SkillsBloc, SkillsState>(
      listener: (context, state) {
        if (state is SkillsUpdatedState) {
          isRecommendingFinished = true;
          widget.sortSkills();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onLongPress: widget.isAdmin
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      dialogTitle: text.skillsDeleteDialogTitle,
                      dialogBody: Text(
                        text.skillsDeleteDialogContent,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.profilePrimary,
                        ),
                      ),
                      dialogColor: AppColors.profilePrimary,
                      dialogAction: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.snackBarError,
                            ),
                            child: Text(text.skillsDeleteDialogCancelButton),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.profilePrimary,
                            ),
                            child: Text(text.skillsDeleteDialogConfirmButton),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              : null,
          onTap: !auth.currentUser!.isAnonymous
              ? isRecommendingFinished
                  ? onSkillSelected
                  : null
              : () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    AlertSnackBar(
                      title: text.alertSnackBarLoginTitle,
                      subtitle: text.alertSnackBarLoginMessage,
                    ),
                  );
                },
          child: Chip(
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.zero,
            backgroundColor: widget.skill.isRecommended ? AppColors.profilePrimary : AppColors.lightGrey,
            elevation: widget.skill.isRecommended ? 2 : 0,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.skill.title,
                  style: AppTextStyles.textSize12.copyWith(fontSize: 12, color: chipTextColor),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.skill.likesQuantity.toString(),
                  style: AppTextStyles.textSize12.copyWith(fontSize: 12, color: chipTextColor),
                ),
                const SizedBox(width: 4),
                Icon(
                  widget.skill.isRecommended ? Icons.thumb_up : Icons.thumb_up_outlined,
                  size: 12,
                  color: chipTextColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onDelete() {
    context.read<SkillsBloc>().add(SkillsRemoveEvent(skillId: widget.skill.id!));
  }

  void onSkillSelected() {
    isRecommendingFinished = false;
    context.read<SkillsBloc>().add(SkillsUpdateEvent(skill: widget.skill, userId: auth.currentUser!.uid));
  }
}
