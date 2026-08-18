import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class PageNavButton extends StatelessWidget {
  final bool visible;
  final IconData icon;
  final VoidCallback onPressed;
  const PageNavButton({
    required this.visible,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      replacement: const SizedBox(width: 48),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: AppColors.workHistoryPrimary),
      ),
    );
  }
}
