import 'package:flutter/material.dart';

import '../../../common/models/occupation.dart';
import '../../../common/util/date_util.dart';
import '../../../core/core.dart';
import 'work_history_info_button.dart';

class WorkHistoryOccupationInfo extends StatelessWidget {
  final Occupation occupation;
  final bool isFirstElement;
  const WorkHistoryOccupationInfo({
    required this.occupation,
    required this.isFirstElement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedStartDate = DateUtil.formatDate(occupation.startDate);
    final String formattedEndDate = DateUtil.formatDate(occupation.endDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isFirstElement,
          replacement: Container(
            height: 32,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10),
            child: const Text(
              '|',
              style: TextStyle(
                color: AppColors.workHistoryPrimary,
              ),
            ),
          ),
          child: const SizedBox(height: 16),
        ),
        Row(
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
            ),
            const Spacer(),
            WorkHistoryInfoButton(occupation: occupation),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
