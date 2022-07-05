import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/core/core.dart';

class OccupationInfo extends StatelessWidget {
  final Occupation occupation;
  const OccupationInfo({
    Key? key,
    required this.occupation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.badge_outlined,
          color: AppColors.experiencesPrimary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              occupation.role,
              style: AppTextStyles.textSize12.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.experiencesPrimary,
              ),
            ),
            Text(
              '${occupation.sinceDate} - ${occupation.untilDate}',
              style: AppTextStyles.textSize12.copyWith(color: AppColors.experiencesPrimary),
            ),
          ],
        )
      ],
    );
  }
}
