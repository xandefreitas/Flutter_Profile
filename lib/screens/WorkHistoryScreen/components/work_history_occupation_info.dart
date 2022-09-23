import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/core/core.dart';
import 'package:intl/intl.dart';

class WorkHistoryOccupationInfo extends StatelessWidget {
  final Occupation occupation;
  const WorkHistoryOccupationInfo({
    Key? key,
    required this.occupation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedStartDate = formatDate(occupation.startDate);
    final String formattedEndDate = formatDate(occupation.endDate);
    return Row(
      children: [
        const Icon(
          Icons.badge_outlined,
          color: AppColors.workHistoryPrimary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              occupation.role,
              style: AppTextStyles.textSize12.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.workHistoryPrimary,
              ),
            ),
            Text(
              '$formattedStartDate - $formattedEndDate',
              style: AppTextStyles.textSize12.copyWith(color: AppColors.workHistoryPrimary),
            ),
          ],
        )
      ],
    );
  }

  formatDate(String date) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }
}
