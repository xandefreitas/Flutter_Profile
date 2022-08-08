import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/core/core.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/work_history_occupation_info.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/work_history_info_button.dart';

class WorkHistoryScreenBody extends StatelessWidget {
  final Company company;
  const WorkHistoryScreenBody({
    Key? key,
    required this.company,
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '${company.occupations.first.sinceDate} -\n${company.occupations.last.untilDate}',
                  style: AppTextStyles.textSize12.copyWith(color: AppColors.white),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1.5,
            color: AppColors.white,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 64.0 * company.occupations.length,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white.withOpacity(0.8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: company.occupations.reversed.map((e) => WorkHistoryOccupationInfo(occupation: e)).toList(),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 64.0 * company.occupations.length,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: company.occupations.reversed.map((e) => WorkHistoryInfoButton(occupation: e)).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
