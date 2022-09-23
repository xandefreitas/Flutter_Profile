import 'package:flutter/material.dart';

import '../../../../common/enums/work_history_screen_mode.dart';
import '../../../../common/models/company.dart';
import '../../../../common/util/app_routes.dart';
import '../../../../core/core.dart';

class WorkHistoryAddCard extends StatelessWidget {
  final Function(Company) addWorkHistory;
  const WorkHistoryAddCard({required this.addWorkHistory, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.home_work_outlined,
                  color: AppColors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add Work History',
                  style: AppTextStyles.textSize16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1.5,
              color: AppColors.white,
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                workHistoryFormRoute,
                arguments: {
                  "title": 'Add Work History',
                  "addCompany": addWorkHistory,
                  "screenMode": WorkHistoryScreenMode.ADD.value,
                },
              ),
              child: Container(
                height: 64.0 * 4,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white.withOpacity(0.5),
                ),
                child: const SizedBox(
                  height: 64,
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
