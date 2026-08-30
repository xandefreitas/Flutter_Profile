import 'package:flutter/material.dart';

import '../../core/core.dart';

class CustomAddCard extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  const CustomAddCard({required this.onTap, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 104,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          child: const Center(
            child: Icon(Icons.add, size: 40, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
