import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/core/core.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/work_history_occupation_info.dart';

import '../../../../common/enums/work_history_screen_mode.dart';
import '../../../../common/util/app_routes.dart';

class WorkHistoryCard extends StatelessWidget {
  final Company company;
  final bool isAdmin;
  final Function(Company) updateWorkHistory;
  final Function(String) removeWorkHistory;
  const WorkHistoryCard({
    Key? key,
    required this.company,
    required this.isAdmin,
    required this.updateWorkHistory,
    required this.removeWorkHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                company.name,
                style: AppTextStyles.textSize16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              if (isAdmin)
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      workHistoryFormRoute,
                      arguments: {
                        "company": company,
                        "title": AppLocalizations.of(context)!.workHistoryFormTitleUpdate,
                        "updateCompany": updateWorkHistory,
                        "removeCompany": removeWorkHistory,
                        "screenMode": WorkHistoryScreenMode.UPDATE.value,
                      },
                    );
                  },
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
          const Divider(
            thickness: 1.5,
            color: AppColors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: 64.0 * company.occupations.length,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white.withOpacity(0.8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: company.occupations.reversed.map((e) {
                    return WorkHistoryOccupationInfo(
                      occupation: e,
                      isFirstElement: e.hashCode == company.occupations.last.hashCode,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
