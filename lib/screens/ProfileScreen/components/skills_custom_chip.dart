import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_profile/core/app_colors.dart';

import '../../../core/app_text_styles.dart';

class SkillsCustomChip extends StatefulWidget {
  final Skill skill;
  const SkillsCustomChip({
    Key? key,
    required this.skill,
  }) : super(key: key);

  @override
  State<SkillsCustomChip> createState() => _SkillsCustomChipState();
}

class _SkillsCustomChipState extends State<SkillsCustomChip> {
  Color? chipTextColor;
  @override
  @override
  Widget build(BuildContext context) {
    chipTextColor = widget.skill.isRecommended ? chipTextColor = AppColors.white : chipTextColor = AppColors.profilePrimary.withOpacity(0.8);
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.skill.isRecommended = !widget.skill.isRecommended;
        });
      },
      child: Chip(
        backgroundColor: widget.skill.isRecommended ? AppColors.profilePrimary : null,
        elevation: widget.skill.isRecommended ? 2 : 0,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.skill.title,
              style: AppTextStyles.textNormal12.copyWith(fontSize: 14, color: chipTextColor),
            ),
            const SizedBox(width: 16),
            Text(
              widget.skill.likesQuantity,
              style: AppTextStyles.textNormal12.copyWith(fontSize: 14, color: chipTextColor),
            ),
            const SizedBox(width: 4),
            Icon(
              widget.skill.isRecommended ? Icons.thumb_up : Icons.thumb_up_outlined,
              size: 14,
              color: chipTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
