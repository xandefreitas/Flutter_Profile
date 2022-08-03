import 'package:flutter/material.dart';
import 'package:flutter_profile/core/core.dart';

class CustomDialog extends StatelessWidget {
  final String dialogTitle;
  final Widget dialogBody;
  final Color dialogColor;
  final Widget? dialogAction;
  const CustomDialog({
    Key? key,
    required this.dialogTitle,
    required this.dialogBody,
    required this.dialogColor,
    this.dialogAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: dialogColor, width: 4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dialogTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.textSize16.copyWith(
                color: dialogColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            dialogBody,
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: dialogAction,
            ),
          ],
        ),
      ),
    );
  }
}
