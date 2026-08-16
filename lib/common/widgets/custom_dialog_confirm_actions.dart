import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

/// The cancel/confirm button row used as [dialogAction] on delete-confirmation
/// [CustomDialog]s. Cancel just dismisses the dialog; confirm dismisses it and
/// then runs [onConfirm].
class CustomDialogConfirmActions extends StatelessWidget {
  final Color confirmColor;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback onConfirm;
  const CustomDialogConfirmActions({
    required this.confirmColor,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: AppColors.snackBarError),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
