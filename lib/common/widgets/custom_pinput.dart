import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../core/core.dart';

class CustomPinput extends StatefulWidget {
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
  State<CustomPinput> createState() => _CustomPinputState();
}

class _CustomPinputState extends State<CustomPinput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PinTheme defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: AppTextStyles.textSize16,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.profilePrimary),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Pinput(
      length: widget.length,
      controller: widget.controller,
      focusNode: _focusNode,
      onCompleted: widget.onCompleted,
      onTapOutside: (_) => _focusNode.unfocus(),
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
