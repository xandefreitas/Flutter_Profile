import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/core.dart';
import '../../../data/icons_data.dart';

class DepositionShimmerCard extends StatelessWidget {
  final bool isRightSide;
  const DepositionShimmerCard({
    Key? key,
    required this.isRightSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconsData = IconsData;

    return Row(
      mainAxisAlignment: isRightSide ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 256),
                height: 92,
                padding: EdgeInsets.only(top: 8.0, right: isRightSide ? 16 : 8, left: isRightSide ? 8 : 16, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              )
                  .animate(
                onComplete: (controller) => controller.loop(),
              )
                  .shimmer(
                duration: 800.ms,
                color: AppColors.depositionsPrimary.withOpacity(0.2),
                colors: [
                  AppColors.depositionsPrimary.withOpacity(0.8),
                  AppColors.depositionsPrimary.withOpacity(0.4),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: isRightSide ? 20 : null,
              left: isRightSide ? null : 20,
              child: Image.asset(
                iconsData[0],
                color: AppColors.depositionsPrimary.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
