import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_profile/common/widgets/custom_snackbar.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../common/bloc/skillsBloc/skills_bloc.dart';
import '../../../common/bloc/skillsBloc/skills_event.dart';
import '../../../common/bloc/skillsBloc/skills_state.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../core/app_text_styles.dart';

class ProfileSkillsCustomChip extends StatefulWidget {
  final Skill skill;
  final bool isAdmin;
  const ProfileSkillsCustomChip({
    Key? key,
    required this.skill,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<ProfileSkillsCustomChip> createState() => _ProfileSkillsCustomChipState();
}

class _ProfileSkillsCustomChipState extends State<ProfileSkillsCustomChip> {
  Color? chipTextColor;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late AppLocalizations text;
  bool isRecommendingFinished = true;

  @override
  Widget build(BuildContext context) {
    chipTextColor = widget.skill.isRecommended ? chipTextColor = AppColors.white : chipTextColor = AppColors.profilePrimary.withOpacity(0.8);
    text = AppLocalizations.of(context)!;
    return BlocConsumer<SkillsBloc, SkillsState>(
      listener: (context, state) {
        if (state is SkillsUpdatingState) {
          isRecommendingFinished = false;
        }
        if (state is SkillsUpdatedState) {
          isRecommendingFinished = true;
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onLongPress: widget.isAdmin
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      dialogTitle: 'Deletar Habilidade',
                      dialogBody: const Text(
                        'Você tem certeza que quer deletar essa habilidade da lista?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.profilePrimary,
                        ),
                      ),
                      dialogColor: AppColors.profilePrimary,
                      dialogAction: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              primary: AppColors.snackBarError,
                            ),
                          ),
                          ElevatedButton(
                            child: const Text('Confirmar'),
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.profilePrimary,
                            ),
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

  onDelete() {
    context.read<SkillsBloc>().add(SkillsRemoveEvent(skillId: widget.skill.id!));
  }

  onSkillSelected() {
    context.read<SkillsBloc>().add(SkillsUpdateEvent(skill: widget.skill, userId: auth.currentUser!.uid));
  }
}
