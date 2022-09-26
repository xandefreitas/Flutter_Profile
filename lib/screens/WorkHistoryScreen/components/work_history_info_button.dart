import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/common/widgets/custom_dialog.dart';
import 'package:flutter_profile/core/core.dart';

class WorkHistoryInfoButton extends StatelessWidget {
  final Occupation occupation;
  const WorkHistoryInfoButton({
    Key? key,
    required this.occupation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => CustomDialog(
              dialogColor: AppColors.workHistoryPrimary,
              dialogTitle: occupation.role,
              dialogBody: Text(occupation.description),
            ),
          );
        },
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            Ink(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.white,
              ),
            ),
            const Icon(
              Icons.info,
              color: AppColors.workHistoryPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
