import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../core/core.dart';

class CustomPinput extends StatelessWidget {
  final int length;
  final TextEditingController? controller;
  final void Function(String)? onCompleted;

  const CustomPinput({
    this.length = 6,
    this.controller,
    this.onCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: AppTextStyles.textSize16,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.profilePrimary),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      onCompleted: onCompleted,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        border: Border.all(color: AppColors.profilePrimary, width: 2),
      ),
      submittedPinTheme: defaultPinTheme.copyDecorationWith(
        color: AppColors.profilePrimary.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.profilePrimary),
      ),
    );
  }
}
