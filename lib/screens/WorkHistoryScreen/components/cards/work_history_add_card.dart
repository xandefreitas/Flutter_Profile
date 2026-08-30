import 'package:flutter/material.dart';

import '../../../../common/enums/work_history_screen_mode.dart';
import '../../../../common/models/company.dart';
import '../../../../common/util/app_routes.dart';
import '../../../../common/widgets/custom_add_card.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

class WorkHistoryAddCard extends StatelessWidget {
  final Function(Company) addWorkHistory;
  const WorkHistoryAddCard({required this.addWorkHistory, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAddCard(
      color: AppColors.white.withValues(alpha: 0.2),
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
    );
  }
}
