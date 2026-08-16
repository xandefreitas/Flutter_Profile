import 'package:flutter/material.dart';

import '../../../../common/widgets/shimmer_loop.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

class WorkHistoryShimmerCard extends StatelessWidget {
  const WorkHistoryShimmerCard({super.key});

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
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ).shimmerLoop(
        colors: [
          AppColors.workHistoryPrimary.withValues(alpha: 0.8),
          AppColors.workHistoryPrimary.withValues(alpha: 0.4),
        ],
      ),
    );
  }
}
