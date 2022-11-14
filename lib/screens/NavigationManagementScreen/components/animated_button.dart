import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import '../../../core/app_colors.dart';

class AnimatedButton extends StatefulWidget {
  final Color tabColor;
  final String title;
  final IconData iconSelected;
  final IconData iconUnselected;
  final int index;
  final bool isSelected;
  final Function(int, Color) changeScreen;
  const AnimatedButton({
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
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: animateCurrentTab,
      child: AnimatedContainer(
        width: widget.isSelected ? 184 : 32,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
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
                    borderRadius: widget.isSelected
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
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
                  padding: const EdgeInsets.only(left: 8.0),
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
