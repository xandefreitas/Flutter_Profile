import 'package:flutter/material.dart';
import 'package:flutter_profile/core/core.dart';

class AnimatedRailButton extends StatefulWidget {
  final Color tabColor;
  final String title;
  final IconData iconSelected;
  final IconData iconUnselected;
  final int index;
  final bool isSelected;
  final Function(int, Color) changeScreen;
  const AnimatedRailButton({
    Key? key,
    required this.tabColor,
    required this.title,
    required this.iconSelected,
    required this.iconUnselected,
    required this.index,
    required this.isSelected,
    required this.changeScreen,
  }) : super(key: key);

  @override
  State<AnimatedRailButton> createState() => _AnimatedRailButtonState();
}

class _AnimatedRailButtonState extends State<AnimatedRailButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: animateCurrentTab,
      child: Container(
        height: 64,
        width: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.ease,
                  height: widget.isSelected ? 32 : 64,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: widget.isSelected
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                        : BorderRadius.circular(10),
                    color: widget.isSelected ? widget.tabColor.withOpacity(0.8) : AppColors.white,
                  ),
                ),
                Icon(
                  widget.isSelected ? widget.iconSelected : widget.iconUnselected,
                  color: widget.isSelected ? AppColors.white : AppColors.grey,
                ),
              ],
            ),
            Visibility(
              visible: widget.isSelected,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    style: AppTextStyles.textMedium.copyWith(
                      color: widget.tabColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void animateCurrentTab() {
    widget.changeScreen(widget.index, widget.tabColor);
  }
}
