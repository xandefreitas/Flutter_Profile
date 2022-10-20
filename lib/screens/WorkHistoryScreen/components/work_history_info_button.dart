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
      borderRadius: BorderRadius.circular(10),
      color: AppColors.workHistoryPrimary.withOpacity(0.8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => CustomDialog(
              dialogColor: AppColors.workHistoryPrimary,
              dialogTitle: occupation.role,
              dialogBody: Text(
                occupation.description,
                textAlign: TextAlign.justify,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Icon(
              Icons.read_more_outlined,
              color: AppColors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
