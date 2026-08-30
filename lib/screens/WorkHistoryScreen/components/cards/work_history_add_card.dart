import 'package:flutter/material.dart';

import '../../../../common/enums/work_history_screen_mode.dart';
import '../../../../common/models/company.dart';
import '../../../../common/util/app_routes.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

class WorkHistoryAddCard extends StatelessWidget {
  final Function(Company) addWorkHistory;
  const WorkHistoryAddCard({required this.addWorkHistory, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () => Navigator.pushNamed(
            context,
            workHistoryFormRoute,
            arguments: {
              'title': AppLocalizations.of(context)!.workHistoryFormTitleAdd,
              'addCompany': addWorkHistory,
              'screenMode': WorkHistoryScreenMode.ADD.value,
            },
          ),
      child: Container(
        height: 104,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.white.withValues(alpha: 0.2),
        ),
        child: const Icon(Icons.add, size: 40, color: AppColors.white),
      ),
    );
  }
}
