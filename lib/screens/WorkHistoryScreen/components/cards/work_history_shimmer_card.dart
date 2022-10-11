import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/core.dart';

class WorkHistoryShimmerCard extends StatelessWidget {
  const WorkHistoryShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Shimmer.fromColors(
        highlightColor: AppColors.workHistoryPrimary.withOpacity(0.8),
        baseColor: AppColors.lightGrey.withOpacity(0.5),
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
                  AppLocalizations.of(context)!.workHistoryFormFieldCompanyLabel,
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 256,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white.withOpacity(0.8),
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
