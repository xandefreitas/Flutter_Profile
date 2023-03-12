import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/core.dart';

class CertificateShimmerCard extends StatelessWidget {
  const CertificateShimmerCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        height: 104,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.certificatesPrimary.withOpacity(0.5),
        ),
      )
          .animate(
        onComplete: (controller) => controller.loop(),
      )
          .shimmer(
        duration: 800.ms,
        color: AppColors.certificatesPrimary.withOpacity(0.2),
        colors: [
          AppColors.certificatesPrimary.withOpacity(0.8),
          AppColors.white.withOpacity(0.4),
        ],
      ),
    );
  }
}
