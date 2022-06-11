import 'package:flutter/material.dart';

import '../../../common/enums/nav_bar_items.dart';
import '../../../core/app_colors.dart';

class AnimatedButton extends StatefulWidget {
  final Color tabColor;
  final String title;
  final IconData iconSelected;
  final IconData iconUnselected;
  final NavBarIcons navBarIcons;
  final bool isSelected;
  final Function(NavBarIcons, Color) changeScreen;
  const AnimatedButton({
    Key? key,
    required this.tabColor,
    required this.title,
    required this.iconSelected,
    required this.iconUnselected,
    required this.navBarIcons,
    required this.isSelected,
    required this.changeScreen,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: animateProfileTab,
      child: AnimatedContainer(
        width: widget.isSelected ? 160 : 32,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.isSelected ? widget.tabColor.withOpacity(0.8) : AppColors.white,
                  ),
                ),
                Icon(
                  widget.isSelected ? widget.iconSelected : widget.iconUnselected,
                  color: widget.isSelected ? AppColors.white : AppColors.lightGrey,
                ),
              ],
            ),
            if (widget.isSelected)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    style: TextStyle(
                      color: widget.tabColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void animateProfileTab() {
    widget.changeScreen(widget.navBarIcons, widget.tabColor);
  }
}
