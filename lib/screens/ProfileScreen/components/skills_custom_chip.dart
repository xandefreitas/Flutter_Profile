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
  late AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    chipTextColor = widget.skill.isRecommended ? chipTextColor = AppColors.white : chipTextColor = AppColors.profilePrimary.withOpacity(0.8);
    text = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: widget.isLogged
          ? onSkillSelected
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
  }

  onSkillSelected() {
    setState(() {
      int value = widget.skill.likesQuantity;
      widget.skill.isRecommended ? value-- : value++;
      widget.skill.likesQuantity = value;
      widget.skill.isRecommended = !widget.skill.isRecommended;
    });
  }
}
