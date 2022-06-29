import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final Color iconColor;
  const CustomIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 24),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            child: InkWell(
              onTap: onTap,
              child: Ink(
                height: 40,
                width: 40,
                color: AppColors.white,
                child: Icon(
                  icon,
                  size: 32,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
