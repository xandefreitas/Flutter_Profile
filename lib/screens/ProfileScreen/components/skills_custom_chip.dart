import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_profile/common/widgets/custom_snackbar.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/app_text_styles.dart';

class SkillsCustomChip extends StatefulWidget {
  final Skill skill;
  final bool isLogged;
  const SkillsCustomChip({
    Key? key,
    required this.skill,
    this.isLogged = false,
  }) : super(key: key);

  @override
  State<SkillsCustomChip> createState() => _SkillsCustomChipState();
}

class _SkillsCustomChipState extends State<SkillsCustomChip> {
  Color? chipTextColor;

  @override
  Widget build(BuildContext context) {
    chipTextColor = widget.skill.isRecommended ? chipTextColor = AppColors.white : chipTextColor = AppColors.profilePrimary.withOpacity(0.8);
    return GestureDetector(
      onTap: widget.isLogged
          ? () {
              setState(() {
                widget.skill.isRecommended = !widget.skill.isRecommended;
              });
            }
          : () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                AlertSnackBar(
                  title: 'Faça login!',
                  subtitle: 'Para interagir com essa funcionalidade é necessário fazer login',
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
              widget.skill.likesQuantity,
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
  }
}
