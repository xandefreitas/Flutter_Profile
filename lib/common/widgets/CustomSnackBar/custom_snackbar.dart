import 'package:flutter/material.dart';

import '../../../core/core.dart';
import 'components/custom_snackbar_body.dart';

abstract class CustomSnackBar extends SnackBar {
  const CustomSnackBar({
    Key? key,
    required Widget content,
  }) : super(
          key: key,
          content: content,
          duration: const Duration(seconds: 5),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
        );
}

class AlertSnackBar extends CustomSnackBar {
  AlertSnackBar({
    Key? key,
    required String title,
    required String subtitle,
  }) : super(
          key: key,
          content: CustomSnackBarBody(
            title: title,
            subtitle: subtitle,
            icon: Icons.info,
            snackBarColor: AppColors.snackBarAlert,
          ),
        );
}

class SuccessSnackBar extends CustomSnackBar {
  SuccessSnackBar({
    Key? key,
    required String title,
    required String subtitle,
  }) : super(
          key: key,
          content: CustomSnackBarBody(
            title: title,
            subtitle: subtitle,
            icon: Icons.check_circle,
            snackBarColor: AppColors.snackBarSuccess,
          ),
        );
}

class ErrorSnackBar extends CustomSnackBar {
  ErrorSnackBar({
    Key? key,
    required String title,
    required String subtitle,
  }) : super(
          key: key,
          content: CustomSnackBarBody(
            title: title,
            subtitle: subtitle,
            icon: Icons.error,
            snackBarColor: AppColors.snackBarError,
          ),
        );
}
