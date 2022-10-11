import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/core/core.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/work_history_info_button.dart';

import '../../../common/util/date_util.dart';

class WorkHistoryOccupationInfo extends StatelessWidget {
  final Occupation occupation;
  final bool isFirstElement;
  const WorkHistoryOccupationInfo({
    Key? key,
    required this.occupation,
    required this.isFirstElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedStartDate = DateUtil.formatDate(occupation.startDate);
    final String formattedEndDate = DateUtil.formatDate(occupation.endDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isFirstElement
            ? const SizedBox(height: 16)
            : Container(
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
