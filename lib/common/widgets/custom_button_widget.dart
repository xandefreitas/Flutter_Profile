import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Function() onTap;
  final Widget icon;
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
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
                color: Colors.white,
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
